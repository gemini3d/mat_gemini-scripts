% Compute the Poynting flux from a single frame and compare it against
% dissipation
run("~/Projects/mat_gemini/setup.m")

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;
TOI=datetime([ymd,0,0,UTsec]);


% call the Poynting flux utility function
[E,B,S,mlon,mlat,datmag,datplasma]=gemscr.postprocess.Poynting_calc(direc,TOI);

% get the configuration information
cfg = gemini3d.read.config(direc);

% get the grid
xg=gemini3d.read.grid(direc);

% recompute conductivity
[sigP,sigH,sig0,SIGP,SIGH,incap,INCAP] = gemscr.postprocess.conductivity_reconstruct(xg,TOI,cfg,dat);
