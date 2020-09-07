% This script loads a grid from a file and plots the resolution of the grid
% in a physical coordinate system.

%% Load the grid of interest (user needs to tweak locations)
direc='~/simulations/ESF_noise_highres/'
cfg=gemini3d.read_config(direc);
xg=gemini3d.readgrid(direc);


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
gemini3d.vis.plotfunctions.plot3D_curv_frames_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl1.fig');

parm=log10(dl2/1e3);
parmlbl='x_2 grid spacing (log_{10} km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.vis.plotfunctions.plot3D_curv_frames_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl2.fig');

parm=log10(dl3/1e3);
parmlbl='x_3 grid spacing (log_{10} km)';
caxlims=[min(parm(:)),max(parm(:))];
gemini3d.vis.plotfunctions.plot3D_curv_frames_long(datetime([ymd,0,0,UTsec]),xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl3.fig');
