% disparate grids
lx=100; ly=128;
lxp=55; lyp=55;
x=linspace(0,1,lx);
xp=linspace(0,1,lxp);
y=linspace(0,1,ly);
yp=linspace(0,1,lyp);
[X,Y]=ndgrid(x,y);
[XP,YP]=ndgrid(xp,yp);

% pick a regulator to see how it affects point with largest weight
Rreg=1/100;

% compute distances
Rx=zeros(lxp,lyp,lx,ly);
Ry=zeros(lxp,lyp,lx,ly);
for ix=1:lx
    for iy=1:ly
        Rx(:,:,ix,iy)=X(ix,iy)-XP;
        Ry(:,:,ix,iy)=Y(ix,iy)-YP;
    end %for
end %for

% find the point that will contribute most of denominator of r-r'
Rmin=squeeze(min(sqrt(Rx.^2+Ry.^2),[],[1,2]));
Rminreg=squeeze(min(sqrt(Rx.^2+Ry.^2+Rreg^2),[],[1,2]));

% plots to show minimum distance r-r'
figure, 
subplot(121);
imagesc(Rmin);
colorbar;
subplot(122);
imagesc(Rminreg);
colorbar;

% 