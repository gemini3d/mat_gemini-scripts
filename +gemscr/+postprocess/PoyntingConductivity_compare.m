% Compute the Poynting flux from a single frame and compare it against
% dissipation of ionospheric electromagnetic energy.  

% load mat_gemini
run("~/Projects/mat_gemini/setup.m")

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;
TOI=datetime([ymd,0,0,UTsec]);

% Load/recompute auxiliary information
% call the Poynting flux utility function
cfg = gemini3d.read.config(direc);    % config file
[Ei,B,S,mlon,mlat,datmag,datplasma,xg]=gemscr.postprocess.Poynting_calc(direc,TOI);    % Poynting flux, electric, and magnetic fields
[sigP,sigH,sig0,SIGP,SIGH,incap,INCAP] = gemscr.postprocess.conductivity_reconstruct(xg,TOI,cfg,datplasma);   % Conductivities on the simulation grid

% Get the electric fields 
[v,E]=gemscr.postprocess.Efield(xg,datplasma.v2,datplasma.v3);   % fields, etc. on the simulation grid

% Compute the Joule dissipation
E2slice=squeeze(E(end,:,:,2)); E3slice=squeeze(E(end,:,:,3));
ohmicdissipation=SIGP.*(E2slice.^2+E3slice.^2);

% Interpolate the energy dissipation rate onto a magnetic coordinate system
% for plotting
[alti,mloni,mlati,ohmici]=model2magcoords(xg,ohmicdissipation,lalt,llon,llat,altlims,mlonlims,mlatlims);
