%direc='~/Projects/GEMINI/objects/test3d/';
%direc='~/simulations/zenodo3d/';
direc='~/simulations/junktest3d/';

ymd=[2013,02,20];
UTsec=18300;

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec);
[alti,mloni,mlati,Tei]=model2magcoords(xg,Te);
[alti,mloni,mlati,J1i]=model2magcoords(xg,J1);
[alti,mloni,mlati,J3i]=model2magcoords(xg,J3);
[alti,mloni,mlati,J2i]=model2magcoords(xg,J2);
[alti,mloni,mlati,nei]=model2magcoords(xg,ne);
[alti,mloni,mlati,v3i]=model2magcoords(xg,v3);
[alti,mloni,mlati,v2i]=model2magcoords(xg,v2);
[alti,mloni,mlati,v1i]=model2magcoords(xg,v1);
[alti,mloni,mlati,Tii]=model2magcoords(xg,Ti);

figure;
subplot(121)
imagesc(mloni,alti,nei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(nei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(Tei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,J1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(J1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,J3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(J3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,J2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(J2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,v3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(v3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,v2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(v2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,v1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(v1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(mloni,alti,Tii(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(mlati,alti,squeeze(Tii(:,end/2,:)));
axis xy;
colorbar;