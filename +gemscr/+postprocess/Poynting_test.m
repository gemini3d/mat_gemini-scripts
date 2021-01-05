% Compute the Poynting flux from a single frame and compare it against
% dissipation
run("~/Projects/mat_gemini/setup.m")
import gemscr.postprocess.*;

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;

% read in grid
xg=gemini3d.read.grid(direc);

% read in plasma
TOI=datetime([ymd,0,0,UTsec]);
datplasma=gemini3d.read.frame(direc,"time",TOI);

% read in magnetic field, reorganize to use with MATLAB built-in
datmag=gemini3d.read.magframe(direc,"gridsize",[1,256,256],"time",TOI);
B=cat(4,datmag.Br,datmag.Btheta,datmag.Bphi);     % organized as:  up, south, east

% Compute electric fields from velocities
[v,Emod]=gemscr.postprocess.Efield(xg,datplasma.v2,datplasma.v3);

% Rotate electric fields into geomagnetic spherical coordinates
Er=dot(Emod,xg.er,4);
Etheta=dot(Emod,xg.etheta,4);
Ephi=dot(Emod,xg.ephi,4);

% Grid electric fields onto the grid used for magnetic field computations
lalt=numel(datmag.r); llon=numel(datmag.mlon); llat=numel(datmag.mlat);
altlims=[min(datmag.r),max(datmag.r)];
mlonlims=[min(datmag.mlon),max(datmag.mlon)];
mlatlims=[min(datmag.mlat),max(datmag.mlat)];
[alti,mloni,mlati,Eri]=model2magcoords(xg,Er,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ethetai]=model2magcoords(xg,Er,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ephii]=model2magcoords(xg,Er,lalt,llon,llat,altlims,mlonlims,mlatlims);

% Group electric field components together so built-in fns. can be used
E=cat(4,Eri,Ethetai,Ephii);

% Compute the Poynting flux
mu0=4*pi*1e-7;
H=B/mu0;
S=cross(E,H,4);