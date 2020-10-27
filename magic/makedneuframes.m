% This scripts prepares 2D Cartesian neutral inputs

% Location of output data
outdir='./datap/'
mkdir([outdir]);

% Specify date and time of simulation start
ymd0=[2011,03,11]; % date
UTsec0=20783; % Second from day start (UT)
dtneu=4; % Sampling of time steps (in seconds)

% Thie example expects to load all inputs together in the format (time,x,z) -> (time,lat,alt)
if ~exist('velx')
    load([indir,'/velx',simlab,loc,'.mat']);
    load([indir,'/velz',simlab,loc,'.mat']);
    load([indir,'/temp',simlab,loc,'.mat']);
    load([indir,'/dox2s',simlab,loc,'.mat']);
    load([indir,'/dnit2s',simlab,loc,'.mat']);
    load([indir,'/doxs',simlab,loc,'.mat']);
end

[lt,lrho,lz]=size(velx);

% Create a binary file that contain information on neutral input grid size
filename=[outdir,'simsize.dat']
fid=fopen(filename,'w');
fwrite(fid,lrho,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);

ymd=ymd0;
UTsec=UTsec0;
for it=1:lt
    velxnow=squeeze(velx(it,:,:));
    velxnow=permute(velxnow,[2, 1]);  % GEMINI expects z,x,y (alt,lat) inputs. This script expect *.mat file input is saved as x,z (lat,alt)

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

    filename= gemini3d.datelab(ymd,UTsec);
    filename=[outdir,filename,'.dat']
    fid=fopen(filename,'w');
    fwrite(fid,doxsnow,'real*8');
    fwrite(fid,dnit2snow,'real*8');
    fwrite(fid,dox2snow,'real*8');
    fwrite(fid,velxnow,'real*8');
    fwrite(fid,velznow,'real*8');
    fwrite(fid,tempnow,'real*8');
    fclose(fid);

    [ymd,UTsec]= gemini3d.dateinc(dtneu,ymd,UTsec);
end
