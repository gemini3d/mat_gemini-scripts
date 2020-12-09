import gemini3d.plot.*

%% SIMULATIONS LOCAITONS
simname='isinglass_clayton1/'
flagplot=1;
basedir='~/simulations';
direc= fullfile(basedir,simname);


%% NEED TO READ INPUT FILE TO GET DURATION OF SIMULATION AND START TIME
cfg = gemini3d.readconfig(direc);


%% TIME OF INTEREST
time = datetime(2017,3,2) + seconds(25496);


%% LOAD THE SIMULATION DATA CLOSEST TO THE REQUESTED TIME
dat = gemini3d.read.frame(direc, "time", time);


%% DECOMPOSE INTO PEDERSEN, HALL, AND FAC COMPONENTS
[JP,JH,Jfac]= gemscr.postprocess.current_decompose(xg, dat);


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
