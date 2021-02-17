% This scripts prepares 3D Cartesian neutral inputs to GEMINI saving them into HDF5 file format

% Location of output data
outdir='./datap/';

% Specify initial time and timestep of data
ymd0=[2011,3,11];
UTsec0=20700.0;
dtneu=10; % timestep

% Specify input data
lt=1440; % number of time steps
lx1=880; % zonal direciton
lx2=1098; % meridional direction
lx3=500; % vertical direction

% Specify simsize
filename=[outdir,'simsize.h5'];
disp("write " + filename)
if isfile(filename), delete(filename), end

hdf5nc.h5save(filename, '/lx1', lx1, "type", "int32")
hdf5nc.h5save(filename, '/lx2', lx2, "type", "int32")
hdf5nc.h5save(filename, '/lx3', lx3, "type", "int32")

freal = 'float32';

ymd=ymd0;
UTsec=UTsec0;

for it=1:lt
% This assumes that each input variable is saved in a separate file that should be loaded separately (to alleviate memory issue)
% This script expect that *.mat file inputs are saved as x,y,z (lon,lat,alt)
% This script expects files names as XXX[timeframe].mat, where XXX - required variable and [timeframe] - sequential number of input starting from 0.
load(strcat('velx',num2str(it-1),'.mat'),'velxfull');
load(strcat('vely',num2str(it-1),'.mat'),'velyfull');
load(strcat('velz',num2str(it-1),'.mat'),'velzfull');
load(strcat('doxs',num2str(it-1),'.mat'),'doxs');
load(strcat('dox2s',num2str(it-1),'.mat'),'dox2s');
load(strcat('dnit2s',num2str(it-1),'.mat'),'dnit2s');
load(strcat('temps',num2str(it-1),'.mat'),'temps');

% GEMINI requires (alt,lon,lat) structure of data
velxfull=permute(velxfull,[3,2,1]); % zonal fluid velocity
velyfull=permute(velyfull,[3,2,1]); % meridional fluid velocity
velzfull=permute(velzfull,[3,2,1]); % vertical fluid velocity
temps=permute(temps,[3,2,1]);
dox2s=permute(dox2s,[3,2,1]);
dnit2s=permute(dnit2s,[3,2,1]);
doxs=permute(doxs,[3,2,1]);
  
filename=gemini3d.datelab(ymd,UTsec);
filename=[outdir,filename,'.h5'];

hdf5nc.h5save(filename, '/dn0all', doxs, "type",  freal) % O perturbations
hdf5nc.h5save(filename, '/dnN2all', dnit2s, "type",  freal) % N2 perturbations
hdf5nc.h5save(filename, '/dnO2all', dox2s, "type",  freal) % O2 perturbations
hdf5nc.h5save(filename, '/dvnxall', velyfull, "type",  freal) % Zonal fluid velocity (positive east)
hdf5nc.h5save(filename, '/dvnrhoall', velxfull, "type",  freal) % Meridional fluid velocity (positive north)
hdf5nc.h5save(filename, '/dvnzall', velzfull, "type",  freal) % Vertical velocity (positive upward)
hdf5nc.h5save(filename, '/dTnall', temps, "type",  freal) % Temperature perturbations

    [ymd,UTsec]=gemini3d.dateinc(dtneu,ymd,UTsec);
    
end
