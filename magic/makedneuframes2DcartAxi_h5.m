function makedneuframes2DcartAxi_h5(outdir, indir)
% prepare 2D Cartesian neutral inputs to GEMINI saving them into HDF5 format files
% Same script can be used to prepare 2D/3D Axisymmetric input to GEMINI
% with dvnrhoall - radial and dvnzall - vertical directions
arguments
    outdir (1,1) string
    indir (1,1) string
end

import stdlib.hdf5nc.h5save

stdlib.fileio.makedir(outdir)

% Specify date and time of simulation start
time = datetime(2016,3,3, 0, 0, 18900); % seconds in day
dtneu = seconds(6);

% This example wants to load all neutral inputs together with
% the matrix structure: [time,lat,alt].
% Should be adjusted accordingly in case of need.
velx = load(fullfile(indir, 'velx.mat'), "velx").velx;
velz = load(fullfile(indir, 'velz.mat'), "velz").velz;
temp = load(fullfile(indir, 'temp.mat'), "temp").temp;
dox2s = load(fullfile(indir, 'dox2s.mat'), "dox2s").dox2s;
dnit2s = load(fullfile(indir, 'dnit2s.mat'), "dnit2s").dnit2s;
doxs = load(fullfile(indir, 'doxs.mat'), "doxs").doxs;

[lt,lx1,lx2]=size(velx);

% Save grid structure file
filename = fullfile(outdir, 'simsize.h5');
disp("write " + filename)
if isfile(filename), delete(filename), end
h5save(filename, '/lx1', lx1, "type", "int32") % meridional direction
h5save(filename, '/lx2', lx2, "type", "int32") % vertical direction

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
    freal="float32";
    filename = fullfile(outdir, gemini3d.datelab(time) + ".h5");
    % Be sure that setup from mat_gemini was executed prior running this code
    h5save(filename, '/dn0all', doxsnow, "type",  freal) % O perturbations
    h5save(filename, '/dnN2all', dnit2snow, "type",  freal) % N2 perturbations
    h5save(filename, '/dnO2all', dox2snow, "type",  freal) % O2 perturbations
    h5save(filename, '/dvnrhoall', velxnow, "type",  freal) % dvnrhoall - fluid velocity in meridional direction or radial in Axisymmetric simulations
    h5save(filename, '/dvnzall', velznow, "type",  freal) % dvnzall - fluid velocity in vertical direction
    h5save(filename, '/dTnall', tempnow, "type",  freal) % Temperature perturbations
    time = time + dtneu;
end % for it
end % function
