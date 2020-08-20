import gemini3d.postprocess.model2magcoords
%% sim and time of interest
% Tohoku example
%direc='~/simulations/tohoku20113D_lowres/'
%ymd=[2011,03,11];
%UTsec=20783+900;
% ESF example
direc='~/simulations/ESF_noise_highres/'
time = datetime(2016,03,03) + seconds(13500);


%% read in data
if (~exist('dat','var'))
  xg= gemini3d.readgrid(direc);
  dat= gemini3d.vis.loadframe(direc, time);
end %if

%% dist loc.
lat0=44.8;
lon0=210;

% Works well for Tohokue example
%{
%% slice to interp to (meridional)
lalt=512;
llon=512;
llat=512;
altlims=[0 500e3];
mlonlims=[205,215];
mlatlims=[26,32];


%% regrid
[alti,mloni,mlati,v1imer]=model2magcoords(xg,dat.v1,lalt,1,llat,altlims,[210,210],mlatlims);
[alti,mloni,mlati,v1izon]=model2magcoords(xg,dat.v1,lalt,llon,1,altlims,mlonlims,[29.1,29.1]);
%}

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
