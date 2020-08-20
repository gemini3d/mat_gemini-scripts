import gemini3d.postprocess.model2magUENcoords

direc='~/Downloads/ESF_medres/';

time = datetime(2016,03,03) + second(14400);

dat = loadframe(direc, time);
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
