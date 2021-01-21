
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

p.dtheta=2;
p.dphi=5;
p.lp=110;
p.lq=200;
p.lphi=80;
p.altmin=80e3;
p.glat=65;    %high-latitude
p.glon=270;
p.gridflag=0;
p.outdir = '~/simulations/ICs';

xg = gemini3d.grid.tilted_dipole3d(p);


%GENERATE INITIAL CONDITIONS
p.times = datetime(2016, 9, 15);
p.activ=[100,100,10];
p.nmf=5e11;
p.nme=2e11;

dat = gemini3d.model.eqICs(p, xg);

%WRITE THE GRID AND INITIAL CONDITIONS
gemini3d.write.grid(p, xg)

gemini3d.write.state(p.outdir, dat)
