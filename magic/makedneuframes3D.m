% This script prepares 3D Cartesian neutral inputs

% Location of output data
outdir='./datap/'
mkdir([outdir]);

% Specify date and time of simulation start
ymd0=[2011,03,11]; % date
UTsec0=20783; % Second from day start (UT)

lt=630; % Number of time steps
dtneu=4; % Sampling of time steps (in seconds)
lx=300; % number of points in zonal direction
ly=300; % number of points in meridional direction
lz=300; % number of points in vertical direction

% Create a binary file that contain information on neutral input grid size
filename=[outdir,'simsize.dat'];
fid=fopen(filename,'w');
fwrite(fid,lx,'integer*4');
fwrite(fid,ly,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);

ymd=ymd0;
UTsec=UTsec0;

% Create a sequence of binary output files that contain a frame of data each
for it=1:lt

% This assumes that each input variable is saved in a separate file that should be loaded separately (to alleviate memory issue)
load(strcat('velx',num2str(it-1),'.mat'),'velxfull');
load(strcat('vely',num2str(it-1),'.mat'),'velyfull');
load(strcat('velz',num2str(it-1),'.mat'),'velzfull');
load(strcat('doxs',num2str(it-1),'.mat'),'doxs');
load(strcat('dox2s',num2str(it-1),'.mat'),'dox2s');
load(strcat('dnit2s',num2str(it-1),'.mat'),'dnit2s');
load(strcat('temps',num2str(it-1),'.mat'),'temps');

    velxfull=permute(velxfull,[3,1,2]); % GEMINI expects z,x,y (alt,lon,lat) inputs. This script expect *.mat file input is saved as x,y,z (lon,lat,alt)

    velyfull=permute(velyfull,[3,1,2]);

    velzfull=permute(velzfull,[3,1,2]);

    temps=permute(temps,[3,1,2]);

    dox2s=permute(dox2s,[3,1,2]);

    dnit2s=permute(dnit2s,[3,1,2]);

    doxs=permute(doxs,[3,1,2]);

    filename= gemini3d.datelab(ymd,UTsec);
    filename=[outdir,filename,'.dat']
    fid=fopen(filename,'w');
    fwrite(fid,doxs,'real*8');
    fwrite(fid,dnit2s,'real*8');
    fwrite(fid,dox2s,'real*8');
    fwrite(fid,velxfull,'real*8');
    fwrite(fid,velyfull,'real*8');
    fwrite(fid,velzfull,'real*8');
    fwrite(fid,temps,'real*8');
    fclose(fid);

    [ymd,UTsec]= gemini3d.dateinc(dtneu,ymd,UTsec);
end
