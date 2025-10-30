run ~/Projects/mat_gemini/setup

direc="/Volumes/uSDCard1TB/simulations/Laminar_run_test_2ndord_denspot/"
cfg=gemini3d.read.config(direc);
xg=gemini3d.read.grid(direc);
dat=gemini3d.read.frame(strcat(direc,"./20080326_12825.000000.h5"));

% remove ghost cells from coordinates
x=xg.x2(3:end-2);
y=xg.x3(3:end-2);
z=xg.x1(3:end-2);

[Y,Z]=meshgrid(y,z);
divJ=divergence(Y,Z,squeeze(dat.J3),squeeze(dat.J1));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure;
subplot(131);
pcolor(y,z,squeeze(dat.J3));
shading interp;
colorbar;
title("J3")

subplot(132);
pcolor(y,z,squeeze(dat.J1));
shading interp;
colorbar;
title("J1")

subplot(133);
pcolor(y,z,log10(abs(divJ)));
shading interp;
colorbar;
title("log10 |div(J)|")


figure;
subplot(131);
pcolor(y,z,squeeze(dat.v3));
shading interp;
colorbar;
title("v3")

subplot(132);
pcolor(y,z,squeeze(dat.v1));
shading interp;
colorbar;
title("v1")

subplot(133);
pcolor(y,z,squeeze(dat.v2));
shading interp;
colorbar;
title("v2")
