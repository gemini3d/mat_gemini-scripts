%% FIX THE PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis/plotfunctions'])
addpath([gemini_root, filesep, 'vis'])
addpath([gemini_root, filesep, 'setup'])


%% DATA LOCATIONS (THE OUTPUT OF GEMINI SIMULATION)
direc='~/Downloads/ARCS_angle_decimate/';
UTsec=27300;
ymd=[2017,3,2];


%% LOAD DATA
[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts]=loadframe(direc,ymd,UTsec);


%% CONVERT FLOWS INTO ELECTRIC FIELDS
[v,E]=Efield(xg,v2,v3);                              %Electric field and drift vectors;
E2=E(:,:,:,2);
E3=E(:,:,:,3);


%% GRID DATA
[alti,mloni,mlati,~]=model2magcoords(xg,J1);    %this grid is needed to do interpolation of precipitation inputs
[zi,xi,yi,J1i]=model2magUENcoords(xg,J1);
[zi,xi,yi,E2i]=model2magUENcoords(xg,E2);
[zi,xi,yi,E3i]=model2magUENcoords(xg,E3);
J1i=squeeze(J1i(end,:,:));
E2i=squeeze(E2i(end,:,:));
E3i=squeeze(E3i(end,:,:));


%% LOAD THE PRECIPITATION INPUT FILE
load([direc,'/inputs/ARCS_particles/particles.mat']);


%% INTERPOLATE THE PARTICLE INPUTS ONTO GRIDDED DATA LATTICE
[MLONI,MLATI]=meshgrid(mloni,mlati);
Qi=interp2(mlon,mlat,Qit(:,:,end),MLONI,MLATI);
E0i=interp2(mlon,mlat,E0it(:,:,end),MLONI,MLATI);


%% CREATE A DATASET
outfile='~/electro_data.mat';
save(outfile,'Qi','E0i','J1i','E2i','E3i','xi','yi');

