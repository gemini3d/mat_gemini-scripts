function plot3D_cart_frames_long_ENU_aspect(ymd,UTsec,xg,parm,parmlbl,caxlims,sourceloc,hf,cmap)

narginchk(4,9)
validateattributes(ymd, {'numeric'}, {'vector', 'numel', 3}, mfilename, 'year month day', 1)
validateattributes(UTsec, {'numeric'}, {'scalar'}, mfilename, 'UTC second', 2)
%plotparams.ymd = ymd; plotparams.utsec = UTsec;

validateattributes(xg, {'struct'}, {'scalar'}, mfilename, 'grid structure', 3)
validateattributes(parm, {'numeric'}, {'real'}, mfilename, 'parameter to plot',4)

if nargin<5, parmlbl=''; end
validateattributes(parmlbl, {'char'}, {'vector'}, mfilename, 'parameter label', 5)
%plotparams.parmlbl = parmlbl;

if nargin<6
  caxlims=[];
else
  validateattributes(caxlims, {'numeric'}, {'vector', 'numel', 2}, mfilename, 'plot intensity (min, max)', 6)
end
%plotparams.caxlims = caxlims;

if nargin<7 || isempty(sourceloc) % leave || for validate
  sourceloc = [];
else
  validateattributes(sourceloc, {'numeric'}, {'vector', 'numel', 2}, mfilename, 'source magnetic coordinates', 7)
end
if nargin<8 || isempty(hf)
  hf = figure();
end
if nargin<9 || isempty(cmap)
  cmap = parula(256);
end


%SOURCE LOCATION (SHOULD PROBABLY BE AN INPUT)
if (~isempty(sourceloc))
  sourcemlat=sourceloc(1);
  sourcemlon=sourceloc(2);
else
  sourcemlat=[];
  sourcemlon=[];
end


%SIZE OF SIMULATION
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
inds1=3:lx1+2;
inds2=3:lx2+2;
inds3=3:lx3+2;
Re=6370e3;


%JUST PICK AN X3 LOCATION FOR THE MERIDIONAL SLICE PLOT, AND AN ALTITUDE FOR THE LAT./LON. SLICE
% ix3=floor(lx3/2);
%plotparams.altref=300;
altref=300;


%SIZE OF PLOT GRID THAT WE ARE INTERPOLATING ONTO
meantheta=mean(xg.theta(:));
y=-1*(xg.theta-meantheta);   %this is a mag colat. coordinate and is only used for defining grid in linspaces below, runs backward from north distance, hence the negative sign
x=xg.x2(inds2)/Re/sin(meantheta);
% z=xg.alt/1e3;
lxp=1024;
lyp=1024;
% lzp=500;
minx=min(x(:));
maxx=max(x(:));
miny=min(y(:));
maxy=max(y(:));
% minz=min(z(:));
% maxz=max(z(:));
xp=linspace(minx,maxx,lxp);     %eastward distance (rads.)
yp=linspace(miny,maxy,lyp);     %should be interpreted as northward distance (in rads.).  Irrespective of ordering of xg.theta, this will be monotonic increasing!!!
% zp=linspace(minz,maxz,lzp)';     %altitude (kilometers)


%INTERPOLATE ONTO PLOTTING GRID
% [X,Z]=meshgrid(xp,zp*1e3);    %meridional meshgrid, this defines the grid for plotting


%% CONVERT TO DISTANCE UP, EAST, NORTH
% x1plot=Z(:);   %upward distance
% x2plot=X(:)*Re*sin(meantheta);     %eastward distance

% parmtmp=parm(:,:,ix3);
% parmp=interp2(xg.x2(inds2),xg.x1(inds1),parmtmp,x2plot,x1plot);
% parmp=reshape(parmp,[lzp,lxp]);    %slice expects the first dim. to be "y" ("z" in the 2D case)


%% LAT./LONG. SLICE COORDIANTES
zp2=[altref-10,altref,altref+10];
lzp2=numel(zp2);
[X2,Y2,Z2]=meshgrid(xp,yp,zp2*1e3);       %lat./lon. meshgrid, need 3D since and altitude slice cuts through all 3 dipole dimensions

x1plot=single(Z2(:));   %upward distance
x2plot=X2(:)*Re*sin(meantheta);     %eastward distance - needs to be fixed to be theta-dependent (e.g. sin theta)
x3plot=Y2(:)*Re;     %northward distance;

parmtmp=permute(parm,[3,2,1]);     %so north dist, east dist., alt.
x3interp=xg.x3(inds3);  %this is northward distance - again backwards from yp
x3interp=x3interp(:);     %interp doesn't like it unless this is a column vector
parmp2=interp3(xg.x2(inds2),x3interp,xg.x1(inds1),parmtmp,x2plot,x3plot,x1plot);
parmp2=reshape(parmp2,[lyp,lxp,lzp2]);    %slice expects the first dim. to be "y"


%% ALT/LAT SLICE
% [Y3,Z3]=meshgrid(yp,zp*1e3);

% x1plot=Z3(:);   %upward distance
% x3plot=Y3(:)*Re;     %northward distance;

% ix2=floor(lx2/2);
% parmtmp=squeeze(parm(:,ix2,:));     %so north dist, east dist., alt.

% parmp3=interp2(xg.x3(inds3),xg.x1(inds1),parmtmp,x3plot,x1plot);
% parmp3=reshape(parmp3,[lzp,lyp]);    %slice expects the first dim. to be "y"


%% CONVERT ANGULAR COORDINATES TO MLAT,MLON
yp=yp*Re/1e3; %(km)
[yp,inds]=sort(yp);
parmp2=parmp2(inds,:,:);
% parmp3=parmp3(:,inds);

%xp=(xp+meanphi)*180/pi;
xp=xp*Re*sin(meantheta)/1e3;    %eastward ground distance (km)
[xp,inds]=sort(xp);
% parmp=parmp(:,inds,:);
parmp2=parmp2(:,inds,:);


%COMPUTE SOME BOUNDS FOR THE PLOTTING
minxp=min(xp(:));
maxxp=max(xp(:));
% minyp=min(yp(:));
% maxyp=max(yp(:));


%NOW THAT WE'VE SORTED, WE NEED TO REGENERATE THE MESHGRID
FS=8;

%MAKE THE PLOT!
% ha=subplot(1,3,1, 'parent', hf, 'nextplot', 'add', 'FontSize',FS);
% h=imagesc(ha,yp,zp,fliplr(parmp3));    %need to flip to be consxistent with rotation
% plot(ha,[minyp,maxyp],[altref,altref],'w--','LineWidth',2);
% if (~isempty(sourcemlat))
%   plot(ha,sourcemlat,0,'r^','MarkerSize',12,'LineWidth',2);
% end
% set(h,'alphadata',~isnan(parmp));
%
% tight_axis(ha)
% colormap(ha,cmap)
% clim(ha,caxlims)
% c=colorbar(ha);
% xlabel(c,parmlbl);
% xlabel(ha,'eastward distance (km)');
% ylabel(ha,'altitude (km)');


%ha=subplot(1,3,2, 'parent', hf, 'nextplot', 'add', 'FontSize',FS);
ha=gca(hf);
h=imagesc(ha,xp(2:end-1),yp(2:end-1),parmp2(2:end-1,2:end-1,2));
axis(ha,'xy');
axis(ha,'equal');    %fix the aspect ratio...
axis(ha,'tight');
if (~isempty(sourcemlat))
  plot(ha,[minxp,maxxp],[sourcemlon,sourcemlon],'w--','LineWidth',2);
  plot(ha,sourcemlat,sourcemlon,'r^','MarkerSize',12,'LineWidth',2);
end
set(h,'alphadata',~isnan(rot90(parmp2(2:end-1,2:end-1,2),-1)));

%tight_axis(ha);
colormap(ha,cmap);
clim(ha,caxlims);
c=colorbar(ha);
xlabel(c,parmlbl);
ylabel(ha,'y (km)');
xlabel(ha,'x (km)');

%% CONSTRUCT A STRING FOR THE TIME AND DATE
time=datetime([ymd,0,0,UTsec], Format='HH:mm:ss');
%ttxt=sprintf('%6.1f s',UTsec-28500);
ttxt= string(time);
title(ha, ttxt);
set(ha,'FontSize',FS);

% ha=subplot(1,3,3, 'parent', hf, 'nextplot', 'add', 'FontSize',FS);
% h=imagesc(ha,xp,zp,parmp);
% %plot([minyp,maxyp],[altref,altref],'w--','LineWidth',2);
% if (~isempty(sourcemlat))
%   plot(ha,sourcemlat,0,'r^','MarkerSize',12,'LineWidth',2);
% end
% set(h,'alphadata',~isnan(parmp3))
%
% tight_axis(ha)
% colormap(ha,cmap)
% clim(ha,caxlims)
% c=colorbar(ha);
% xlabel(c,parmlbl);
% xlabel(ha,'northward distance (km)')
% ylabel(ha,'altitude (km)')

end
