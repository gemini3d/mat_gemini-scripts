% This script shows an example of how to take curvilinear or nonuniformly
% gridded GEMINI output and reinterpolate these onto a uniform grid in
% up, east, and north coordinates. 
%
% You'll need to run the setup.m script for the gemini-scripts repository
% prior to using this program


import gemscr.postprocess.model2magUENcoords


% simulation and date/time of interest
% direc='~/Downloads/ESF_medres/';
% time = datetime(2016,03,03) + second(14400);
direc="~/simulations/arcs_angle_wide_nonuniform/";
time = datetime([2017,03,02,0,0,27000 + 270]);% read in data


% read grid and frame data
xg=gemini3d.readgrid(direc);
dat=gemini3d.loadframe(direc,"time",time);


% interpolations
[zUENi,xUENi,yUENi,Tei]=model2magUENcoords(xg, dat.Te);
[zUENi,xUENi,yUENi,J1i]=model2magUENcoords(xg, dat.J1);
[zUENi,xUENi,yUENi,J3i]=model2magUENcoords(xg, dat.J3);
[zUENi,xUENi,yUENi,J2i]=model2magUENcoords(xg, dat.J2);
[zUENi,xUENi,yUENi,nei]=model2magUENcoords(xg, dat.ne);
[zUENi,xUENi,yUENi,v3i]=model2magUENcoords(xg, dat.v3);
[zUENi,xUENi,yUENi,v2i]=model2magUENcoords(xg, dat.v2);
[zUENi,xUENi,yUENi,v1i]=model2magUENcoords(xg, dat.v1);
[zUENi,xUENi,yUENi,Tii]=model2magUENcoords(xg, dat.Ti);
[zUENi,xUENi,yUENi,nei2]=model2magUENcoords(xg, dat.ne,150,150,150,[100e3, 750e3],[-300e3, 300e3],[-300e3, 300e3]);


% plots
figure;
subplot(121)
imagesc(xUENi,zUENi,nei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(yUENi,zUENi,squeeze(nei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,nei2(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(yUENi,zUENi,squeeze(nei2(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,Tei(:,:,end/2));
axis xy;
colorbar;
subplot(122)
imagesc(yUENi,zUENi,squeeze(Tei(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,J1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(J1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,J3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(J3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,J2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(J2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,v3i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(v3i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,v2i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(v2i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,v1i(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(v1i(:,end/2,:)));
axis xy;
colorbar;

figure;
subplot(121)
imagesc(xUENi,zUENi,Tii(:,:,end/2));
axis xy;
colorbar;
subplot(122);
imagesc(yUENi,zUENi,squeeze(Tii(:,end/2,:)));
axis xy;
colorbar;
