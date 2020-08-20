% This script load a grid from a file and plots the resolution of the grid
% in a physics coordinate system.

%% Load the grid of interest (user needs to tweak locations)
direc='~/zettergmdata/simulations/iowa3D_hemis_medres2/'
xg= gemini3d.readgrid(direc);

%% Compute the resolutions
[dl1,dl2,dl3]= gemscr.setup.gridres(xg);


%% Set some parameters that the plotting function needs but that don't matter
ymd=[1981,05,22];
UTsec=4*3600+21*60;
saveplot_fmt={};
[theta,phi]= gemini3d.geog2geomag(38.96,360-94.088);
mlatsrc=90-theta*180/pi;
mlonsrc=phi*180/pi;
sourceloc=[mlatsrc,mlonsrc];


%% Plot the grid resolutions
parm=log10(dl1/1e3);
parmlbl='x_1 grid spacing (km)';
caxlims=[min(parm(:)),max(parm(:))];
h=  gemini3d.vis.plotfunctions.plot3D_curv_frames_long(ymd,UTsec,xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl1.fig');

parm=log10(dl2/1e3);
parmlbl='x_2 grid spacing (km)';
caxlims=[min(parm(:)),max(parm(:))];
h=  gemini3d.vis.plotfunctions.plot3D_curv_frames_long(ymd,UTsec,xg,parm,parmlbl,caxlims,sourceloc);
savefig('~/dl2.fig');
