% This script shows an example of how to take curvilinear or nonuniformly
% gridded GEMINI output and reinterpolate these onto a uniform grid in
% mlon,mlat, and altitude.
%
% from mat_gemini-script directory run
%    buildtool setup

import gemini3d.grid.model2magcoords

% sim and time of interest
%direc='~/simulations/tohoku20113D_lowres/'
%time = datetime(2011,03,11) + seconds(20783 + 900);
direc="~/simulations/arcs_angle_wide_nonuniform/";
time = datetime([2017,03,02,0,0,27000 + 270]);% read in data


% load grid and frame data
xg= gemini3d.read.grid(direc);
dat= gemini3d.read.frame(direc, time=time);


% regrid as uniform in mlon,mlat, and alt
Tei = model2magcoords(xg,dat.Te);
J1i = model2magcoords(xg,dat.J1);
J3i = model2magcoords(xg,dat.J3);
J2i = model2magcoords(xg,dat.J2);
nei = model2magcoords(xg,dat.ne);
v3i = model2magcoords(xg,dat.v3);
v2i = model2magcoords(xg,dat.v2);
v1i = model2magcoords(xg,dat.v1);
[Tii, alti,mloni,mlati] = model2magcoords(xg,dat.Ti);


% plot
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
