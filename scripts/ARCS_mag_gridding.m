%REQUIRES:  https://github.com/joe-of-all-trades/vtkwrite

import gemini3d.grid.model2magUENcoords

cwd = fileparts(mfilename('fullpath'));

addpath('~/Dropbox/common/proposals/ARCS/paraview_plots/vtkwrite-master/');

direc='~/SDHCCard/ARCS_angle_decimate/';

ymd=[2017,03,02];
UTsec=27300;

dat = gemini3d.read.frame(gemini3d.find.frame(direc,ymd,UTsec));
Tei = model2magUENcoords(xg, dat.Te);
J1i = model2magUENcoords(xg, dat.J1);
J3i = model2magUENcoords(xg, dat.J3);
J2i = model2magUENcoords(xg, dat.J2);
nei = model2magUENcoords(xg, dat.ne);
v3i = model2magUENcoords(xg, dat.v3);
v2i = model2magUENcoords(xg, dat.v2);
v1i = model2magUENcoords(xg, dat.v1);
[Tii, zUENi,xUENi,yUENi] = model2magUENcoords(xg, dat.Ti);

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

[ZUENi,XUENi,YUENi]=meshgrid(zUENi,xUENi,yUENi);

vtkwrite('~/Dropbox/common/proposals/ARCS/paraview_plots/test_ARCS_angle.vtk', ...
    'structured_grid',ZUENi,XUENi,YUENi,'scalars','Ti',Tii,'scalars','Te',Tei);
