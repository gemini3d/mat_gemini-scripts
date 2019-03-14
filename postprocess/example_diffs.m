addpath ~/Projects/GEMINI/vis;

direc1='~/Projects/GEMINI/objects/test3d';
direc2='~/simulations/zenodo3d/';



ymd=[2013,02,20];
UTsec=18300;
llat=200;
llon=100;
lalt=200;

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop1,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec);
[alti,mloni,mlati,Tei1]=model2magcoords(xg,Te,lalt,llon,llat);
[alti,mloni,mlati,J1i1]=model2magcoords(xg,J1,lalt,llon,llat);
[alti,mloni,mlati,J3i1]=model2magcoords(xg,J3,lalt,llon,llat);
[alti,mloni,mlati,J2i1]=model2magcoords(xg,J2,lalt,llon,llat);
[alti,mloni,mlati,nei1]=model2magcoords(xg,ne,lalt,llon,llat);
[alti,mloni,mlati,v3i1]=model2magcoords(xg,v3,lalt,llon,llat);
[alti,mloni,mlati,v2i1]=model2magcoords(xg,v2,lalt,llon,llat);
[alti,mloni,mlati,v1i1]=model2magcoords(xg,v1,lalt,llon,llat);
[alti,mloni,mlati,Tii1]=model2magcoords(xg,Ti,lalt,llon,llat);

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop2,ns,vs1,Ts] = loadframe(direc2,ymd,UTsec);
[alti,mloni,mlati,Tei2]=model2magcoords(xg,Te,lalt,llon,llat);
[alti,mloni,mlati,J1i2]=model2magcoords(xg,J1,lalt,llon,llat);
[alti,mloni,mlati,J3i2]=model2magcoords(xg,J3,lalt,llon,llat);
[alti,mloni,mlati,J2i2]=model2magcoords(xg,J2,lalt,llon,llat);
[alti,mloni,mlati,nei2]=model2magcoords(xg,ne,lalt,llon,llat);
[alti,mloni,mlati,v3i2]=model2magcoords(xg,v3,lalt,llon,llat);
[alti,mloni,mlati,v2i2]=model2magcoords(xg,v2,lalt,llon,llat);
[alti,mloni,mlati,v1i2]=model2magcoords(xg,v1,lalt,llon,llat);
[alti,mloni,mlati,Tii2]=model2magcoords(xg,Ti,lalt,llon,llat);

ix3=30

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
imagesc(mloni,alti,v2i1(:,:,ix3)-v2i2(:,:,ix3));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(v2i1(:,ix3,:)-v2i2(:,ix3,:)));
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
