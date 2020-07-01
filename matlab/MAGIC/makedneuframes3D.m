clear all
close all
clc
% cwd = fileparts(mfilename('fullpath'));
% gemini_root = [cwd, filesep, '../../GEMINI/'];
% addpath([gemini_root, filesep, 'script_utils'])
addpath ./script_utils/;
%% LOCATION OF INPUT DATA
%indir='~/zettergmdata/simulations.MAGIC/okx2/old/'
%indir='~/neutral_sims/chile06052017/'
%indir='~/neutral_sims/2016mooreOK/'
%indir='/media/data/chile2015_0.5MSIS/'
%indir='/media/data/nepal/'
%loc='';
%simlab='chile'
%simlab='nepal'
%simlab='strong'
%simlab='';


%% LOCATION OF OUTPUT DATA
%outdir=['~/simulations/mooreOK_neutrals/'];
%outdir=['~/simulations/chile2015_0.5_neutrals/'];
%outdir='~/simulations/nepal2015_neutrals/'
outdir='./datap/'
%mkdir([outdir]);


%% NEED TO SPECIFY DATA FOR GEMINI
%ymd0=[2015,09,16];
%UTsec0=82473;
%dtneu=4;

ymd0=[2011,03,11];
UTsec0=20783;
dtneu=4;

%ymd0=[2015,4,24];
%UTsec0=22285;
%dtneu=4;

%TOHOKU EXAMPLE
%ymd0=[2011,3,11];
%UTsec0=20783;
%dtneu=2;


%% LOAD THE DATA FROM AN INPUT MAGIC SIMULATION
% if ~exist('velx')
%     load([indir,'/velx',simlab,loc,'.mat']);
%     load([indir,'/vely',simlab,loc,'.mat']);
%     load([indir,'/velz',simlab,loc,'.mat']);
%     load([indir,'/temp',simlab,loc,'.mat']);
%     load([indir,'/dox2s',simlab,loc,'.mat']);
%     load([indir,'/dnit2s',simlab,loc,'.mat']);
%     load([indir,'/doxs',simlab,loc,'.mat']);
% %    load([indir,'/dox2',simlab,loc,'.mat']);
% %    load([indir,'/dnit2',simlab,loc,'.mat']);
% %    load([indir,'/dox',simlab,loc,'.mat']);
% end
%[lt,lx,ly,lz]=[638,300,300,300];
lt=630;
lx=300;
ly=300;
lz=300;

%CREATE A SEQUENCE OF BINBARY OUTPUT FILES THAT CONTAIN A FRAME OF DATA EACH
%system(['rm -rf ',outdir,'/*.dat'])
filename=[outdir,'simsize.dat'];
fid=fopen(filename,'w');
fwrite(fid,lx,'integer*4');
fwrite(fid,ly,'integer*4');
fwrite(fid,lz,'integer*4');
fclose(fid);


ymd=ymd0;
UTsec=UTsec0;
for it=1:lt

load(strcat('velx',num2str(it-1),'.mat'),'velxfull');
load(strcat('vely',num2str(it-1),'.mat'),'velyfull');
load(strcat('velz',num2str(it-1),'.mat'),'velzfull');
load(strcat('doxs',num2str(it-1),'.mat'),'doxs');
load(strcat('dox2s',num2str(it-1),'.mat'),'dox2s');
load(strcat('dnit2s',num2str(it-1),'.mat'),'dnit2s');
load(strcat('temps',num2str(it-1),'.mat'),'temps');
%    pause



    %velxnow=squeeze(velx(:,:,:));     %note that these are assumed to be organized as t,x,y,z - the fortran code wants z,x,y
    velxfull=permute(velxfull,[3,1,2]);

    %velynow=squeeze(vely(:,:,:));
    velyfull=permute(velyfull,[3,1,2]);

    %velznow=squeeze(velz(:,:,:));
    velzfull=permute(velzfull,[3,1,2]);

    %tempnow=squeeze(temp(:,:,:));
    temps=permute(temps,[3,1,2]);

    %dox2snow=squeeze(dox2s(:,:,:));
    dox2s=permute(dox2s,[3,1,2]);

    %dnit2snow=squeeze(dnit2s(:,:,:));
    dnit2s=permute(dnit2s,[3,1,2]);

    %doxsnow=squeeze(doxs(it,:,:,:));
    doxs=permute(doxs,[3,1,2]);

    filename=datelab(ymd,UTsec);
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

    [ymd,UTsec]=dateinc(dtneu,ymd,UTsec);
end

