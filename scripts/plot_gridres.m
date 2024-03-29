% This script loads a grid from a file and plots the resolution of the grid
% in a physical coordinate system.

%% Load the grid of interest (user needs to tweak locations)
% direc='~/simulations/ESF_noise_highres/'
% cfg=gemini3d.read.config(direc);
% xg=gemini3d.read.grid(direc);


%% Create a new grid
%{
dtheta=20;
dphi=27.5;
lp=256;
lq=256;
lphi=210;
altmin=80e3;
%glat=39;
glat=-39;
glon=262.51;
gridflag=1;
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% p.dtheta=16.8;
% p.dphi=11;
% p.lp=216;
% p.lq=128;
% p.lphi=60;
% p.altmin=80e3;
% p.glat=-30.9;
% p.glon=287;
% p.gridflag=1;

%xg=gemscr.grid.tilted_dipole3d_varx2_oneside(p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%p.glat = 52;
%p.glon = 143.4;
%p.dtheta = 27;
%p.dphi = 356.2887;
%p.altmin = 80e3;
%p.lp = 264;
%p.lq = 384;
%p.lphi = 24;
%p.gridflag = 1;
%
%xg=gemini3d.grid.tilted_dipole(p)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Perkins
p.dtheta=25;
p.dphi=35;
p.lp=256;
p.lq=192;
p.lphi=32;
p.altmin=80e3;
p.glat=39;
p.glon=262.51;
p.gridflag=0;

xg=gemscr.grid.tilted_dipole3d_varx2_oneside(p);
cfg=struct.empty;
cfg(1).sourcemlat=[];


%% Compute the resolutions
[dl1,dl2,dl3]= gemscr.setup.gridres(xg);


%% Set some parameters that the plotting function needs but that don't matter
ymd=[1981,05,22];
UTsec=4*3600+21*60;
saveplot_fmt={};
if isempty(cfg.sourcemlat)
    mlatsrc=mean(90-xg.theta(:)*180/pi);
    mlonsrc=mean(xg.phi(:)*180/pi);
else
    mlatsrc=cfg.sourcemlat;
    mlonsrc=cfs.sourcemlon;
end %if
% [theta,phi]= gemini3d.geog2geomag(38.96,360-94.088);    %oh geez, hardcoded location...
% mlatsrc=90-theta*180/pi;
% mlonsrc=phi*180/pi;
sourceloc=[mlatsrc,mlonsrc];


%% Plot the grid resolutions
parm=log10(dl1/1e3);
parmlbl='x_1 grid spacing (log_{10} km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.plot.curv3d_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl1.fig');

parm=log10(dl2/1e3);
parmlbl='x_2 grid spacing (log_{10} km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.plot.curv3d_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl2.fig');

parm=log10(dl3/1e3);
parmlbl='x_3 grid spacing (log_{10} km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.plot.curv3d_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl3.fig');
