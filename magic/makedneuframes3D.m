
% File format to save files
fileformatflag = 'raw';

%% LOCATION OF INPUT DATA (if out of the current folder)
%indir='~/zettergmdata/simulations.MAGIC/okx2/old/'

%% LOCATION OF OUTPUT DATA
outdir='./datap/'

%% NEED TO SPECIFY DATA FOR GEMINI
ymd0=[2011,03,11];
UTsec0=20783;
dtneu=4; % Time step of neutrals

lt=630; % Number of time steps
lx=300; % Number of points in longitudinal direciton
ly=300; % Number of points in latitudinal direction
lz=300; % Number of points in altitudinal direction

%CREATE A SEQUENCE OF BINBARY OUTPUT FILES THAT CONTAIN A FRAME OF DATA EACH
filename=[outdir,'simsize.dat'];
fid=fopen(filename,'w');
fwrite(fid,lx,'integer*4');
fwrite(fid,ly,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);

ymd=ymd0;
UTsec=UTsec0;
for it=1:lt

% If each time step and variable are saved in different file
load(strcat('velx',num2str(it-1),'.mat'),'velxfull');
load(strcat('vely',num2str(it-1),'.mat'),'velyfull');
load(strcat('velz',num2str(it-1),'.mat'),'velzfull');
load(strcat('doxs',num2str(it-1),'.mat'),'doxs');
load(strcat('dox2s',num2str(it-1),'.mat'),'dox2s');
load(strcat('dnit2s',num2str(it-1),'.mat'),'dnit2s');
load(strcat('temps',num2str(it-1),'.mat'),'temps');

    %note that these are assumed to be organized as t,x,y,z - the fortran code wants z,x,y (alt,lon,lat)
    velxfull=permute(velxfull,[3,1,2]);
    velyfull=permute(velyfull,[3,1,2]);
    velzfull=permute(velzfull,[3,1,2]);
    temps=permute(temps,[3,1,2]);
    dox2s=permute(dox2s,[3,1,2]);
    dnit2s=permute(dnit2s,[3,1,2]);
    doxs=permute(doxs,[3,1,2]);

    filename= gemini3d.datelab(ymd,UTsec);
    if(fileformatflag=='raw')
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
    end
    
    [ymd,UTsec]= gemini3d.dateinc(dtneu,ymd,UTsec);
end
