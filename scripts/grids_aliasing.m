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
Rreg=1/50;

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
subplot(131);
imagesc(Rmin);
colorbar;
subplot(132);
imagesc(Rminreg);
colorbar;

% try to compute distances using average of corners???
% edge locations of source cells
xpi=zeros(1,lxp+1);
xpi(2:lxp)=1/2*(xp(1:lxp-1)+xp(2:lxp));
dxpi=xpi(3)-xpi(2);
xpi(1)=xpi(2)-dxpi;
xpi(lxp+1)=xpi(lxp)+dxpi;

ypi=zeros(1,lyp+1);
ypi(2:lyp)=1/2*(yp(1:lyp-1)+yp(2:lyp));
dypi=ypi(3)-ypi(2);
ypi(1)=ypi(2)-dypi;
ypi(lyp+1)=ypi(lyp)+dypi;

% use average x,y distances over a given cell for |r-r|'
[XPI,YPI]=ndgrid(xpi,ypi);
Rxi=zeros(lxp,lyp,lx,ly);
Ryi=zeros(lxp,lyp,lx,ly);
for ix=1:lx
    for iy=1:ly
        Rxi(:,:,ix,iy)=1/2*(abs(X(ix,iy)-XPI(1:end-1,2:end))+abs(X(ix,iy)-XPI(2:end,2:end)));
        Ryi(:,:,ix,iy)=1/2*(abs(Y(ix,iy)-YPI(2:end,1:end-1))+abs(Y(ix,iy)-YPI(2:end,2:end)));
    end %for
end %for

% add the last plot
Rmini=squeeze(min(sqrt(Rxi.^2+Ryi.^2),[],[1,2]));
subplot(133);
imagesc(Rmini);
colorbar;