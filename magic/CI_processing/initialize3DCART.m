clear all
close all
clc

import stdlib.hdf5nc.h5save

% folder to save GEMINI inputs
outdir='../acoustic3D_cartesian_neutrals_GEMINI_h5correction/';

% Specify initial time and timestep of data
MaxFrames = 361; % Number of Frames
Frame=0; % Frame to start

% Initial time of GEMINI simulation and time step of neutral inputs
ymd0=[2011,3,11];
UTsec0=35100.0+5*Frame;
dtneu=5;

% Specify input data
lt=361; % number of time steps
lx1=80; % number of points in zonal direction
lx2=90; % number of points in meridional direction
lx3=100; % number of points in vertical direction

% Save grid structure file
filename=[outdir,'simsize.h5'];
disp("write " + filename)
if isfile(filename), delete(filename), end
h5save(filename, '/lx1', lx1, "type", "int32")
h5save(filename, '/lx2', lx2, "type", "int32")
h5save(filename, '/lx3', lx3, "type", "int32")
freal = 'float32';

ymd=ymd0;
UTsec=UTsec0;

% Read MAGIC outputs and save GEMINI neutral inputs
readandoutput3DCART
