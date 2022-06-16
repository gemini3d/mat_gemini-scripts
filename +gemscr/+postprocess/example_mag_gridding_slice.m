%% sim and time of interest
% Tohoku example
%direc='~/simulations/tohoku20113D_lowres/'
%ymd=[2011,03,11];
%UTsec=20783+900;

% % ESF example
% direc='~/simulations/ESF_noise_highres/'
% time = datetime(2016,03,03) + seconds(13500);

% CI example
%direc='~/simulations/tohoku20113D_lowres/'
direc='~/simulations/tohoku20113D_lowres_3Dneu_CI/'
%direc='~/simulations/tohoku20113D_lowres_olddata/'
ymd=[2011,03,11];
UTsec=35850;
%UTsec=22158;
time=datetime([ymd,0,0,UTsec]);


%% read in data
if (~exist('dat','var'))
  xg= gemini3d.read.grid(direc);
  dat= gemini3d.read.frame(direc, time=time);
end %if


%% dist loc.
lat0=44.8;
lon0=210;

% Works well for Tohoku example and CI example

%% slice to interp to (meridional)
lalt=512;
llon=512;
llat=512;
altlims=[0 500e3];
mlonlims=[205,215];
mlatlims=[26,32];


%% regrid
[alti,~,mlati,v1imer]=gemscr.postprocess.model2magcoords(xg,dat.v1,lalt,1,llat,altlims,[210,210],mlatlims);
[alti,mloni,~,v1izon]=gemscr.postprocess.model2magcoords(xg,dat.v1,lalt,llon,1,altlims,mlonlims,[29.1,29.1]);
[~,~,~,v1ialt]=gemscr.postprocess.model2magcoords(xg,dat.v1,1,llon,llat,[250e3,250e3],mlonlims,mlatlims);

figure;
subplot(131)
imagesc(mlati,alti,squeeze(v1imer));
axis xy;

subplot(132)
imagesc(mloni,alti,squeeze(v1izon));
axis xy;

subplot(133)
imagesc(mloni,mlati,squeeze(v1ialt)');
axis xy;


%{
%% ESF example
lalt=1024;
llon=1024;
llat=1024;
altlims=[200e3 600e3];
mlonlims=[352.564275,355.06425];
mlatlims=[-15,15];

[alti,mloni,mlati,neimer]=model2magcoords(xg,dat.ne,lalt,1,llat,altlims,[354,354],mlatlims);
[alti,mloni,mlati,neizon]=model2magcoords(xg,dat.ne,lalt,llon,1,altlims,mlonlims,[0,0]);


%% plot
figure;

subplot(121);
imagesc(mlati,alti,squeeze(neimer));
axis xy;
colorbar;

subplot(122);
imagesc(mloni,alti,squeeze(neizon));
axis xy;
colorbar;


%% plot with labels, etc.
neplot=squeeze(neizon);
neshift=circshift(neizon,512,2);    %shift to make a nicer plot

figure;
imagesc(mloni,alti/1e3,neshift);
axis xy;
%c=colorbar;
xlabel('mag. lon. (deg)');
ylabel('altitude (km)');
title('Noise-seeded EPBs:  n_e')
%}
