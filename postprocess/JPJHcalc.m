%% FIX THE PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis/plotfunctions'])
addpath([gemini_root, filesep, 'vis'])


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


%% DECOMPOSE INTO PEDERSEN, HALL, AND FAC COMPONENTS
[JP,JH,Jfac]=current_decompose(xg,v2,v3,J1,J2,J3);


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
    JPplot=sqrt(sum(JP.^2,4));
    plotfun(ymd,UTsec,xg,log10(JPplot(:,:,:)),'log_{10} |J_P| (A/m^2)',[-7 -4],[mlatsrc,mlonsrc]);
    print('-dpng',[direc,'/JPplots/',filename,'.png'],'-r300');

    JHplot=sqrt(sum(JH.^2,4));
    plotfun(ymd,UTsec,xg,log10(JHplot(:,:,:)),'|J_H| (log_{10} A/m^2)',[-7 -4],[mlatsrc,mlonsrc]);
    print('-dpng',[direc,'/JHplots/',filename,'.png'],'-r300');
end %if
