% create some 2D data with variability in it
x=linspace(-10,10,96);
y=linspace(-10,10,96);
[X,Y]=meshgrid(x,y);
F=sin(X).*sin(Y);

% linear interpolation
xi=linspace(min(x)-0.1,max(x)+0.1,256);
yi=linspace(min(x)-0.1,max(x)+0.1,192);
[Xi,Yi]=meshgrid(xi,yi);
Fi=interp2(x,y,F,Xi(:),Yi(:),'linear');
Fi=reshape(Fi,size(Xi));

% plot some diffs
figure;
subplot(321)
imagesc(F)
subplot(322)
imagesc(Fi)

subplot(323)
imagesc(diff(F,1,2));
subplot(324)
imagesc(diff(Fi,1,2));

subplot(325)
imagesc(diff(F,2,2))
subplot(326)
imagesc(diff(Fi,2,2))

% plot a line
figure;
subplot(121)
data=diff(F,2,2);
plot(data(end/2,:))
subplot(122);
datai=diff(Fi,2,2);
plot(datai(end/2,:))