%% FIX THE PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis/plotfunctions'])
addpath([gemini_root, filesep, 'vis'])
addpath([gemini_root, filesep, 'setup'])


%% SIMULATIONS LOCAITONS
simname='isinglass_clayton1/'
flagplot=1;
basedir=[gemini_root,'/../simulations/'];
direc=[basedir,simname];


%% READ IN DATA
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=readconfig([direc,filesep,'inputs/config.ini']);


%% TIME OF INTEREST
UTsec=25496;
ymd=[2017,3,2];


%% LOAD THE SIMULATION DATA CLOSEST TO THE REQUESTED TIME
[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec,ymd0,UTsec0,tdur,dtout,flagoutput,mloc);


%% GET THE NEUTRAL ATMOSPHERE NEEDED FOR COLLISIONS, ETC.
natm=msis_matlab3D(xg,UT,dmy,activ);


%% NEED THE F10.7 AS WELL...
qs=[1,1,1,1,1,1,-1]*1.6e-19;
ms=[16,30,28,32,14,1,]*1.67e-27;


%% DEFINE A COMPOSITION OF THE PLASMA - THIS ACTUALLY DOESN'T MUCH IMPACT THE CONDUCTIVITY
p=tanh((xg.alt-220e3)/20e3);
ns=zeros(xg.lx(1),xg.lx(2),xg.lx(3),7);
ns(:,:,:,1)=p.*ne;
nmolc=(1-p).*ne;
ns(:,:,:,2)=1/3*nmolc;
ns(:,:,:,3)=1/3*nmolc;
ns(:,:,:,4)=1/3*nmolc;

Ts(:,:,:,1:6)=Ti;
Ts(:,:,:,7)=Te;
vs1=repmat(v1,[1 1 1 7]);


%% NEED TO CREATE A FULL IONOSPHERIC OUT OF A PARTIAL CALCULATION
[nusn,nus,nusj,nuss,Phisj,Psisj]=collisions3D(natm,Ts,ns,vs1,ms);
B=abs(xg.Bmag);                     %need to check whether magnitude is okay here...
[muP,muH,mu0,sigP,sigH,sig0]=conductivities3D(nus,nusj,ns,ms,qs,B);


