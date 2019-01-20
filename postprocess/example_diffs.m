addpath ~/Projects/GEMINI/vis;

%direc1='~/Projects/GEMINI/objects/test3d/';
%direc1='~/simulations/junktest3d/';
%direc1='~/Downloads/test3d/';
direc1='~/Downloads/junktest3d/';
direc2='~/simulations/zenodo3d/';
%direc2='~/simulations/junktest3d/';

ymd=[2013,02,20];
UTsec=18300;
[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec);
[alti,mloni,mlati,Tei1]=model2magcoords(xg,Te);
[alti,mloni,mlati,J1i1]=model2magcoords(xg,J1);
[alti,mloni,mlati,J3i1]=model2magcoords(xg,J3);
[alti,mloni,mlati,J2i1]=model2magcoords(xg,J2);
[alti,mloni,mlati,nei1]=model2magcoords(xg,ne);
[alti,mloni,mlati,v3i1]=model2magcoords(xg,v3);
[alti,mloni,mlati,v2i1]=model2magcoords(xg,v2);
[alti,mloni,mlati,v1i1]=model2magcoords(xg,v1);
[alti,mloni,mlati,Tii1]=model2magcoords(xg,Ti);

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc2,ymd,UTsec);
[alti,mloni,mlati,Tei2]=model2magcoords(xg,Te);
[alti,mloni,mlati,J1i2]=model2magcoords(xg,J1);
[alti,mloni,mlati,J3i2]=model2magcoords(xg,J3);
[alti,mloni,mlati,J2i2]=model2magcoords(xg,J2);
[alti,mloni,mlati,nei2]=model2magcoords(xg,ne);
[alti,mloni,mlati,v3i2]=model2magcoords(xg,v3);
[alti,mloni,mlati,v2i2]=model2magcoords(xg,v2);
[alti,mloni,mlati,v1i2]=model2magcoords(xg,v1);
[alti,mloni,mlati,Tii2]=model2magcoords(xg,Ti);

figure;
subplot(121)
imagesc(mloni,alti,nei1(:,:,end/2)-nei2(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(nei1(:,end/2,:)-nei2(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tei1(:,:,end/2)-Tei1(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(Tei1(:,end/2,:)-Tei2(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tii1(:,:,end/2)-Tii1(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(Tii1(:,end/2,:)-Tii2(:,end/2,:)));
axis xy;
colorbar;