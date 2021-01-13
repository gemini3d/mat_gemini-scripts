
%MAKE A GRID
% dtheta=25;
% dphi=45;
% lp=35;
% lq=350;
% lphi=35;
% altmin=80e3;
% glat=35;
% glon=270;
% gridflag=0;

dtheta=2;
dphi=5;
lp=110;
lq=200;
lphi=80;
altmin=80e3;
glat=65;    %high-latitude
glon=270;
gridflag=0;

xg= gemini3d.grid.tilted_dipole3d(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);


%GENERATE INITIAL CONDITIONS
cfg.times = datetime(2016, 9, 15);
cfg.activ=[100,100,10];
cfg.nmf=5e11;
cfg.nme=2e11;
[ns,Ts,vsx1] = gemini3d.model.eqICs(cfg, xg);    %note that this actually calls msis_matlab - should be rewritten to includ the neutral module form the fortran code!!!


%WRITE THE GRID AND INITIAL CONDITIONS
fprintf('Writing grid to file...\n');
gemini3d.write.grid(xg,'curvtest');

gemini3d.write.state('curvtest',time,ns,Ts,vsx1);
