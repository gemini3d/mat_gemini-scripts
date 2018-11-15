cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd, filesep, '../../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'setup/gridgen'])
addpath([gemini_root, filesep, 'setup/'])
addpath([gemini_root, filesep, 'vis'])


%MOORE, OK GRID (FULL)
dtheta=25;
dphi=35;
lp=125;
lq=200;
lphi=40;
altmin=80e3;
glat=39;
glon=262.51;
gridflag=0;


%MATLAB GRID GENERATION
if (~exist('xg'))
  xg=makegrid_tilteddipole_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);
end


eqdir='../../../simulations/mooreOK3D_eq/';
distdir='../../../simulations/mooreOK3D/';
simID='mooreOK3D';
[nsi,vs1i,Tsi,xgin,ns,vs1,Ts]=eq2dist(eqdir,distdir,simID,xg);
