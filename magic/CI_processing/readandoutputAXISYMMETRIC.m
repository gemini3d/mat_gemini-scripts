% Import needed slice or make a slice from imported data

import stdlib.hdf5nc.h5save
for i=1:1:MaxFrames

indir='../MAGIC_OUTPUT/';
nameCur = strcat(indir,'/fort.qq',num2str(Frame,'%04i'),'id0000','.h5');

% Read MAGIC grid structure and simulation configuration
attr = h5readatt(nameCur,'/Pid','Parameters'); % Thread MASTER (0) always outputs its data
lx = attr(22);
ly = attr(23);
lz = attr(24);

fprintf('Working on data from file: %s\n',nameCur);

% Read data from HDF5 files
id = 1;
dataset=[];
datafullset=[];
for ii=1:1:lx
for jj=1:1:ly
nameCur = strcat(indir,'fort.qq',num2str(Frame,'%04i'),'id',num2str(id-1,'%04i'),'.h5');
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

% GEMINI requires (alt,lon,lat) structure of data
velxfull=permute(velxfull,[3,2,1]); % MERIDIONAL
velyfull=permute(velyfull,[3,2,1]); % ZONAL
velzfull=permute(velzfull,[3,2,1]);
temps=permute(temps,[3,2,1]);
dox2s=permute(dox2s,[3,2,1]);
dnit2s=permute(dnit2s,[3,2,1]);
doxs=permute(doxs,[3,2,1]);

% Permute matrices to have vertical, zonal, and then meridional
% Then cut half of the domain in meridional direction (46:90) along center
% of the domain in zonal direciton. Be sure that matrix starts with r=0
% in 3rd direction
velxfull=squeeze(velxfull(:,40,46:90));
velyfull=squeeze(velyfull(:,40,46:90));
velzfull=squeeze(velzfull(:,40,46:90));
temps=squeeze(temps(:,40,46:90));
dox2s=squeeze(dox2s(:,40,46:90));
dnit2s=squeeze(dnit2s(:,40,46:90));
doxs=squeeze(doxs(:,40,46:90));

% Write data to file
timevar=datetime([ymd,0,0,UTsec]);
filename=gemini3d.datelab(timevar);
filename=strcat(outdir,filename,'.h5');
% Be sure that setup from mat_gemini was executed prior running this code
h5save(filename, '/dn0all', doxs, "type",  freal) % O perturbations
h5save(filename, '/dnN2all', dnit2s, "type",  freal) % N2 perturbations
h5save(filename, '/dnO2all', dox2s, "type",  freal) % O2 perturbations
h5save(filename, '/dvnrhoall', velxfull, "type",  freal) % dvnrhoall - radial (note - we store here velxfull)
h5save(filename, '/dvnzall', velzfull, "type",  freal) % Vertical velocity
h5save(filename, '/dTnall', temps, "type",  freal) % Temperature perturbations

pcolor(1:8.3333:375,1:5:500,velzfull)
shading interp
title('Pcolor snapshoot of vert. vel (m/s)')
xlabel('Radial direction (km)')
ylabel('Vertical direction (km)')

%pause

[ymd,UTsec]=gemini3d.dateinc(dtneu,ymd,UTsec);

Frame = Frame + 1;

end
