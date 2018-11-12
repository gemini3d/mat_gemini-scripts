cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd, filesep, '../../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'setup/gridgen'])
addpath([gemini_root, filesep, 'setup'])
addpath([gemini_root, filesep, 'vis'])


%LOWRES 2D EXAMPLE FOR TESTING
xdist=200e3;    %eastward distance
ydist=600e3;    %northward distance
lxp=80;
lyp=1;
glat=67.11;
glon=212.95;
gridflag=0;
I=90;


%RUN THE GRID GENERATION CODE
if (~exist('xg'))
%    xg=makegrid_tilteddipole_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);   
%    xg=makegrid_tilteddipole_nonuniform_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);   
%    xg=makegrid_tilteddipole_nonuniform_oneside_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);
%  xg=makegrid_tilteddipole_3D(dtheta,dphi,lp,lq,lphi,altmin,glat,glon,gridflag);
  xg=makegrid_cart_3D(xdist,lxp,ydist,lyp,I,glat,glon);
%  xg=makegrid_cart_3D_lowresx1(xdist,lxp,ydist,lyp,I,glat,glon);
end
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);


%IDENTIFICATION FOR THE NEW SIMULATION THAT IS TO BE DONE
simid='2DSTEVE'


%ALTERNATIVELY WE MAY WANT TO READ IN AN EXISTING OUTPUT FILE AND DO SOME INTERPOLATION ONTO A NEW GRID
fprintf('Reading in source file...\n');
ID='../../../simulations/2Dtest_eq/'


%READ IN THE SIMULATION INFORMATION
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=readconfig([ID,'/inputs/config.ini']);
xgin=readgrid([ID,'/inputs/']);
direc=ID;


%FIND THE DATE OF THE END FRAEM OF THE SIMULATION (PRESUMABLY THIS WILL BE THE STARTING POITN FOR ANOTEHR)
[ymdend,UTsecend]=dateinc(tdur,ymd0,UTsec0);


%LOAD THE FRAME
%[ne,v1,Ti,Te,J1,v2,v3,J2,J3,mlatsrc,mlonsrc,filename,Phitop,ns,vs1,Ts] = loadframe(direc,UTsecend,ymdend,UTsec0,ymd0,mloc,xgin);
[ne,mlatsrc,mlonsrc,xgin,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymdend,UTsecend,ymd0,UTsec0,tdur,dtout,flagoutput,mloc,xgin);
lsp=size(ns,4);


%DO THE INTERPOLATION
[nsi,vs1i,Tsi]=model_resample(xgin,ns,vs1,Ts,xg);


%WRITE OUT THE GRID
outdir='../../../simulations/input/2DSTEVE/';
if (~(exist(outdir,'dir')==7))
  mkdir(outdir);
end
writegrid(xg,outdir);    %just put it in pwd for now
dmy=[ymdend(3),ymdend(2),ymdend(1)];
writedata(dmy,UTsecend,nsi,vs1i,Tsi,outdir,simid);

