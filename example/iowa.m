% https://github.com/gemini3d/mat_gemini/issues/28

p.dtheta=30.5;
p.dphi=70;
p.lpp=432;
p.lqp=360;
p.lphip=360;
p.altmin=80e3;
p.glat=-40;
p.glon=360-93;
p.gridflag=0; % 1 - works
p.plotflag=false;
p.flagsource=0;
p.iscurv=true;

%gemscr.grid.tilted_dipole(p)
gemscr.grid.makegrid_tilteddipole_varx2_oneside_3D(p)
