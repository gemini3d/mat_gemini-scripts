% This script shows an example of how to take curvilinear or nonuniformly
% gridded GEMINI output and reinterpolate these onto a uniform grid in
% glon,glat, and altitude. 
%
% You'll need to run the setup.m script for the gemini-scripts repository
% prior to using this program

import gemscr.postprocess.model2geocoords


% simulation name, date and time of interest
% direc="~/simulations/gdi_lagrangian/"
% time = datetime([2013,2,20,0,0,18320]);
direc="~/simulations/arcs_angle_wide_nonuniform/";
time = datetime([2017,03,02,0,0,27000 + 270]);% read in data

% load grid and frame data
xg = gemini3d.read.grid(direc);
simdat = gemini3d.read.frame(direc, "time", time);


% interpolate onto a geographic grid
[alti,gloni,glati,nei]=model2geocoords(xg,simdat.ne);
[alti,gloni,glati,Tei]=model2geocoords(xg,simdat.Te);
[alti,gloni,glati,J1i]=model2geocoords(xg,simdat.J1);
[alti,gloni,glati,J2i]=model2geocoords(xg,simdat.J2);
[alti,gloni,glati,J3i]=model2geocoords(xg,simdat.J3);
[alti,gloni,glati,v3i]=model2geocoords(xg,simdat.v3);
[alti,gloni,glati,v2i]=model2geocoords(xg,simdat.v2);
[alti,gloni,glati,v1i]=model2geocoords(xg,simdat.v1);
[alti,gloni,glati,Tii]=model2geocoords(xg,simdat.Ti);


% plots
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


%% lat/lon slices
ialt=min(find(alti>300e3));

figure;
imagesc(gloni,glati,squeeze(nei(ialt,:,:))');
axis xy;
colorbar;

figure;
imagesc(gloni,glati,squeeze(Tei(ialt,:,:))');
axis xy;
colorbar;

figure;
imagesc(gloni,glati,squeeze(v1i(ialt,:,:))');
axis xy;
colorbar;

figure;
imagesc(gloni,glati,squeeze(v2i(ialt,:,:))');
axis xy;
colorbar;

figure;
imagesc(gloni,glati,squeeze(v3i(ialt,:,:))');
axis xy;
colorbar;

figure;
imagesc(gloni,glati,squeeze(Tii(ialt,:,:))');
axis xy;
colorbar;
