% Import needed slice or make a slice from imported data

Frame = 0;

for i=1:1:361

nameCur = strcat('fort.qq',num2str(Frame,'%04i'),'id0000','.h5');

% Read MAGIC grid structure and simulation configuration
attr = h5readatt(nameCur,'/Pid','Parameters'); % Thread MASTER (0) always outputs its data

lx = attr(22);
ly = attr(23);
lz = attr(24);


fprintf('Working on data from file: %s\n',nameCur);

%-------------- Input full 3D domain  --------------%

id = 1;
dataset=[];
datafullset=[];
for ii=1:1:lx
for jj=1:1:ly
nameCur = strcat('fort.qq',num2str(Frame,'%04i'),'id',num2str(id-1,'%04i'),'.h5');
namedataset = strcat('/Pid',num2str(id));
tempp = hdf5read(nameCur,'Pid');
dataset = cat(3,dataset,tempp);
id = id+1;
end
datafullset = cat(2,datafullset,dataset);
dataset=[];
end

fprintf('Full 3D domain is loaded\n');

% Store Frame=0 data 
if (Frame==0)
dox0=squeeze(6.022d23.*datafullset(6,:,:,:).*datafullset(1,:,:,:).*1e-3.*(1/16));
dnit20=squeeze(6.022d23.*(1-datafullset(6,:,:,:)-datafullset(7,:,:,:)).*datafullset(1,:,:,:).*1e-3.*(1/28));
dox20=squeeze(6.022d23.*datafullset(7,:,:,:).*datafullset(1,:,:,:).*1e-3.*(1/32));
gammam=(7.*(dox20+dnit20)+5.*(dox0))./(5.*(dox20+dnit20)+3.*(dox0));
Rm=8.31d3./((1d-6).*((dox0.*16+dnit20.*28+dox20.*32)./(1d-6.*(dox0+dnit20+dox20))));
momnt=datafullset(2:4,:,:,:);
momnt=momnt.*momnt;
kinetic=squeeze(0.5*squeeze(sum(momnt,1))./squeeze(datafullset(1,:,:,:)));
T0=(gammam-1).*((squeeze(datafullset(5,:,:,:))-kinetic)./(squeeze(datafullset(1,:,:,:)).*Rm));
end

% Prepare variables to write
rho2=datafullset(1,:,:,:);
momnt=datafullset(2:4,:,:,:);
momnt=momnt.*momnt;
kinetic=squeeze(0.5*squeeze(sum(momnt,1))./squeeze(datafullset(1,:,:,:)));
T=(gammam-1).*((squeeze(datafullset(5,:,:,:))-kinetic)./(squeeze(datafullset(1,:,:,:)).*Rm));
velxfull=squeeze(datafullset(2,:,:,:)./datafullset(1,:,:,:)); % Meridional wind (positive north)
velyfull=squeeze(datafullset(3,:,:,:)./datafullset(1,:,:,:)); % Zonal wind (positive east)
velzfull=squeeze(datafullset(4,:,:,:)./datafullset(1,:,:,:)); % Verical wind (positive upward)
doxs=(squeeze(6.022d23.*datafullset(6,:,:,:).*datafullset(1,:,:,:).*1e-3.*(1/16)))-dox0; % Atomic oxygen perturbations
dnit2s=(squeeze(6.022d23.*(1-datafullset(6,:,:,:)-datafullset(7,:,:,:)).*datafullset(1,:,:,:).*1e-3.*(1/28)))-dnit20; % Nitrogen perturbations
dox2s=(squeeze(6.022d23.*datafullset(7,:,:,:).*datafullset(1,:,:,:).*1e-3.*(1/32)))-dox20; % Molecular oxygen perturbations
temps=T-T0; % Temperature perturbations

% Taper for GEMINI inputs
tukey1 = tukeywin(90,0.15);
tukey2 = tukeywin(80,0.15);
[maskr,maskc]=meshgrid(tukey1,tukey2);
w=maskr.*maskc;
w = repmat(w,[1,1,100]);
w = permute(w,[3,1,2]);

% Permute matrices to have vertical, zonal, and then meridional structure and apply taper
velxfull=permute(velxfull,[3,2,1]).*w;
velyfull=permute(velyfull,[3,2,1]).*w;
velzfull=permute(velzfull,[3,2,1]).*w;
temps=permute(temps,[3,2,1]).*w;
dox2s=permute(dox2s,[3,2,1]).*w;
dnit2s=permute(dnit2s,[3,2,1]).*w;
doxs=permute(doxs,[3,2,1]).*w;

hFig = figure;
set(hFig, 'Position', [30 70 2000 1200])    
hz = suptitle(['T = ',num2str(Frame*5),' sec, Frame = ',num2str(Frame)]);
set(hz,'FontSize',15,'FontWeight','normal');
set(gcf,'color','white')
subplot(3,3,2)
pcolor(1:9.3750:750,1:5:500,squeeze(velyfull(:,:,45)))
axis xy
title('Central zonal slice with altitude (zon. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Zonal direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velyfull(:,:,45)))) max(max(squeeze(velyfull(:,:,45))))])
subplot(3,3,1)
pcolor(1:8.3333:750,1:5:500,squeeze(velyfull(:,40,:)))
axis xy
title('Central meridional slice with altitude (zon. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Meridional direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velyfull(:,40,:)))) max(max(squeeze(velyfull(:,40,:))))])
subplot(3,3,3)
pcolor(1:9.3750:750,1:8.3333:750,squeeze(velyfull(50,:,:))') % x - zonal, y - meridional
ylabel('Meridional direction (km)')
xlabel('Zonal direction (km)')
title('Horizontal slice at 250 km altitude (zon. vel. m/s)')
colorbar
shading interp
caxis([-max(max(squeeze(velyfull(50,:,:)))) max(max(squeeze(velyfull(50,:,:))))])
%-----
subplot(3,3,5)
pcolor(1:9.3750:750,1:5:500,squeeze(velxfull(:,:,45)))
axis xy
title('Central zonal slice with altitude (mer. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Zonal direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velxfull(:,:,45)))) max(max(squeeze(velxfull(:,:,45))))])
subplot(3,3,4)
pcolor(1:8.3333:750,1:5:500,squeeze(velxfull(:,40,:)))
axis xy
title('Central meridional slice with altitude (mer. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Meridional direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velxfull(:,40,:)))) max(max(squeeze(velxfull(:,40,:))))])
subplot(3,3,6)
pcolor(1:9.3750:750,1:8.3333:750,squeeze(velxfull(50,:,:))') % x - zonal, y - meridional
ylabel('Meridional direction (km)')
xlabel('Zonal direction (km)')
title('Horizontal slice at 250 km altitude (mer. vel. m/s)')
colorbar
shading interp
caxis([-max(max(squeeze(velxfull(50,:,:)))) max(max(squeeze(velxfull(50,:,:))))])
%-----
subplot(3,3,8)
pcolor(1:9.3750:750,1:5:500,squeeze(velzfull(:,:,45)))
axis xy
title('Central zonal slice with altitude (vert. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Zonal direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velzfull(:,:,45)))) max(max(squeeze(velzfull(:,:,45))))])
subplot(3,3,7)
pcolor(1:8.3333:750,1:5:500,squeeze(velzfull(:,40,:)))
axis xy
title('Central meridional slice with altitude (vert. vel. m/s)')
ylabel('Altitude (km)')
xlabel('Meridional direction (km)')
colorbar
shading interp
caxis([-max(max(squeeze(velzfull(:,40,:)))) max(max(squeeze(velzfull(:,40,:))))])
subplot(3,3,9)
pcolor(1:9.3750:750,1:8.3333:750,squeeze(velzfull(50,:,:))') % x - zonal, y - meridional
ylabel('Meridional direction (km)')
xlabel('Zonal direction (km)')
title('Horizontal slice at 250 km altitude (vert. vel. m/s)')
colorbar
shading interp
caxis([-max(max(squeeze(velzfull(50,:,:)))) max(max(squeeze(velzfull(50,:,:))))])    

mov(Frame+1) = getframe(gcf);

close all

Frame = Frame + 1;

end