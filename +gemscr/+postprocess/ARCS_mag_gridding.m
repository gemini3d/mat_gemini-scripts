%REQUIRES:  https://github.com/joe-of-all-trades/vtkwrite

import gemscr.postprocess.model2magUENcoords

cwd = fileparts(mfilename('fullpath'));

addpath('~/Dropbox/common/proposals/ARCS/paraview_plots/vtkwrite-master/');

direc='~/SDHCCard/ARCS_angle_decimate/';

ymd=[2017,03,02];
UTsec=27300;

[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = gemini3d.read.frame(gemini3d.find.frame(direc,ymd,UTsec));
[zUENi,xUENi,yUENi,Tei]=model2magUENcoords(xg,Te);
[zUENi,xUENi,yUENi,J1i]=model2magUENcoords(xg,J1);
[zUENi,xUENi,yUENi,J3i]=model2magUENcoords(xg,J3);
[zUENi,xUENi,yUENi,J2i]=model2magUENcoords(xg,J2);
[zUENi,xUENi,yUENi,nei]=model2magUENcoords(xg,ne);
[zUENi,xUENi,yUENi,v3i]=model2magUENcoords(xg,v3);
[zUENi,xUENi,yUENi,v2i]=model2magUENcoords(xg,v2);
[zUENi,xUENi,yUENi,v1i]=model2magUENcoords(xg,v1);
[zUENi,xUENi,yUENi,Tii]=model2magUENcoords(xg,Ti);

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
