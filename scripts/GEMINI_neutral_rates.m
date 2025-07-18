direc='~/simulations/sdcard/isinglass_timedep/'
filename='20170302_27300.000000.h5'

% import
run ~/Projects/mat_gemini/setup.m
setenv('GEMINI_ROOT','~/Projects/gemini3d/build/msis/')

% Sim info
cfg=gemini3d.read.config(direc);
xg=gemini3d.read.grid(direc);
z=xg.x1(3:end-2);
x=xg.x2(3:end-2);
y=xg.x3(3:end-2);

% Plasma density
nsall=h5read([direc,filename],'/nsall');
ne=nsall(:,:,:,end);

% Read in energy and momentum input rates for neutral atmosphere
user_outputall=h5read([direc,filename],'/user_outputall');
energy_neut=user_outputall(:,:,:,1);     % W/m**3
moment_neut1=user_outputall(:,:,:,2);     % N/m**3
moment_neut2=user_outputall(:,:,:,3);
moment_neut3=user_outputall(:,:,:,4);

% Get background neutral info
params=cfg;
params.msis_infile="/tmp/msis_input.h5";
params.msis_outfile="/tmp/msis_output.h5";
natm=gemini3d.model.msis(params,xg,cfg.times(1));
nO=natm.nO;
nN2=natm.nN2;
nO2=natm.nO2;
Tn=natm.Tn;

% Try to convert rates into easily understood units
kB=1.38e-23;
amu=1.67e-27;
neutral_kelvinspersec=energy_neut./(nO+nN2+nO2)/kB;
neutral_accel=moment_neut2./(16*amu*nO+28*amu*nN2+32*amu*nO2);

% plot
izmin=1;
[minval,izmax]=min(abs(z-400e3));
figure;
subplot(1,2,1);
pcolor(x,z(izmin:izmax),neutral_kelvinspersec(izmin:izmax,:,end/2))
axis xy;
shading flat;
%ax=axis;
%axis([ax(1:2),80e3,400e3]);
colorbar;
xlabel('east dist. (m)')
ylabel('altitude (m)')
title('neutral gas temperature increase rate (K/s)')
subplot(1,2,2)
pcolor(x,z(izmin:izmax),neutral_accel(izmin:izmax,:,end/2))
axis xy;
shading flat;
%ax=axis;
%axis([ax(1:2),80e3,400e3]);
colorbar;
xlabel('east dist. (m)')
ylabel('altitude (m)')
title('neutral gas acceleration (m/s**2)')
