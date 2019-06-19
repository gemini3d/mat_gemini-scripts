cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis'])


direc='~/Projects/GEMINI/objects/test3d_glow/';
%direc='~/simulations/zenodo3d/';
%direc='~/simulations/junktest3d/';

ymd=[2013,02,20];
UTsec=18060;

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec);
[alti,gloni,glati,nei]=model2geocoords(xg,ne);
[alti,gloni,glati,Tei]=model2geocoords(xg,Te);
[alti,gloni,glati,J1i]=model2geocoords(xg,J1);
[alti,gloni,glati,J2i]=model2geocoords(xg,J2);
[alti,gloni,glati,J3i]=model2geocoords(xg,J3);
[alti,gloni,glati,v3i]=model2geocoords(xg,v3);
[alti,gloni,glati,v2i]=model2geocoords(xg,v2);
[alti,gloni,glati,v1i]=model2geocoords(xg,v1);
[alti,gloni,glati,Tii]=model2geocoords(xg,Ti);


figure;
subplot(121)
imagesc(gloni,alti,nei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(glati,alti,squeeze(nei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,Tei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(glati,alti,squeeze(Tei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,J1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(J1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,J3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(J3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,J2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(J2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,v3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(v3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,v2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(v2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,v1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(v1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(gloni,alti,Tii(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(glati,alti,squeeze(Tii(:,end/2,:)));
axis xy;
colorbar;