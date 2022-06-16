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
%direc='~/simulations/tohoku20113D_lowres_3Dneu_CI/'
direc='~/simulations/tohoku20113D_lowres_MZ2017paper/'
%direc='~/simulations/tohoku20113D_lowres_2Daxisneu'
ymd=[2011,03,11];
%UTsec=35850;
%t0=35100;
t0=20783;
UTsec=21533;
time=datetime([ymd,0,0,UTsec]);


%% read in data
if (~exist('dat','var'))
  xg=gemini3d.read.grid(direc);
  dat=gemini3d.read.frame(direc, time=time);
  vr=dat.v1.*dot(xg.er,xg.e1,4)+dat.v2.*dot(xg.er,xg.e2,4)+dat.v3.*dot(xg.er,xg.e3,4);
  vtheta=dat.v1.*dot(xg.etheta,xg.e1,4)+dat.v2.*dot(xg.etheta,xg.e2,4)+dat.v3.*dot(xg.etheta,xg.e3,4);
  vphi=dat.v1.*dot(xg.ephi,xg.e1,4)+dat.v2.*dot(xg.ephi,xg.e2,4)+dat.v3.*dot(xg.ephi,xg.e3,4);
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
[alti,~,mlati,vrimer]=gemscr.postprocess.model2magcoords(xg,vr,lalt,1,llat,altlims,[210,210],mlatlims);
[alti,mloni,~,vrizon]=gemscr.postprocess.model2magcoords(xg,vr,lalt,llon,1,altlims,mlonlims,[29.1,29.1]);
[~,~,~,vrialt]=gemscr.postprocess.model2magcoords(xg,vr,1,llon,llat,[250e3,250e3],mlonlims,mlatlims);

[alti,~,mlati,vthetaimer]=gemscr.postprocess.model2magcoords(xg,vtheta,lalt,1,llat,altlims,[210,210],mlatlims);
[alti,mloni,~,vthetaizon]=gemscr.postprocess.model2magcoords(xg,vtheta,lalt,llon,1,altlims,mlonlims,[29.1,29.1]);
[~,~,~,vthetaialt]=gemscr.postprocess.model2magcoords(xg,vtheta,1,llon,llat,[250e3,250e3],mlonlims,mlatlims);

[alti,~,mlati,vphiimer]=gemscr.postprocess.model2magcoords(xg,vphi,lalt,1,llat,altlims,[210,210],mlatlims);
[alti,mloni,~,vphiizon]=gemscr.postprocess.model2magcoords(xg,vphi,lalt,llon,1,altlims,mlonlims,[29.1,29.1]);
[~,~,~,vphiialt]=gemscr.postprocess.model2magcoords(xg,vphi,1,llon,llat,[250e3,250e3],mlonlims,mlatlims);


figure;

subplot(337)
imagesc(mlati,alti,squeeze(vrimer));
axis xy;
title(num2str(UTsec-t0))
xlabel("mlat")
ylabel("alt")

subplot(338)
imagesc(mloni,alti,squeeze(vrizon));
axis xy;
xlabel("mlon")
ylabel("alt")

subplot(339)
imagesc(mloni,mlati,squeeze(vrialt)');
axis xy;
xlabel("mlon")
ylabel("mlat")

subplot(334)
imagesc(mlati,alti,-squeeze(vthetaimer));
axis xy;
title(num2str(UTsec-t0))
xlabel("mlat")
ylabel("alt")

subplot(335)
imagesc(mloni,alti,-squeeze(vthetaizon));
axis xy;
xlabel("mlon")
ylabel("alt")

subplot(336)
imagesc(mloni,mlati,-squeeze(vthetaialt)');
axis xy;
xlabel("mlon")
ylabel("mlat")

subplot(331)
imagesc(mlati,alti,squeeze(vphiimer));
axis xy;
title(num2str(UTsec-t0))
xlabel("mlat")
ylabel("alt")

subplot(332)
imagesc(mloni,alti,squeeze(vphiizon));
axis xy;
xlabel("mlon")
ylabel("alt")

subplot(333)
imagesc(mloni,mlati,squeeze(vphiialt)');
axis xy;
xlabel("mlon")
ylabel("mlat")

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
