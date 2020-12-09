%% SIMULATIONS LOCAITONS
%flagplot=1;
%simname='isinglass_clayton1/'
flagplot=false;
simname='KHI_Andres/';
basedir=[gemini_root,'/../simulations/'];
direc=[basedir,simname];


%% READ IN DATA - need to add the f10.7
cfg = gemini3d.read.config(direc);


%% TIME OF INTEREST
%UTsec=25496;
%ymd=[2017,3,2];

time = datetime(2014, 12, 1) + seconds(28500);

%% LOAD THE SIMULATION DATA CLOSEST TO THE REQUESTED TIME
dat = gemini3d.read.frame(direc, "time", time);
[sigP,sigH,sig0,SIGP,SIGH,incap,INCAP] = gemscr.postprocess.conductivity_reconstruct(xg,time,cfg,dat);


%% THIS COMPUTES THE CURRENTS DIRECTLY FROM THE ELECTRIC FIELDS AND CONDUCTIVITES (AS OPPOSED TO DIRECT MODEL OUTPUT)
[v,E]= gemscr.postprocess.Efield(xg, dat);                              %Electric field and drift vectors;
E2=E(:,:,:,2);
E3=E(:,:,:,3);
J2recon=sigP.*E2-sigH.*E3;    %have a sign inconsistency here...
J3recon=sigP.*E3+sigH.*E2;


%% NOW COMPARE RECONSTRUCTED WITH ACTUAL CURRENTS AS A VALIDATION
plotfun=[];
if (flagplot)
    %choose an appropriate function handle for plotting
    plotfun = gemini3d.plot.grid2plotfun(plotfun,xg);

    %make plots
    J2lim=max(abs(J2(:)));
    plotfun(ymd,UTsec,xg,J2(:,:,:),'J_2 (A/m^2)',[-J2lim,J2lim],[mlatsrc,mlonsrc]);
    J2reconlim=max(abs(J2recon(:)));
    plotfun(ymd,UTsec,xg,J2recon(:,:,:),'J_2 recon. (A/m^2)',[-J2reconlim J2reconlim],[mlatsrc,mlonsrc]);

    J3lim=max(abs(J3(:)));
    plotfun(ymd,UTsec,xg,J3(:,:,:),'J_3 (A/m^2)',[-J3lim J3lim],[mlatsrc,mlonsrc]);
    J3reconlim=max(abs(J3recon(:)));
    plotfun(ymd,UTsec,xg,J3recon(:,:,:),'J_3 recon. (A/m^2)',[-J3reconlim J3reconlim],[mlatsrc,mlonsrc]);
end %if
