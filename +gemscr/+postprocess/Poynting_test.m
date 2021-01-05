% Compute the Poynting flux from a single frame and compare it against
% dissipation
run("~/Projects/mat_gemini/setup.m")

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;

% read in plasma
TOI=datetime([ymd,0,0,UTsec]);
datplasma=gemini3d.read.frame(direc,"time",TOI);

% read in magnetic field
datmag=gemini3d.read.magframe(direc,"gridsize",[1,256,256],"time",TOI);

% Compute electric fields from velocities
[v,E]=gemscr.postprocess.Efield(xg,v2,v3);

% Convert electric fields into 