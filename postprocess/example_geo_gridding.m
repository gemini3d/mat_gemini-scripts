direc='~/Projects/GEMINI/objects/test3d/';
%direc='~/simulations/zenodo3d/';
%direc='~/simulations/junktest3d/';

ymd=[2013,02,20];
UTsec=18060;

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec);
[alti,gloni,glati,Tei]=model2geocoords(xg,Te);
% [alti,mloni,mlati,J1i]=model2geocoords(xg,J1);
% [alti,mloni,mlati,J3i]=model2geocoords(xg,J3);
% [alti,mloni,mlati,J2i]=model2geocoords(xg,J2);
% [alti,mloni,mlati,nei]=model2geocoords(xg,ne);
% [alti,mloni,mlati,v3i]=model2geocoords(xg,v3);
% [alti,mloni,mlati,v2i]=model2geocoords(xg,v2);
% [alti,mloni,mlati,v1i]=model2geocoords(xg,v1);
% [alti,mloni,mlati,Tii]=model2geocoords(xg,Ti);

%{
figure;
subplot(121)
imagesc(mloni,alti,nei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(mlati,alti,squeeze(nei(:,end/2,:)));
axis xy;
colorbar;
%}

figure;
subplot(121)
imagesc(gloni,alti,Tei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(glati,alti,squeeze(Tei(:,end/2,:)));
axis xy;
colorbar;

%{
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
%}