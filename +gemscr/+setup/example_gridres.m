%% Iowa grid for AGU 2019
%{
dtheta=16;
dphi=29;
lp=100;
lq=200;
lphi=100;
altmin=80e3;
glat=41.5;   %38.9609;
glon=360-94.088;
gridflag=1;
flagsource=1;
iscurv=true;
%}

%% Moore OK
dtheta=20;
dphi=27.5;
lp=256;
lq=256;
lphi=210;
altmin=80e3;
glat=39;
glon=262.51;
gridflag=1;
flagsource=1;
iscurv=true;

%% Compute the grid
xg= gemini3d.grid.tilted_dipole3d(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);


%% DETERMINE GRID RESOLUTION
[dl1,dl2,dl3]= gemscr.setup.gridres(xg);


%% Plot the grid resolution on an appropriate set of physical axes (lat/lon)
ymd=[1981,05,22];
UTsec=4*3600+21*60;
saveplot_fmt={};
[theta,phi]= gemini3d.geog2geomag(38.96,360-94.088);
mlatsrc=90-theta*180/pi;
mlonsrc=phi*180/pi;
sourceloc=[mlatsrc,mlonsrc];

parm=log10(dl1/1e3);
parmlbl='log_{10} x_1 grid spacing (km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.plot.curv3d_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);

parm=log10(dl2/1e3);
parmlbl='log_{10} x_2 grid spacing (km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.plot.curv3d_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);



%% PLOTS
figure;
imagesc(log10(dl1(:,:,1)/1e3));
colorbar;
title('log_{10} Resolution along field line (min x3)')
datacursormode;

figure;
imagesc(xg.alt(:,:,1)/1e3);
colorbar;
title('altitude (min x3)')
datacursormode;

figure;
imagesc(dl2(:,:,1)/1e3);
colorbar;
title('Resolution perp. to field line (min x3)')
datacursormode;

figure;
imagesc(squeeze(dl3(1,:,:))/1e3);
colorbar;
title('ZONAL Resolution perp. to field line (min x1)')
datacursormode;

figure;
imagesc(squeeze(dl3(floor(end/2),:,:))/1e3);
colorbar;
title('ZONAL Resolution perp. to field line (mid x1)')
datacursormode;


%% FOR A GIVEN GRID ATTEMPT TO DEFINE A CONSTANT STRIDE IN THE X2 DIRECTION (VERY OFTEN DESIRABLE)
lx1=xg.lx(1);
lx2=xg.lx(2);
lx3=xg.lx(3);
h2=xg.h2(3:end-2,3:end-2,3:end-2);
x2=xg.x2(3:end-2);

ix1=floor(lx1/2);
ix3=floor(lx3/2);
dl2trial=squeeze(dl2(ix1,:,ix3));                % step size for the original grid
%dl2target=6.75e3;                                % define a desired grid step size in x2
dl2target=50e3;
dx2target=squeeze(dl2target./h2(ix1,:,ix3));     % what dx2 needs to be to hit target grid size

%A polynomial is being fitted to the target dL as a function of L, this
%can, in turn be used in the grid generation scripts which can handle
%nonuniform stepping.
coeffs=polyfit(x2(:),dx2target(:),2);          % most of the time a quadratic fit gets pretty close
dx2new=polyval(coeffs,x2);
dl2new=dx2new(:).*squeeze(h2(ix1,:,ix3))';

figure;
subplot(121);
plot(x2,dx2new,x2,dx2target);
xlabel('L shell');
ylabel('\Delta L');
legend('dL of nonuniform grid','target dL');
title(sprintf('poly coeffs:  %f %f %f',coeffs))

subplot(122);
plot(x2,dl2new,x2,dl2trial);
xlabel('L shell');
ylabel('grid step size (m)');
legend('dL of nonuniform grid','dL of source (original) grid');
