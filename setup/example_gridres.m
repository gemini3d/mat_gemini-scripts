%% SET PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd, filesep, '../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'setup/gridgen'])
addpath([gemini_root, filesep, '../../GEMINI-scripts/setup/gridgen'])
addpath([gemini_root, filesep, 'setup/'])
addpath([gemini_root, filesep, 'vis'])
addpath(['../../setup/gridgen'])


%% MOORE, OK GRID (FULL)
dtheta=20;
dphi=27.5;
lp=128;
lq=96;
lphi=16;
altmin=80e3;
glat=39;
glon=262.51;
gridflag=1;
xg=makegrid_tilteddipole_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);


%% DETERMINE GRID RESOLUTION
[dl1,dl2,dl3]=gridres(xg);


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
dl2trial=squeeze(dl2(ix1,:,ix3));
dl2target=20e3;                                %define a desired grid step size in x2
dx2target=squeeze(dl2target./h2(ix1,:,ix3));   %what dx2 needs to be to hit target grid size
coeffs=polyfit(x2(:),dx2target(:),2);
dx2new=polyval(coeffs,x2);

figure;
plot(x2,dx2new,x2,dx2target);

dl2new=dx2new(:).*squeeze(h2(ix1,:,ix3))';

figure;
plot(x2,dl2new,x2,dl2trial);