%% FIX THE PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis/plotfunctions'])


%% SIMULATIONS LOCAITONS
simname='isinglass_clayton1/'
flagplot=1;
basedir=[gemini_root,'/../simulations/'];
direc=[basedir,simname];


%% NEED TO READ INPUT FILE TO GET DURATION OF SIMULATION AND START TIME
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=readconfig([direc,filesep,'inputs/config.ini']);


%% TIME OF INTEREST
UTsec=25496;
ymd=[2017,3,2];


%% LOAD THE SIMULATION DATA CLOSEST TO THE REQUESTED TIME
[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec,ymd0,UTsec0,tdur,dtout,flagoutput,mloc);


%% RESOLVE CURRENTS INTO PEDERSEN AND HALL COMPONENTS
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
vperp2=squeeze(v2(floor(lx1/2),:,:));
vperp2=repmat(vperp2,[1,1,lx1]);
vperp3=squeeze(v3(floor(lx1/2),:,:));
vperp3=repmat(vperp3,[1,1,lx1]);
v=cat(4,vperp2,vperp3,zeros(lx2,lx3,lx1));           %create a vector for the ExB drift in the curvilinear basis (i.e. e1,e2,e3 basis vectors), permuted as 231 so that the parallel direction is the third dimension
magvperp=sqrt(sum(v.^2,4));
evperp=v./repmat(magvperp,[1,1,1,3]);                %unit vector for ExB drift (curv. basis)

e1curv=cat(4,zeros(lx2,lx3,lx1),zeros(lx2,lx3,lx1),ones(lx2,lx3,lx1));                         %unit vector (x1-direction) in the curvilinear basis
B=cat(4,zeros(lx2,lx3,lx1),zeros(lx2,lx3,lx1),ones(lx2,lx3,lx1).*permute(xg.Bmag,[2,3,1]));
E=cross(-1*v,B,4);                                                                             %electric field
magE=sqrt(sum(E.^2,4));
eE=E./repmat(magE,[1,1,1,3]);                                                                  %unit vector in the direction of the electric field

J=cat(4,permute(J2,[2,3,1]),permute(J3,[2,3,1]),permute(J1,[2,3,1]));     %current density vector, permuted as 231
JH=dot(J,-1*evperp,4);                                                    %projection of current in -evperp direction
JHvec=-1*evperp.*repmat(JH,[1,1,1,3]);
JP=dot(J,eE,4);                                                           %project of current in eE unit vector direction (direction of electric field)
JPvec=eE.*repmat(JP,[1,1,1,3]);
Jfac=cat(4,zeros(lx2,lx3,lx1),zeros(lx2,lx3,lx1),permute(J1,[2,3,1]));    %field aligned current vector


%% PERMUTE THE P,H,FAC CURRENT BACK TO WHAT THE MODEL NORMALLY USES
JH=permute(JHvec,[3,1,2,4]);
JP=permute(JPvec,[3,1,2,4]);
Jfac=permute(Jfac,[3,1,2,4]);


%% CREATE PLOTS, IF WANTED
if ~exist([direc,'/JPplots'],'dir')
   mkdir([direc,'/JPplots']);
   mkdir([direc,'/JHplots']);
end

plotfun=[];
if (flagplot)
    %choose an appropriate function handle for plotting
    plotfun = grid2plotfun(plotfun,xg);

    %make plots
    JPplot=sqrt(sum(JPvec.^2,4));
    JPplot=ipermute(JPplot,[2,3,1]);
    plotfun(ymd,UTsec,xg,log10(JPplot(:,:,:)),'log_{10} |J_P| (A/m^2)',[-7 -4],[mlatsrc,mlonsrc]);
    print('-dpng',[direc,'/JPplots/',filename,'.png'],'-r300');

    JHplot=sqrt(sum(JHvec.^2,4));
    JHplot=ipermute(JHplot,[2,3,1]);
    plotfun(ymd,UTsec,xg,log10(JHplot(:,:,:)),'|J_H| (log_{10} A/m^2)',[-7 -4],[mlatsrc,mlonsrc]);
    print('-dpng',[direc,'/JHplots/',filename,'.png'],'-r300');
end %if
