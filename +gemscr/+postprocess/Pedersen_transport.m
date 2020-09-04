% Compute Pedersen transport rates from simulation output


% Load and prep. data
%direc='~/simulations/isinglass_clayton6_MB'
direc='~/simulations/isinglass_clayton5_decurl'

dat=gemini3d.vis.loadframe(direc,datetime([2017,3,2,0,0,28400]));

xg=gemini3d.readgrid(direc);
alt=xg.alt;
[~,ix1]=min(abs(alt(:,1,1)-120e3));    %index closest to 120 km

v1=squeeze(dat.v1(ix1,:,:));
v2=squeeze(dat.v2(ix1,:,:));
v3=squeeze(dat.v3(ix1,:,:));
ne=squeeze(dat.ne(ix1,:,:));
flux2=ne.*v2;
flux3=ne.*v3;
x2=xg.x2(3:end-2);             %strip off ghost cells
x3=xg.x3(3:end-2);
[X2,X3]=meshgrid(x2,x3);


% transport rates
divflux=divergence(X2,X3,ne'.*v2',ne'.*v3');


% plots
figure(1)
subplot(131)
imagesc(x2,x3,ne');
axis xy;

subplot(132)
imagesc(x2,x3,v2');
axis xy;

subplot(133);
imagesc(x2,x3,v3');
axis xy;

figure(2);
imagesc(x2,x3,-1*divflux);
axis xy;

figure(3);
imagesc(x2,x3,-1*divflux*60)
axis xy;

