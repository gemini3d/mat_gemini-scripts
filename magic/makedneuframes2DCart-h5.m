% This scripts prepares 2D Cartesian neutral inputs to GEMINI saving them into HDF5 format files

% Location of output data
outdir = "datap";
gemini3d.fileio.makedir(outdir);

% Specify date and time of simulation start
ymd0=[2011,3,11]; % date
UTsec0=35100.0; % seconds in day
dtneu=5;

ymd=ymd0;
UTsec=UTsec0;

% This example wants to load all neutral inputs together with the matrix structure: [time,lat,alt]. Should be adjusted accordingly in case of need.
if ~exist('velx', 'var')
    load('velx.mat');
    load('velz.mat');
    load('temp.mat');
    load('dox2s.mat');
    load('dnit2s.mat');
    load('doxs.mat');
end

[lt,lx1,lx2]=size(velx);

% Save grid structure file
filename=[outdir,'simsize.h5'];
disp("write " + filename)
if isfile(filename), delete(filename), end
hdf5nc.h5save(filename, '/lx1', lx1, "type", "int32") % meridional direction
hdf5nc.h5save(filename, '/lx2', lx2, "type", "int32") % vertical direction

for it=1:lt
% Permute matrices to have vertical and then meridional structure of a matrix
    velxnow=squeeze(velx(it,:,:));
    velxnow=permute(velxnow,[2, 1]);
    velznow=squeeze(velz(it,:,:));
    velznow=permute(velznow,[2, 1]);
    tempnow=squeeze(temp(it,:,:));
    tempnow=permute(tempnow,[2, 1]);
    dox2snow=squeeze(dox2s(it,:,:));
    dox2snow=permute(dox2snow,[2, 1]);
    dnit2snow=squeeze(dnit2s(it,:,:));
    dnit2snow=permute(dnit2snow,[2, 1]);
    doxsnow=squeeze(doxs(it,:,:));
    doxsnow=permute(doxsnow,[2, 1]);

% Write data to file
filename=datelab(ymd,UTsec);
filename=[outdir,filename,'.h5'];
% Be sure that setup from mat_gemini was executed prior running this code
hdf5nc.h5save(filename, '/dn0all', doxsnow, "type",  freal) % O perturbations
hdf5nc.h5save(filename, '/dnN2all', dnit2snow, "type",  freal) % N2 perturbations
hdf5nc.h5save(filename, '/dnO2all', dox2snow, "type",  freal) % O2 perturbations
hdf5nc.h5save(filename, '/dvnrhoall', velxnow, "type",  freal) % dvnrhoall - fluid velocity in meridional direction
hdf5nc.h5save(filename, '/dvnzall', velznow, "type",  freal) % dvnzall - fluid velocity in vertical direction
hdf5nc.h5save(filename, '/dTnall', tempnow, "type",  freal) % Temperature perturbations

[ymd,UTsec]=gemini3d.dateinc(dtneu,ymd,UTsec); % increment time

end
