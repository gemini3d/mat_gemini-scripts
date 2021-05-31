function makedneuframes3Dcart_dat(outdir, indir)
% prepare 3D Cartesian neutral inputs to GEMINI saving them into depreciated raw format files
arguments
  outdir (1,1) string
  indir (1,1) string
end

stdlib.fileio.makedir(outdir)

% Specify date and time of simulation start
time = datetime(2011, 3, 11, 0, 0, 20783); % Second from day start (UT)
dtneu = seconds(4); % Sampling of time steps (in seconds)

lt=630; % Total number of time steps

lx1=300; % number of points in zonal direction
lx2=300; % number of points in meridional direction
lx3=300; % number of points in vertical direction

% Create a binary file that contain information on neutral input grid size
filename= fullfile(outdir,'simsize.dat');
fid=fopen(filename,'w');
fwrite(fid,lx1,'integer*4');
fwrite(fid,lx2,'integer*4');
fwrite(fid,lx3,'integer*4');
fclose(fid);

% Create a sequence of binary output files that contain a frame of data each
for it=1:lt

% This assumes that each input variable is saved in a separate file that should be loaded separately (to alleviate memory issue)
% This script expect that *.mat file inputs are saved as x,y,z (lon,lat,alt)
% This script expects files names as XXX[timeframe].mat, where XXX - required variable and [timeframe] - sequential number of input starting from 0.
  load(fullfile(indir, "velx" + int2str(it-1) + ".mat"), "velxfull"); % zonal fluid velocity (positive east)
  load(fullfile(indir, "vely" + int2str(it-1) + ".mat"), "velyfull"); % meridional fluid velocity (positive north)
  load(fullfile(indir, "velz" + int2str(it-1) + ".mat"), "velzfull"); % vertical fluid velocity (positive up)
  load(fullfile(indir, "doxs" + int2str(it-1) + ".mat"), "doxs"); % O perturbations
  load(fullfile(indir, "dox2s" + int2str(it-1) + ".mat"), "dox2s"); % O2 perturbations
  load(fullfile(indir, "dnit2s" + int2str(it-1) + ".mat"), "dnit2s"); % N2 perturbations
  load(fullfile(indir, "temps" + int2str(it-1) + ".mat"), "temps"); % Temperature perturbations

  velxfull=permute(velxfull,[3,1,2]); % GEMINI expects z,x,y (alt,lon,lat) inputs.
  velyfull=permute(velyfull,[3,1,2]);
  velzfull=permute(velzfull,[3,1,2]);
  temps=permute(temps,[3,1,2]);
  dox2s=permute(dox2s,[3,1,2]);
  dnit2s=permute(dnit2s,[3,1,2]);
  doxs=permute(doxs,[3,1,2]);

  filename = fullfile(outdir, gemini3d.datelab(time) + ".dat");
  fid=fopen(filename,'w');
  fwrite(fid,doxs,'real*8');
  fwrite(fid,dnit2s,'real*8');
  fwrite(fid,dox2s,'real*8');
  fwrite(fid,velxfull,'real*8');
  fwrite(fid,velyfull,'real*8');
  fwrite(fid,velzfull,'real*8');
  fwrite(fid,temps,'real*8');
  fclose(fid);

  time = time + dtneu;
end  % for it

end % function
