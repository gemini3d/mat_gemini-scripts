% Load data to compare
direc="~/simulations/ssd/isinglass_22_fullres";
run ~/Projects/mat_gemini/setup;
cfg=gemini3d.read.config(direc);
dat=gemini3d.read.frame(direc,"time",cfg.times(2));
Phitop=dat.Phitop
filename=strcat(direc,"/inputs/fields/20170302_28365.000000.h5");
Vmaxx1it=h5read(filename,"/Vmaxx1it");

%plot stuff
figure;
subplot(321)
imagesc(Phitop)
subplot(322)
imagesc(Vmaxx1it)

subplot(323)
imagesc(diff(Phitop,1,2))
subplot(324)
imagesc(diff(Vmaxx1it,1,2))

subplot(325)
imagesc(diff(Phitop,2,2))
subplot(326)
imagesc(diff(Vmaxx1it,2,2))

figure;
imagesc(Phitop-Vmaxx1it);
colorbar

