import gemini3d.grid.model2magcoords

direc1 = '~/simulations/mooreOK3D_hemis_medres/';
direc2 = '~/simulations/mooreOK3D_hemis_medres_VEGA/';


time = datetime(2013,5,20) + seconds(71400);

% load the data
if (~exist('xg','var'))
  xg= gemini3d.read.grid(direc1);
end
if (~exist('dat1','var'))
  dat1 = gemini3d.read.frame(direc1, time=time);
  dat2 = gemini3d.read.frame(direc2, time=time);
end


% Grid to interp to
llat=512;
llon=25;
lalt=512;
altlims=[0,500e3];
lonlims=[min(xg.phi(:)*180/pi),max(xg.phi(:)*180/pi)];
latlims=[-60,-30];


Tei1 = model2magcoords(xg,dat1.Te,lalt,llon,llat,altlims,lonlims,latlims);
J1i1 = model2magcoords(xg,dat1.J1,lalt,llon,llat,altlims,lonlims,latlims);
J3i1 = model2magcoords(xg,dat1.J3,lalt,llon,llat,altlims,lonlims,latlims);
J2i1 = model2magcoords(xg,dat1.J2,lalt,llon,llat,altlims,lonlims,latlims);
nei1 = model2magcoords(xg,dat1.ne,lalt,llon,llat,altlims,lonlims,latlims);
v3i1 = model2magcoords(xg,dat1.v3,lalt,llon,llat,altlims,lonlims,latlims);
v2i1 = model2magcoords(xg,dat1.v2,lalt,llon,llat,altlims,lonlims,latlims);
v1i1 = model2magcoords(xg,dat1.v1,lalt,llon,llat,altlims,lonlims,latlims);
Tii1 = model2magcoords(xg,dat1.Ti,lalt,llon,llat,altlims,lonlims,latlims);

Tei2 = model2magcoords(xg,dat2.Te,lalt,llon,llat,altlims,lonlims,latlims);
J1i2 = model2magcoords(xg,dat2.J1,lalt,llon,llat,altlims,lonlims,latlims);
J3i2 = model2magcoords(xg,dat2.J3,lalt,llon,llat,altlims,lonlims,latlims);
J2i2 = model2magcoords(xg,dat2.J2,lalt,llon,llat,altlims,lonlims,latlims);
nei2 = model2magcoords(xg,dat2.ne,lalt,llon,llat,altlims,lonlims,latlims);
v3i2 = model2magcoords(xg,dat2.v3,lalt,llon,llat,altlims,lonlims,latlims);
v2i2 = model2magcoords(xg,dat2.v2,lalt,llon,llat,altlims,lonlims,latlims);
v1i2 = model2magcoords(xg,dat2.v1,lalt,llon,llat,altlims,lonlims,latlims);
[Tii2, alti,mloni,mlati] = model2magcoords(xg,dat2.Ti,lalt,llon,llat,altlims,lonlims,latlims);

ix3=floor(llon/2);

figure;
subplot(121)
imagesc(mloni,alti,nei1(:,:,ix3)-nei2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(nei1(:,ix3,:)-nei2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tei1(:,:,ix3)-Tei2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(Tei1(:,ix3,:)-Tei2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tii1(:,:,ix3)-Tii2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(Tii1(:,ix3,:)-Tii2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,v1i1(:,:,ix3)-v1i2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(v1i1(:,ix3,:)-v1i2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,v3i1(:,:,ix3)-v3i2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(v3i1(:,ix3,:)-v3i2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,J2i1(:,:,ix3)-J2i2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(J2i1(:,ix3,:)-J2i2(:,ix3,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,J3i1(:,:,ix3)-J3i2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(J3i1(:,ix3,:)-J3i2(:,ix3,:)));
axis xy;
colorbar;

figure;
imagesc(Phitop1-Phitop2)
colorbar;
