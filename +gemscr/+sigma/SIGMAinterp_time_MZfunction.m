%Modified by MZ, 20180817 to add hmf2 determination.  Some additional comments:
%  1)  Note that we can also probably do some memory management to cut down on usage,
%      but I'll leave that for later.
%  2)  MZ needs to integrate the latest GEMINI i/o into this at some point
%      so that it doesn't lag too far behind the main repository

%Modified by MZ, 20181011 rotate simulation results so that our patch is E-W extended
% and propagating N-S.  Some additional comments:
%  1)  In general we don't want to always run with these adjustments, so be
%  careful with this version.  One can turn off the rotation using the
%  flagrot=0;
%  2)  Suggested additions above still need to be made eventually...

%Modified by MZ, 20181017 fixed error introduced by above rotations


function [nei,zctr] = SIGMAinterp_time_MZfunction(plasmatype,tinterp,dcoord,x,y,dt,dz,nz,hmF2)
addpath ../script_utils;

addpath scripts_MZ-modKD/;
clear numden

flagrot=1;    %do we want to rotation E-W to N-S?

%SIMULATION TO BE USED
%direc='/media/data/GDI/KHI_lowres_periodic_ne/'
%direc='/home/zettergm/simulations/KHI_periodic_highres/'
%direc=['/Users/kshitijadeshpande/kshitija/MattZGDItest_hugesize/',plasmatype,'_periodic_highres/'];

%direc='/Volumes/Untitled/GDI_8to1_2e12/';

%SIGMA3 simulations on Celerity July 2018
%direc='/home/deshpank/simulations/GDI_sigma3/';
%GDI_periodic_highres_fileinput_large/';

direc=['/home/deshpank/simulations/',plasmatype,'_sigma3_6e11/'];

%WHAT TIME DO THE DATA NEED TO BE INTERPOLATED TO?
% tinterp=200.4;   %whatever time interval you want 50Hz data for (just give any time within the interval), this is time after the simulation start


%LOAD CONFIG FILE TO SEE WHAT THE START TIMES ARE AND WHAT DT IS FOR THE SPECIFIED RUN
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=gemini3d.read.config([direc,'inputs/config.ini']);


% %NOW CREATE A FINE MESH SIMILAR TO WHAT SIGMA USES THIS IS USER ADJUSTABLE
% fprintf('\nCreating grid for interpolation...')
% mincoord=-25e3;                %these need to be adjusted to whatever part of the simulation is interesting
% maxcoord=25e3;
% x=mincoord:dcoord:maxcoord;    %recast everything as  (E,N,U)=(x,y,z)
% mincoord=-25e3;     %for GDItest
% maxcoord=25e3;
% y=mincoord:dcoord:maxcoord;

% KD 20171130 fix it
% x rearrange (subtracting is shifting everything in the other direction
% (possibly to do with ENU to WSU)
if strcmp(plasmatype, 'GDI')
	shiftx = 55000;% for GDI
else % it is KHI
	shiftx = 35000;% for KHI
end
x = x + shiftx;


%LOAD FRAME  DATA FROM ZETTERGREN ET AL 2015 MODEL
lfile=floor(tinterp/dtout);   %number of files from beginning
lfilestart=lfile*dtout;
lfileend=(lfile+1)*dtout;


%COMPUTE THE UT INFO FOR THE FIRST FRAME OF INTEREST
[ymd,UTsec]=dateinc(lfilestart,ymd0,UTsec0);
loadframe_wrapper; % this creates the filename
x1=xg.x1(3:end-2)';
x2=xg.x2(3:end-2)';
x3=xg.x3(3:end-2);
numden=permute(numden,[3,2,1]);   %to arrange things as y,x,z (lat (x3 - mpi'd dim),lon (x2) ,alt (x1)) - see model grid generation source code


%MZ 20180817 - HMF2 DETERMINATION, IF NEEDED
if (isempty(hmF2) | ~exist('hmF2','var'))   %need to compute hmF2 if it is not given
  neavg=mean(mean(numden,2),1);     %average density profile for the entire grid
  neavg=squeeze(neavg);
  lz=numel(neavg);
  [zmax,iz]=max(neavg);
  if (iz>1 & iz<lz)   %fit a parabola to the 3 points around max and compute hmF2 from that
    nesamp=neavg(iz-1:iz+1);
    zfit=x1(iz-1:iz+1);
    zfit=zfit(:);
    A=[ones(3,1),zfit,zfit.^2];
    coeffs=A\nesamp;
    zctr=-1*coeffs(2)/2/coeffs(3);     %max of parabolic fit - gets a subgrid estimate of hmF2 so we can center SIGMA grid
  else    %something weird is going on so make something up here
    zctr=300e3;
  end
else
  zctr=hmF2;    %use given hmF2 for center altitude of the grid
end
fprintf('Taking zctr=%f\n',zctr);


%CREATE ALTITUDE GRID
mincoord=zctr-dz*(nz-1)/2;
maxcoord=zctr+dz*(nz-1)/2;
z=mincoord:dz:maxcoord;


%CREATE THE GRID
[X,Y,Z]=meshgrid(x,y,z);
lx=numel(x);
ly=numel(y);
lz=numel(z);


imagesc(x,y,numden(:,:,30))
axis xy;
xlabel('x');
ylabel('y');
c=colorbar;
ylabel(c,'n_e');


%THIS DATA SET IS ACTUALLY SMALLER THAN THE REGION SIGMA WORKS ON SO TILE IT (IT'S PERIODIC ANYWAY)
if (max(y)-min(y)>max(xg.x3)-min(xg.x3))
%   fprintf('Tiling grid and output.\n');
  dx3=x3(2)-x3(1);
  lx3=numel(x3);
  x3plus=zeros(1,lx3);
  x3minus=zeros(1,lx3);
  for ix3=1:lx3
    x3plus(ix3)=x3(lx3)+ix3*dx3;
    x3minus(lx3-ix3+1)=x3(1)-ix3*dx3;
  end
  x3=[x3minus(:);x3(:);x3plus(:)];
  numden=cat(1,numden,numden,numden);
  ne1=numden;
else
  ne1=numden;
end


% fprintf('\nBeginning spatial interpolation for file:  %s...\n',filename);
neinterp1=interp3(x2,x3,x1,ne1,X,Y,Z);    %electron density


%CORRECT ANY EXTRAPOLATION THAT HAS OCCURRED IN THE X2 DIRECTION
indsminx2=find(x<min(x2));
indedgemin=max(indsminx2)+1;
% if (~isempty(indsminx2))
%   fprintf('Correcting extrapolation (min(x2) side).\n');
% end
neinterp1(:,indsminx2,:)=repmat(neinterp1(:,indedgemin,:),[1,numel(indsminx2),1]);
indsmaxx2=find(x>max(x2));
indedgemax=min(indsmaxx2)-1;
% if (~isempty(indsmaxx2))
%   fprintf('Correcting extrapolation (max(x2) side).\n');
% end
neinterp1(:,indsmaxx2,:)=repmat(neinterp1(:,indedgemax,:),[1,numel(indsmaxx2),1]);


%NOW LOAD THE SECOND FILE
[ymd,UTsec]=dateinc(lfileend,ymd0,UTsec0);
loadframe_wrapper;
numden=permute(numden,[3,2,1]);


%CHECK WHETHER DATA NEED TO BE TILED
if (max(y)-min(y)>max(xg.x3)-min(xg.x3))
%   fprintf('Tiling output.\n');
  numden=cat(1,numden,numden,numden);
  ne2=numden;
else
  ne2=numden;
end


% fprintf('\nBeginning spatial interpolation for file:  %s...\n',filename);
neinterp2=interp3(x2,x3,x1,ne2,X,Y,Z);


%CORRECT ANY EXTRAPOLATION THAT HAS OCCURRED IN THE X2 DIRECTION
neinterp2(:,indsminx2,:)=repmat(neinterp2(:,indedgemin,:),[1,numel(indsminx2),1]);
neinterp2(:,indsmaxx2,:)=repmat(neinterp2(:,indedgemax,:),[1,numel(indsmaxx2),1]);


% %NOW DO TEMPORAL INTERPOLATION IN TIME TO 50 HZ
% fprintf('\nBeginning temporal interpolations...\n');

dti=dt;    %desired output rate
lt=round((lfileend-lfilestart)/dti);    %number of time samples for interpolated data
%this works for even sampling frequency for 0.5s file cadence: KD 20171128
%note
ti=linspace(lfilestart,lfileend,lt+1); %KD change lt -> lt+1
nei=zeros(ly,lx,lz,lt);
for iit=1:lt
  slope=(neinterp2-neinterp1)/(lfileend-lfilestart);
  nei(:,:,:,iit)=neinterp1+slope*(ti(iit)-lfilestart);
end


% figure;
% iz=min(find(z>300e3));
% for iit=1:1
%   imagesc(x,y,nei(:,:,iz,iit))
%   axis xy;
%   xlabel('x');
%   ylabel('y');
%   c=colorbar;
%   ylabel(c,'n_e');
%
% end


%BEFORE WE TRANSFORM INTO KAY'S COORDINATES WE (MAY) WANT TO ROTATE THE
%PATCH TO BE E-W ALIGNED:  MZ 20181016
if (flagrot)
  nei=permute(nei,[2,1,3,4]);   %this swaps the data 2 and 1 dimensions so that it now thinks E-W in the simulation is N-S
  tmpx=x;
  x=y;
  y=tmpx;    %now swap the x,y arrays to maintain conformability with the permuted nei array
end


%At this point we have x,y,z as the three coords (east, north, up), ti as the time variable  with interpolated electron density nei(ix,iy,iz,iit), where ix,iy,iz index the x,y,z arrays and iit is the index into the ti array.
%THESE FEW LIENS CONVERT FROM ENU (GEMINI) TO WSU (SIGMA expects)
x=flip(-1*x(:),1);
x=x';     %since x-axis is usually a row vector
y=flip(-1*y(:),1);
nei=flip(nei,1);
nei=flip(nei,2);



% % %GENERATE A SET of SANITY-CHECK PLOT FROM NEAR F-REGION PEAK
% fprintf('\nStarting diagnostic output...\n');
% iz=min(find(z>300e3));
%
% figure;
% for iit=1:1
% %   clf;
%   imagesc(x,y,nei(:,:,iz,iit))
%   axis xy;
%   xlabel('x');
%   ylabel('y');
%   c=colorbar;
%   ylabel(c,'n_e');
%
% end
%
%   filename=['./plots/ne',num2str(iit),'_test.png']
%   print('-dpng',filename);

rmpath ../script_utils
clearvars -except nei zctr

end
