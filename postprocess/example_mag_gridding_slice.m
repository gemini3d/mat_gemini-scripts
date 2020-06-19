%% sim and time of interest
direc='~/simulations/tohoku20113D_lowres/'
ymd=[2011,03,11];
UTsec=20783+900;


%% read in data
xg=readgrid(direc);
dat=loadframe(direc,ymd,UTsec);


%% dist loc.
lat0=44.8;
lon0=210;


%% slice to interp to (meridional)
lalt=512;
llon=512;
llat=512;
altlims=[0 500e3];
mlonlimsslice=[210,210];
mlonlims=[205,215];
mlatlims=[26,32];
mlatlimsslice=[29.1,29.1];


%% regrid
[alti,mloni,mlati,v1imer]=model2magcoords(xg,dat.v1,lalt,1,llat,altlims,mlonlimsslice,mlatlims);
[alti,mloni,mlati,v1izon]=model2magcoords(xg,dat.v1,lalt,llon,1,altlims,mlonlims,mlatlimsslice);


%% plot
figure;

subplot(121);
imagesc(mlati,alti,squeeze(v1imer));
axis xy;
colorbar;

subplot(122);
imagesc(mloni,alti,squeeze(v1izon));
axis xy;
colorbar;
