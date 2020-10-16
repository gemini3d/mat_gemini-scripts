import gemini3d.postprocess.model2magcoords

direc1 = '~/simulations/mooreOK3D_hemis_medres/';
direc2 = '~/simulations/mooreOK3D_hemis_medres_VEGA/';


time = datetime(2013,5,20) + seconds(71400);

% load the data
if (~exist('xg','var'))
  xg= gemini3d.readgrid(direc1);
end
if (~exist('dat1','var'))
  dat1 = gemini3d.loadframe(direc1, "time", time);
  dat2 = gemini3d.loadframe(direc2, "time", time);
end


% Grid to interp to
llat=512;
llon=25;
lalt=512;
altlims=[0,500e3];
lonlims=[min(xg.phi(:)*180/pi),max(xg.phi(:)*180/pi)];
latlims=[-60,-30];


[alti,mloni,mlati,Tei1]=model2magcoords(xg,dat1.Te,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J1i1]=model2magcoords(xg,dat1.J1,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J3i1]=model2magcoords(xg,dat1.J3,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J2i1]=model2magcoords(xg,dat1.J2,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,nei1]=model2magcoords(xg,dat1.ne,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v3i1]=model2magcoords(xg,dat1.v3,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v2i1]=model2magcoords(xg,dat1.v2,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v1i1]=model2magcoords(xg,dat1.v1,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,Tii1]=model2magcoords(xg,dat1.Ti,lalt,llon,llat,altlims,lonlims,latlims);

[alti,mloni,mlati,Tei2]=model2magcoords(xg,dat2.Te,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J1i2]=model2magcoords(xg,dat2.J1,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J3i2]=model2magcoords(xg,dat2.J3,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,J2i2]=model2magcoords(xg,dat2.J2,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,nei2]=model2magcoords(xg,dat2.ne,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v3i2]=model2magcoords(xg,dat2.v3,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v2i2]=model2magcoords(xg,dat2.v2,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,v1i2]=model2magcoords(xg,dat2.v1,lalt,llon,llat,altlims,lonlims,latlims);
[alti,mloni,mlati,Tii2]=model2magcoords(xg,dat2.Ti,lalt,llon,llat,altlims,lonlims,latlims);

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
