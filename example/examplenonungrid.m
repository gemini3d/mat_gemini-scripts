% This example demonstrates problem with usual EQ full dipole grid
% interpolation to PERTURB nonuniform grid when border values of grid
% are not properly interpolated

%% 1. Kumamoto EQ simulation
p.dtheta=5.5;
p.dphi=8.5;
p.lp=432;
p.lq=360;
p.lphi=360;
p.altmin=80e3;
p.glat=37.0;
p.glon=131.2;
p.gridflag=1; 
p.flagsource=1;
p.iscurv=true;

% It was generated with usual full dipole grid creator:
% xg=gemini3d.grid.tilted_dipole(p);

% the grid and initial conditions from which I want to restart
% are in the folder ./kumamoto/eq

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% THE GEOMAGNETIC NORTH POLE WAS CHANGED HERE FOR YEAR 2015
% BE SURE TO ADJUST PRIOR TO RUNNING
%thetan = deg2rad(9.6869e+00);
%phin = deg2rad(360-7.2613e+01);
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

load('./kumamoto/eq/xg.mat') % load EQ grid xgin
load('./kumamoto/eq/dat.mat') % load IC which I want to interpolate

%% 2. Kumamoto PERTURB
p.dtheta=5.4; % slightly decreased than EQ
p.dphi=8.4; % slightly decreased than EQ
p.lp=600;
p.lq=600;
p.lphi=600;
p.altmin=80e3;
p.glat=37.0;
p.glon=131.2;
p.gridflag=1;
p.flagsource=1;
p.iscurv=true;

% put this nonuniform grid script to ./gemini3d/grid
% This is large grid of 612x612x600, so you may adjust coefficients a bit
% if needed
lims=double([xgin.x1(3)+0.001,xgin.x1(end-2)-0.001, ...
    xgin.x2(3)+0.001,xgin.x2(end-2)-0.001, ...
    xgin.x3(3)+0.001,xgin.x3(end-2)-0.001]);    % this forces the native coordinate limits to avoid out-of-range interpolation from EQ simulation
xg=makegrid_tilteddipole_varx2_oneside_3Dkumamoto(p.dtheta,p.dphi,p.lp,p.lq,p.lphi, ...
    p.altmin,p.glat,p.glon,p.gridflag, ...
    lims);

%% 3. Now interpolate EQ to PERTURB

ic_interp = gemini3d.model.resample(xgin, dat, xg);

%% 4. Check NaN values

mustBeFinite(ic_interp.ns(:,:,:,7))
mustBeNonnegative(ic_interp.ns(:,:,:,7))