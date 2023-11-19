function makedneuframes3Dcart_h5(outdir, indir)
% prepare 3D Cartesian neutral inputs to GEMINI saving them into HDF5 file format
arguments
  outdir (1,1) string
  indir (1,1) string {mustBeFolder}
end

import stdlib.hdf5nc.h5save

stdlib.fileio.makedir(outdir)

% Specify initial time and timestep of data
time = datetime(2011,3,11, 0, 0, 20783);
dtneu = seconds(600); % timestep

% Specify input data
lt=46; % number of time steps
lx1=502; % zonal direciton
lx2=502; % meridional direction
lx3=321; % vertical direction

% Specify simsize
filename= fullfile(outdir, 'simsize.h5');
disp("write " + filename)
if isfile(filename), delete(filename), end

h5save(filename, '/lx1', lx1, "type", "int32")
h5save(filename, '/lx2', lx2, "type", "int32")
h5save(filename, '/lx3', lx3, "type", "int32")

freal = 'float32';

datastarttime=7760;
datastride=2000;
for it=1:lt
% % This assumes that each input variable is saved in a separate file that should be loaded separately (to alleviate memory issue)
% % This script expect that *.mat file inputs are saved as x,y,z (lon,lat,alt)
% % This script expects files names as XXX[timeframe].mat, where XXX - required variable and [timeframe] - sequential number of input starting from 0.
%   load(fullfile(indir, "velx" + int2str(it-1) + ".mat"), "velxfull"); % zonal fluid velocity (positive east)
%   load(fullfile(indir, "vely" + int2str(it-1) + ".mat"), "velyfull"); % meridional fluid velocity (positive north)
%   load(fullfile(indir, "velz" + int2str(it-1) + ".mat"), "velzfull"); % vertical fluid velocity (positive up)
%   load(fullfile(indir, "doxs" + int2str(it-1) + ".mat"), "doxs"); % O perturbations
%   load(fullfile(indir, "dox2s" + int2str(it-1) + ".mat"), "dox2s"); % O2 perturbations
%   load(fullfile(indir, "dnit2s" + int2str(it-1) + ".mat"), "dnit2s"); % N2 perturbations
%   load(fullfile(indir, "temps" + int2str(it-1) + ".mat"), "temps"); % Temperature perturbations

  % CGCAM format from Tom Lund
  datatime=datastarttime+(it-1)*datastride;
  fnameaffix=num2str(datatime);
  while(numel(fnameaffix)<6)
    fnameaffix=['0',fnameaffix];
  end %while
  fname=['vel.',fnameaffix]
  fname=strcat(indir,'/',fname)
  fid=fopen(fullfile(fname),'r');
  dat=fread(fid,lx1*lx2*lx3*5,freal);
  dat=reshape(dat,[lx1,lx2,lx3,5]);
  velxfull=dat(:,:,:,2);
  velyfull=dat(:,:,:,3);
  velzfull=dat(:,:,:,4);
  temps=dat(:,:,:,5);
  dox2s=zeros(lx1,lx2,lx3);
  dnit2s=zeros(lx1,lx2,lx3);
  doxs=zeros(lx1,lx2,lx3);

  % GEMINI requires (alt,lon,lat) structure of data
  velxfull=permute(velxfull,[3,2,1]); % zonal fluid velocity
  velyfull=permute(velyfull,[3,2,1]); % meridional fluid velocity
  velzfull=permute(velzfull,[3,2,1]); % vertical fluid velocity
  temps=permute(temps,[3,2,1]);
  dox2s=permute(dox2s,[3,2,1]);
  dnit2s=permute(dnit2s,[3,2,1]);
  doxs=permute(doxs,[3,2,1]);

  filename = fullfile(outdir, gemini3d.datelab(time) + ".h5");

  h5save(filename, '/dn0all', doxs, "type",  freal) % O perturbations
  h5save(filename, '/dnN2all', dnit2s, "type",  freal) % N2 perturbations
  h5save(filename, '/dnO2all', dox2s, "type",  freal) % O2 perturbations
  h5save(filename, '/dvnxall', velyfull, "type",  freal) % Zonal fluid velocity (positive east)
  h5save(filename, '/dvnrhoall', velxfull, "type",  freal) % Meridional fluid velocity (positive north)
  h5save(filename, '/dvnzall', velzfull, "type",  freal) % Vertical velocity (positive upward)
  h5save(filename, '/dTnall', temps, "type",  freal) % Temperature perturbations

  time = time + dtneu;

end  % for it

end % function
