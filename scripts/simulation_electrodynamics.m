import gemini3d.grid.model2magUENcoords
%% DATA LOCATIONS (THE OUTPUT OF GEMINI SIMULATION)
direc='~/Downloads/ARCS_angle_decimate/';
time = datetime(2017,3,2) + seconds(27300);

%% LOAD DATA
dat = gemini3d.read.frame(direc, time=time);


%% CONVERT FLOWS INTO ELECTRIC FIELDS
[v,E]=Efield(xg,v2,v3);                              %Electric field and drift vectors;
E2=E(:,:,:,2);
E3=E(:,:,:,3);


%% GRID DATA
[~,alti,mloni,mlati] = gemini3d.grid.model2magcoords(xg,J1);    %this grid is needed to do interpolation of precipitation inputs
J1i = model2magUENcoords(xg,J1);
E2i = model2magUENcoords(xg,E2);
[E3i, zi,xi,yi] = model2magUENcoords(xg,E3);
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
