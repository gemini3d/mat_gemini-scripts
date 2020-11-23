% Be sure that the setup routine from ./mat_gemini  was executed prior running this code

close all
clc

%% Location of output data

outdir='./datap/';

%% Specify initial time and timestep of data

ymd0=[2011,3,11];
UTsec0=20700.0;
dtneu=10;

%% Specify input data

lt=1440; % number of time steps
lx=880; % longitude
ly=1098; % latitude
lz=500; % altitude

% Specify simsize
filename=[outdir,'simsize.h5'];
disp("write " + filename)
if isfile(filename), delete(filename), end

hdf5nc.h5save(filename, '/lx1', lx, "type", "int32")
hdf5nc.h5save(filename, '/lx2', ly, "type", "int32")
hdf5nc.h5save(filename, '/lx3', lz, "type", "int32")

freal = 'float32';

ymd=ymd0;
UTsec=UTsec0;

for it=1:lt
    
load(strcat('velx',num2str(it),'.mat'),'velxfull');
load(strcat('vely',num2str(it),'.mat'),'velyfull');
load(strcat('velz',num2str(it),'.mat'),'velzfull');
load(strcat('doxs',num2str(it),'.mat'),'doxs');
load(strcat('dox2s',num2str(it),'.mat'),'dox2s');
load(strcat('dnit2s',num2str(it),'.mat'),'dnit2s');
load(strcat('temps',num2str(it),'.mat'),'temps');

% GEMINI requires (alt,lon,lat) structure of data
     velxfull=permute(velxfull,[3,2,1]); % zonal direction
     velyfull=permute(velyfull,[3,2,1]); % meridional direction
     velzfull=permute(velzfull,[3,2,1]);
     temps=permute(temps,[3,2,1]);
     dox2s=permute(dox2s,[3,2,1]);
     dnit2s=permute(dnit2s,[3,2,1]);
     doxs=permute(doxs,[3,2,1]);
  
filename=gemini3d.datelab(ymd,UTsec);
filename=[outdir,filename,'.h5'];

hdf5nc.h5save(filename, '/dn0all', doxs, "type",  freal) % O
hdf5nc.h5save(filename, '/dnN2all', dnit2s, "type",  freal) % N2
hdf5nc.h5save(filename, '/dnO2all', dox2s, "type",  freal) % O2
hdf5nc.h5save(filename, '/dvnxall', velyfull, "type",  freal) % Zonal velocity
hdf5nc.h5save(filename, '/dvnrhoall', velxfull, "type",  freal) % Meridional velocity
hdf5nc.h5save(filename, '/dvnzall', velzfull, "type",  freal) % Vertical velocity
hdf5nc.h5save(filename, '/dTnall', temps, "type",  freal) % Temperature


    [ymd,UTsec]=gemini3d.dateinc(dtneu,ymd,UTsec);
    
end