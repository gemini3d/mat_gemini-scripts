cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd, filesep, '../../GEMINI/'];
addpath([gemini_root, filesep, 'script_utils'])

%% LOCATION OF INPUT DATA
indir='~/zettergmdata/simulations.MAGIC/okx2/old/'
%indir='~/neutral_sims/chile06052017/'
%indir='~/neutral_sims/2016mooreOK/'
%indir='/media/data/chile2015_0.5MSIS/'
%indir='/media/data/nepal/'
loc='';
%simlab='chile'
%simlab='nepal'
%simlab='strong'
simlab='';


%% LOCATION OF OUTPUT DATA
%outdir=['~/simulations/mooreOK_neutrals/'];
%outdir=['~/simulations/chile2015_0.5_neutrals/'];
%outdir='~/simulations/nepal2015_neutrals/'
outdir='~/zettergmdata/simulations/mooreOKx2_neutrals/'
mkdir([outdir]);


%% NEED TO SPECIFY DATA FOR GEMINI
%ymd0=[2015,09,16];
%UTsec0=82473;
%dtneu=4;

ymd0=[2013,05,20];
UTsec0=71100;
dtneu=6;

%ymd0=[2015,4,24];
%UTsec0=22285;
%dtneu=4;

%TOHOKU EXAMPLE
%ymd0=[2011,3,11];
%UTsec0=20783;
%dtneu=2;


%% LOAD THE DATA FROM AN INPUT MAGIC SIMULATION
if ~exist('velx')
    load([indir,'/velx',simlab,loc,'.mat']);
    load([indir,'/velz',simlab,loc,'.mat']);
    load([indir,'/temp',simlab,loc,'.mat']);
    load([indir,'/dox2s',simlab,loc,'.mat']);
    load([indir,'/dnit2s',simlab,loc,'.mat']);
    load([indir,'/doxs',simlab,loc,'.mat']);
%    load([indir,'/dox2',simlab,loc,'.mat']);
%    load([indir,'/dnit2',simlab,loc,'.mat']);
%    load([indir,'/dox',simlab,loc,'.mat']);
end
[lt,lrho,lz]=size(velx);


%CREATE A SEQUENCE OF BINBARY OUTPUT FILES THAT CONTAIN A FRAME OF DATA EACH
%system(['rm -rf ',outdir,'/*.dat'])
filename=[outdir,'simsize.dat']
fid=fopen(filename,'w');
fwrite(fid,lrho,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);


ymd=ymd0;
UTsec=UTsec0;
for it=1:lt
    velxnow=squeeze(velx(it,:,:,:));     %note that these are assumed to be organized as t,x,y,z - the fortran code wants z,x,y
    velxnow=permute(velxnow,[3,1,2]);

    velznow=squeeze(velz(it,:,:,:));
    velznow=permute(velznow,[3,1,2]);

    tempnow=squeeze(temp(it,:,:,:));
    tempnow=permute(tempnow,[3,1,2]);

    dox2snow=squeeze(dox2s(it,:,:,:));
    dox2snow=permute(dox2snow,[3,1,2]);

    dnit2snow=squeeze(dnit2s(it,:,:,:));
    dnit2snow=permute(dnit2snow,[3,1,2]);

    doxsnow=squeeze(doxs(it,:,:,:));
    doxsnow=permute(doxsnow,[3,1,2]);

    filename=datelab(ymd,UTsec);
    filename=[outdir,filename,'.dat']
    fid=fopen(filename,'w');
    fwrite(fid,doxsnow,'real*8');
    fwrite(fid,dnit2snow,'real*8');
    fwrite(fid,dox2snow,'real*8');
    fwrite(fid,velxnow,'real*8');
    fwrite(fid,velznow,'real*8');
    fwrite(fid,tempnow,'real*8');
    fclose(fid);

    [ymd,UTsec]=dateinc(dtneu,ymd,UTsec);
end

