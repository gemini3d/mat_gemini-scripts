%clear all
close all
clc

% folder to save GEMINI inputs
outdir='../acoustic2D_axisymmetric_neutrals_GEMINI/';

% Specify initial time and timestep of data
MaxFrames = 361; % Number of Frames
Frame=0; % Frame to start

% Initial time of GEMINI simulation and time step of neutral inputs
ymd0=[2011,3,11];
UTsec0=35100.0+5*Frame;
dtneu=5;

% Specify input data
lt=361; % number of time steps
lx1=45; % radial direction
lx2=100; % altitude

% Save grid structure file
filename=[outdir,'simsize.h5'];
disp("write " + filename)
if isfile(filename), delete(filename), end
hdf5nc.h5save(filename, '/lx1', lx1, "type", "int32") % ly
hdf5nc.h5save(filename, '/lx2', lx2, "type", "int32") % lz
freal = 'float32';
% clc
it=1;
listofproc = [];

ymd=ymd0;
UTsec=UTsec0;

% Go from frame to frame
readandoutputAXISYMMETRIC