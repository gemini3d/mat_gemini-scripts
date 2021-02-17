% This script prepares 3D Cartesian GEMINI neutral inputs from 2D axisymmetric neutral data and save data in depreciated raw GEMINI input files

% LOCATION OF OUTPUT DATA
outdir = "datap";
gemini3d.fileio.makedir(outdir)

% Specify date and time of simulation start
time = datetime(2011,3,11) + seconds(20783);  % Second from day start (UT)
dtneu = seconds(4);  % Sampling of time steps

% Thie example expects to load all inputs together in the format (time,rho,z) 
if ~exist('velx', 'var')
    load([indir,'/velx',simlab,loc,'.mat']);
    load([indir,'/velz',simlab,loc,'.mat']);
    load([indir,'/temp',simlab,loc,'.mat']);
    load([indir,'/dox2',simlab,loc,'.mat']);
    load([indir,'/dnit2',simlab,loc,'.mat']);
    load([indir,'/dox',simlab,loc,'.mat']);
end

[lt,lrhon,lzn]=size(velx); % Get size of the matrix of neutral inputs

%% Create grid of neutral axisymmetric input
dzn=1e3; % altitude grid size
drhon=1e3; % radial distance grid size
zn=0:dzn:(lzn-1)*dzn;
rhon=0:drhon:(lrhon-1)*drhon;

% Create grid of 3D neutral input
lx=600; % zonal direction
ly=600; % meridional direction
lz=375; % altitude
x=linspace(-1*max(rhon),max(rhon),lx);    %interpreted as eastward distance
y=linspace(-1*max(rhon),max(rhon),ly);    %northward distance
z=linspace(min(zn),max(zn),lz);           %altitude
[X,Z,Y]=meshgrid(x,z,y);
RHO=sqrt(X.^2+Y.^2);                      %ground distance from epicenter
PHI=atan2(Y,X);                           %angle from east

% Create a binary file that contain information on neutral input grid size
filename = fullfile(outdir, 'simsize.dat');
fid=fopen(filename,'w');
fwrite(fid,lx,'integer*4');
fwrite(fid,ly,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);


%% Cycle through all epochs, interpolate, rotate and save

for it=1:lt
    velrhonow=squeeze(velx(it,:,:));     %note that these are organized as t,rho,z - the fortran code wants z,rho
    velrhonow=permute(velrhonow,[2, 1]);
    velrho3D=interp2(rhon,zn,velrhonow,RHO(:),Z(:));
    velrho3D(isnan(velrho3D))=0;
    velrho3D=reshape(velrho3D,[lz,lx,ly]);

    velx3D=velrho3D.*cos(PHI);
    vely3D=velrho3D.*sin(PHI);

    velznow=squeeze(velz(it,:,:));
    velznow=permute(velznow,[2, 1]);
    velz3D=interp2(rhon,zn,velznow,RHO(:),Z(:));
    velz3D(isnan(velz3D))=0;
    velz3D=reshape(velz3D,[lz,lx,ly]);

    tempnow=squeeze(temp(it,:,:));
    tempnow=permute(tempnow,[2, 1]);
    temp3D=interp2(rhon,zn,tempnow,RHO(:),Z(:));
    temp3D(isnan(temp3D))=0;
    temp3D=reshape(temp3D,[lz,lx,ly]);

    dox2snow=squeeze(dox2s(it,:,:));
    dox2snow=permute(dox2snow,[2, 1]);
    dox2s3D=interp2(rhon,zn,dox2snow,RHO(:),Z(:));
    dox2s3D(isnan(dox2s3D))=0;
    dox2s3D=reshape(dox2s3D,[lz,lx,ly]);

    dnit2snow=squeeze(dnit2s(it,:,:));
    dnit2snow=permute(dnit2snow,[2, 1]);
    dnit2s3D=interp2(rhon,zn,dnit2snow,RHO(:),Z(:));
    dnit2s3D(isnan(dnit2s3D))=0;
    dnit2s3D=reshape(dnit2s3D,[lz,lx,ly]);

    doxsnow=squeeze(doxs(it,:,:));
    doxsnow=permute(doxsnow,[2, 1]);
    doxs3D=interp2(rhon,zn,doxsnow,RHO(:),Z(:));
    doxs3D(isnan(doxs3D))=0;
    doxs3D=reshape(doxs3D,[lz,lx,ly]);

    filename = fullfile(outdir, gemini3d.datelab(time), '.dat');
    fid=fopen(filename,'w');
    fwrite(fid,doxs3D,'real*8');
    fwrite(fid,dnit2s3D,'real*8');
    fwrite(fid,dox2s3D,'real*8');
    fwrite(fid,velx3D,'real*8');
    fwrite(fid,vely3D,'real*8');
    fwrite(fid,velz3D,'real*8');
    fwrite(fid,temp3D,'real*8');
    fclose(fid);

    time = time + dtneu;
end %for
