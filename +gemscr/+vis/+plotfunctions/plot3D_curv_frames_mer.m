function h=plot3D_curv_frames_mer(ymd,UTsec,xg,parm,parmlbl,caxlims,sourceloc,h)

%CLEAR AND SET FIGURE HANDLES
%clf;
%h=gcf;
%set(h,'PaperPosition',[0 0 11 4.5]);
%CLEAR AND SET FIGURE HANDLES
%clf;
%h=gcf;
%CLEAR AND SET FIGURE HANDLES
if (nargin<8)
    clf;
    h=gcf;
end
set(h,'PaperPosition',[0 0 11 4.5]);


%REORGANIZE INPUT
dmy(1)=ymd(3);
dmy(2)=ymd(2);
dmy(3)=ymd(1);
t=UTsec/3600;     %convert to UT hours


%SOURCE LOCATION (SHOULD PROBABLY BE AN INPUT)
if (~isempty(sourceloc))
  sourcemlat=sourceloc(1);
  sourcemlon=sourceloc(2);
  flagsource=1;
else
  flagsource=0;
end

%SIZE OF SIMULATION
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
inds1=3:lx1+2;
inds2=3:lx2+2;
inds3=3:lx3+2;
Re=6370e3;


%JUST PICK AN X3 LOCATION FOR THE MERIDIONAL SLICE PLOT, AND AN ALTITUDE FOR THE LAT./LON. SLICE
ix3=floor(lx3/2);
altref=300;


%SOME FILTERING OUT OF GARBAGE
inds=xg.alt<75e3;
parm(inds)=0e0;


%SIZE OF PLOT GRID THAT WE ARE INTERPOLATING ONTO
meantheta=mean(xg.theta(:));
meanphi=mean(xg.phi(:));
x=(xg.theta-meantheta);   %this is a mag colat. coordinate and is only used for defining grid in linspaces below
y=(xg.phi-meanphi);       %mag. lon coordinate
z=xg.alt/1e3;
%lxp=500;
lxp=3000;
lyp=500;
lzp=1000;
minx=min(x(:));
maxx=max(x(:));
miny=min(y(:));
maxy=max(y(:));
%minz=min(z(:));
minz=-10e0;     %to give some space for the marker on th plots
maxz=max(z(:));
xp=linspace(minx,maxx,lxp);
yp=linspace(miny,maxy,lyp);
zp=linspace(minz,maxz,lzp)';

%{
%ix1s=floor(lx1/2):lx1;    %only valide for a grid which is symmetric aboutu magnetic equator... (I think)
ix1s=find(xg.x1(inds1)>=0);    %works for asymmetric grids
minz=0;
maxz=max(xg.alt(:));
[tmp,ix1]=min(abs(xg.alt(ix1s,1,1)-maxz*1e3));
ix1=ix1s(ix1);
thetavals=xg.theta(ix1:lx1,:,:);
meantheta=mean(thetavals(:));
phivals=xg.phi(ix1:lx1,:,:);
meanphi=mean(phivals(:));
x=(thetavals-meantheta);      %this is a mag colat. coordinate and is only used for defining grid in linspaces below and the parametric surfaces in the plots
y=(phivals-meanphi);          %mag. lon coordinate
z=xg.alt(ix1:lx1,:,:)/1e3;    %altitude
lxp=500;
lyp=500;
lzp=500;
minx=min(x(:));
maxx=max(x(:));%+0.5*(max(x(:))-min(x(:)));
miny=min(y(:));
maxy=max(y(:));
xp=linspace(minx,maxx,lxp);
yp=linspace(miny,maxy,lyp);
zp=linspace(minz,maxz,lzp)';
%}


%INTERPOLATE ONTO PLOTTING GRID
[X,Z]=meshgrid(xp,zp*1e3);    %meridional meshgrid


%DIRECT TO SPHERICAL
rxp=Z(:)+Re;
thetaxp=X(:)+meantheta;
%phixp=Y(:)+meanphi;


%NOW SPHERICAL TO DIPOLE
qplot=(Re./rxp).^2.*cos(thetaxp);
pplot=rxp/Re./sin(thetaxp).^2;
%phiplot=phixp;    %phi is same in spherical and dipole


%-----NOW WE CAN DO A `PLAID' INTERPOLATION - THIS ONE IS FOR THE MERIDIONAL SLICE
parmtmp=parm(:,:,ix3);
parmp=interp2(xg.x2(inds2),xg.x1(inds1),parmtmp,pplot,qplot);
parmp=reshape(parmp,lzp,lxp);    %slice expects the first dim. to be "y" ("z" in the 2D case)


%LAT./LONG. SLICE COORDIANTES
zp2=[290,300,310];
lzp2=3;
[X2,Y2,Z2]=meshgrid(xp,yp,zp2*1e3);       %lat./lon. meshgrid, need 3D since and altitude slice cuts through all 3 dipole dimensions

rxp2=Z2(:)+Re;
thetaxp2=X2(:)+meantheta;
phixp2=Y2(:)+meanphi;

qplot2=(Re./rxp2).^2.*cos(thetaxp2);
pplot2=rxp2/Re./sin(thetaxp2).^2;
phiplot2=phixp2;    %phi is same in spherical and dipole


%-----NOW WE CAN DO A `PLAID' INTERPOLATION - THIS ONE IS FOR THE LAT/LON SLICE
parmtmp=permute(parm,[3,2,1]);
x3interp=xg.x3(inds3);
x3interp=x3interp(:);     %interp doesn't like it unless this is a column vector
parmp2=interp3(xg.x2(inds2),x3interp,xg.x1(inds1),parmtmp,pplot2,phiplot2,qplot2);
parmp2=reshape(parmp2,lyp,lxp,lzp2);    %slice expects the first dim. to be "y"


%ALT./LONG. SLICE COORDIANTES
if (flagsource)
  sourcetheta=pi/2-sourcemlat*pi/180;
else
  thetaref=mean(mean(xg.theta(1:floor(end/2),:,:)));
  sourcetheta=thetaref;
end
sourcex=sourcetheta-meantheta;
xp3=[sourcex-1*pi/180,sourcex,sourcex+1*pi/180];    %place in the plane of the source
lxp3=numel(xp3);
zp3=linspace(minz,750,500);
% minzp3=min(zp3);
% maxzp3=max(zp3);
lzp3=numel(zp3);
[X3,Y3,Z3]=meshgrid(xp3,yp,zp3*1e3);       %lat./lon. meshgrid, need 3D since and altitude slice cuts through all 3 dipole dimensions

rxp3=Z3(:)+Re;
thetaxp3=X3(:)+meantheta;
phixp3=Y3(:)+meanphi;

qplot3=(Re./rxp3).^2.*cos(thetaxp3);
pplot3=rxp3/Re./sin(thetaxp3).^2;
phiplot3=phixp3;    %phi is same in spherical and dipole


%-----NOW WE CAN DO A `PLAID' INTERPOLATION - THIS ONE IS FOR THE LONG/ALT SLICE
%parmtmp=permute(parm,[3,2,1]);
parmp3=interp3(xg.x2(inds2),x3interp,xg.x1(inds1),parmtmp,pplot3,phiplot3,qplot3);
parmp3=reshape(parmp3,lyp,lxp3,lzp3);    %slice expects the first dim. to be "y"


%CONVERT ANGULAR COORDINATES TO MLAT,MLON
xp=90-(xp+meantheta)*180/pi;
[xp,inds]=sort(xp);
parmp=parmp(:,inds);
parmp2=parmp2(:,inds,:);
%parmp3=parmp3(:,inds,:);

yp=(yp+meanphi)*180/pi;
[yp,inds]=sort(yp);
%parmp=parmp(inds,:,:);
parmp2=parmp2(inds,:,:);
parmp3=parmp3(inds,:,:);


%COMPUTE SOME BOUNDS FOR THE PLOTTING
minxp=min(xp(:));
maxxp=max(xp(:));
% minyp=min(yp(:));
% maxyp=max(yp(:));
minzp=min(zp(:));
maxzp=max(zp(:));


%NOW THAT WE'VE SORTED, WE NEED TO REGENERATE THE MESHGRID
%[XP,YP,ZP]=meshgrid(xp,yp,zp);
FS=8;

%MAKE THE PLOT!
subplot(1,3,1:2);
h=imagesc(xp,zp,parmp);
hold on;
if (flagsource)
  plot([minxp,maxxp],[altref,altref],'w--','LineWidth',1);
  plot([sourcemlat,sourcemlat],[minzp,maxzp],'k--','LineWidth',1);
  plot(sourcemlat,0,'r^','MarkerSize',6,'LineWidth',2);
end
hold off;
set(h,'alphadata',~isnan(parmp));
set(gca,'FontSize',FS);
axis xy;
colormap(parula(256));
clim(caxlims)
c=colorbar;
xlabel(c,parmlbl);
xlabel('magnetic latitude (deg.)');
ylabel('altitude (km)');

UThrs=floor(t);
UTmin=floor((t-UThrs)*60);
UTsec=floor((t-UThrs-UTmin/60)*3600);
UThrsstr=num2str(UThrs);
UTminstr=num2str(UTmin);
if (numel(UTminstr)==1)
  UTminstr=['0',UTminstr];
end
UTsecstr=num2str(UTsec);
if (numel(UTsecstr)==1)
  UTsecstr=['0',UTsecstr];
end

timestr=[UThrsstr,':',UTminstr,':',UTsecstr];
strval=sprintf('%s \n %s',[num2str(dmy(2)),'/',num2str(dmy(1)),'/',num2str(dmy(3))], ...
    [timestr,' UT']);
title(strval);


subplot(1,3,3);
%h=imagesc(xp,yp,parmp2(:,:,2));
h=imagesc(yp,xp,parmp2(:,:,2)');    %so latitude is the vertical axis
hold on;
if (flagsource)
  %plot([minxp,maxxp],[sourcemlon,sourcemlon],'w--','LineWidth',2);
  %plot(sourcemlat,sourcemlon,'r^','MarkerSize',12,'LineWidth',2);
%  plot([sourcemlon,sourcemlon],[minxp,maxxp],'w--','LineWidth',1);
  plot(sourcemlon,sourcemlat,'r^','MarkerSize',6,'LineWidth',2);
end
hold off;
%set(h,'alphadata',~isnan(parmp2(:,:,2)));
set(h,'alphadata',~isnan(parmp2(:,:,2)'));
set(gca,'FontSize',FS);
axis xy;
%axis equal;
axis tight;
colormap(parula(256));
clim(caxlims)
c=colorbar;
xlabel(c,parmlbl);
%xlabel('magnetic latitude (deg.)');
%ylabel('magnetic longitude (deg.)');
xlabel('magnetic long. (deg.)');
ylabel('magnetic lat. (deg.)');


%{
subplot(133);
h=imagesc(yp,zp3,squeeze(parmp3(:,2,:))');    %so latitude is the vertical axis
hold on;
if (flagsource)
%  plot([sourcemlon,sourcemlon],[minzp3,maxzp3],'k--','LineWidth',1);
  plot(sourcemlon,0,'r^','MarkerSize',6,'LineWidth',2);
end
hold off;
%set(h,'alphadata',~isnan(squeeze(parmp3(:,2,:))'));
set(gca,'FontSize',FS);
axis xy;
axis tight;
colormap(parula(256));
clim(caxlims)
c=colorbar;
xlabel(c,parmlbl);
xlabel('magnetic long. (deg.)');
ylabel('altitude (km)');
%}

end
