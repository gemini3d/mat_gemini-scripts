% %EXAMPLE PARAMETERS
% dtheta=10;
% dphi=10;
% lp=35;
% lq=350;
% lphi=48;
% altmin=80e3;
% glat=25;    %low-latitude, low resolution (for visualizing the grid)
% glon=270;
% gridflag=1;
%
% % %EXAMPLE PARAMETERS
% % dtheta=10;
% % dphi=10;
% % lp=35;
% % lq=350;
% % lphi=48;
% % altmin=80e3;
% % glat=25;    %low-latitude
% % glon=270;
% % gridflag=1;
%
% % dtheta=2;
% % dphi=5;
% % lp=35;
% % lq=200;
% % lphi=44;
% % altmin=80e3;
% % glat=65;    %high-latitude
% % glon=270;
% % gridflag=0;
%
%


%TOHOKU-LIKE GRID
dang=7.5;
dtheta=dang;
dphi=dang+2;    %to make sure we encapsulate the neutral grid long. extent
lp=400;
lq=750;
lphi=25;
altmin=80e3;
%glat=43.95;    %WRONG!!!
glat=42.45;
glon=143.4;
gridflag=1;

%RUN THE GRID GENERATION CODE
if ~exist('ns', 'var')
    load /Volumes/SDHCcard/simulations/tohoku_strong_narrow_nonuniform/input.mat;
    xg2=ingem.xg;
%    load /Volumes/SDHCcard/simulations/tohoku_strong_narrow_nonuniform/20110311_21803.mat;
    load /Volumes/SDHCcard/simulations/tohoku_strong_narrow_nonuniform/20110311_21553.mat;
    load /Volumes/SDHCcard/simulations/tohoku_strong_narrow_nonuniform/current_21553.mat;
    ne=ns(:,:,7);
    xg= gemini3d.grid.tilted_dipole(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);
    neI=interp2(xg2.x2,xg2.x1,ne,xg.x2(3:end-2),xg.x1(3:end-2));
    neIspread=repmat(neI,[1,1,lphi]);
    vi=vsx1(:,:,1);
    viI=interp2(xg2.x2,xg2.x1,vi,xg.x2(3:end-2),xg.x1(3:end-2));
    viIspread=repmat(viI,[1,1,lphi]);
    J1=Jx1;
    J1I=interp2(xg2.x2,xg2.x1,J1,xg.x2(3:end-2),xg.x1(3:end-2));
    J1Ispread=repmat(J1I,[1,1,lphi]);

    figure;
    set(gcf,'PaperPosition',[0 0 8.5 4]);
end


hold on;
%h=plotslice3D_curv_corner(t/3600,xg,log10(neIspread));
%clim([9.75 12.5])
%h=plotslice3D_curv_corner(t/3600,xg,viIspread);
h=plotslice3D_curv_corner(t/3600,xg,J1Ispread);

% %ADD THE ELECTRON DENSITY INFORMATION (READ OUTPUT DATA, GRID, ETC.)
% direc='/Volumes/SDHCcard/simulations/curvtest_closed/'
% filename='10800.000000.dat'
% cd vis;
% loadframe3Dcurv;
% xg=gemini3d.read.grid([direc,'/']);
%
% figure;
% set(gcf,'PaperPosition',[0 0 8.5 4]);
%
% hold on;
% h=plotslice3D_curv_corner(t/3600,xg,log10(ns(:,:,:,7)));
% clim([8 12])
% cd ..;


Re=6370e3;


%PLOT THE OUTLINES OF THE DIPOLE GRID - THIS VERSION USES MLAT,MLON.,ALT. COORDS.
mlat=90-xg.theta*180/pi;
mlon=xg.phi*180/pi;
alt=xg.alt/1e3;
% figure;
hold on;

LW=2;
altlinestyle=':';

h=plot3(mlat(:,1,1),mlon(:,1,1),alt(:,1,1),'LineWidth',LW);
linecolor=h.Color;
plot3(mlat(:,1,end),mlon(:,1,end),alt(:,1,end),altlinestyle,'LineWidth',LW);
plot3(mlat(:,end,1),mlon(:,end,1),alt(:,end,1),'LineWidth',LW);
plot3(mlat(:,end,end),mlon(:,end,end),alt(:,end,end),altlinestyle,'LineWidth',LW);

x=squeeze(mlat(1,:,1));
y=squeeze(mlon(1,:,1));
z=squeeze(alt(1,:,1));
plot3(x,y,z,'LineWidth',LW);

x=squeeze(mlat(1,:,end));
y=squeeze(mlon(1,:,end));
z=squeeze(alt(1,:,end));
plot3(x,y,z,altlinestyle,'LineWidth',LW);

x=squeeze(mlat(end,:,1));
y=squeeze(mlon(end,:,1));
z=squeeze(alt(end,:,1));
plot3(x,y,z,'LineWidth',LW);

x=squeeze(mlat(end,:,end));
y=squeeze(mlon(end,:,end));
z=squeeze(alt(end,:,end));
plot3(x,y,z,altlinestyle,'LineWidth',LW);


x=squeeze(mlat(1,1,:));
y=squeeze(mlon(1,1,:));
z=squeeze(alt(1,1,:));
plot3(x,y,z,'LineWidth',LW);

x=squeeze(mlat(1,end,:));
y=squeeze(mlon(1,end,:));
z=squeeze(alt(1,end,:));
plot3(x,y,z,'LineWidth',LW);

x=squeeze(mlat(end,1,:));
y=squeeze(mlon(end,1,:));
z=squeeze(alt(end,1,:));
plot3(x,y,z,'LineWidth',LW);

x=squeeze(mlat(end,end,:));
y=squeeze(mlon(end,end,:));
z=squeeze(alt(end,end,:));
plot3(x,y,z,'LineWidth',LW);

%xlabel('magnetic latitude (deg.)');
%ylabel('magnetic longitude (deg.)');
%zlabel('altitidue (km)');

%GO BACK AND MAKE ALL LINES THE SAME COLOR
h=gca;
lline=numel(h.Children);
for iline=1:12    %the last three children are the surface and text label objects
%    h.Children(iline).Color=linecolor;
    h.Children(iline).Color=[0 0 0];
end


%NOW CREATE A NEUTRAL GRID AND OVERPLOT IT
%meanth=mean(xg.theta(xg.lx(1),:,floor(end/2)))+5.75*pi/180;   %N lowlat, TD model
meanth=mean(xg.theta(xg.lx(1),:,floor(end/2)))+4.25*pi/180;   %N lowlat, TD model
meanphi=mean(xg.phi(xg.lx(1),floor(end/2),:));
%%dcoord=74e3;    %resolution of the neutral dynamics model
%dcoord=60e3;    %resolution of the neutral dynamics model
dz=72e3;
drho=72e3;

lz=9;
lrho=6;

zn=linspace(0,lz*dz,lz)';
rhon=linspace(0,lrho*drho,lrho);
xn=[-1*fliplr(rhon),rhon(2:lrho)];
lx=numel(xn);
yn=xn;    %all based off of axisymmetric model
rn=zn+6370e3;   %convert altitude to geocentric distance

dtheta=(max(xn(:))-min(xn(:)))/rn(1);    %equivalent theta coordinates of the neutral mesh
dphi=(max(yn(:))-min(yn(:)))/rn(1);    %should be a sin(theta) there?
thetan=linspace(meanth-dtheta/2,meanth+dtheta/2,2*lx-1);    %fudge this to make it look good.
phin=linspace(meanphi-dphi/2,meanphi+dphi/2,2*lx-1);
[THETAn,PHIn,Rn]=meshgrid(thetan,phin,rn);

MLATn=90-THETAn*180/pi;
MLONn=PHIn*180/pi;
Zn=(Rn-6370e3)/1e3;

hold on;
plot3(MLATn(:,end,1),MLONn(:,end,1),Zn(:,end,1),'LineWidth',LW);
h=plot3(MLATn(:,end,end),MLONn(:,end,end),Zn(:,end,end),'LineWidth',LW);
linecolor=h.Color;    %grab the color of the second line
plot3(MLATn(:,1,1),MLONn(:,1,1),Zn(:,1,1),'LineWidth',LW);
plot3(MLATn(:,1,end),MLONn(:,1,end),Zn(:,1,end),'LineWidth',LW);
plot3(squeeze(MLATn(1,:,1)),squeeze(MLONn(1,:,1)),squeeze(Zn(1,:,1)),'LineWidth',LW);
plot3(squeeze(MLATn(1,:,end)),squeeze(MLONn(1,:,end)),squeeze(Zn(1,:,end)),'LineWidth',LW);
plot3(squeeze(MLATn(end,:,1)),squeeze(MLONn(end,:,1)),squeeze(Zn(end,:,1)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(end,:,end)),squeeze(MLONn(end,:,end)),squeeze(Zn(end,:,end)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(1,1,:)),squeeze(MLONn(1,1,:)),squeeze(Zn(1,1,:)),'LineWidth',LW);
plot3(squeeze(MLATn(1,end,:)),squeeze(MLONn(1,end,:)),squeeze(Zn(1,end,:)),'LineWidth',LW);
plot3(squeeze(MLATn(end,1,:)),squeeze(MLONn(end,1,:)),squeeze(Zn(end,1,:)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(end,end,:)),squeeze(MLONn(end,end,:)),squeeze(Zn(end,end,:)),altlinestyle,'LineWidth',LW);

%GO BACK AND MAKE ALL NEUTRAL GRID LINES THE SAME COLOR
h=gca;
lline=numel(h.Children);
for iline=1:12    %the line objects for each axis are added in a "stack" fashion (last in first out)
    h.Children(iline).Color=linecolor;
%    h.Children(iline).LineWidth=0.60;
end

FS=12;
set(gca,'FontSize',FS);
%grid on;
colorbar('off');
set(gca,'LineWidth',LW-0.5)
% view(-2,1);
view(2,1);

%print -dpng 3Datmosionos_grid.png;
%print -depsc2 -painters 3Datmosionos_grid.eps;
%print -dpdf -painters 3Datmosionos_grid.pdf;
