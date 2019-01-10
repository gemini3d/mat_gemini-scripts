%% FIX THE PATHS
cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../GEMINI'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis/plotfunctions'])
addpath([gemini_root, filesep, 'vis'])
addpath([gemini_root, filesep, 'setup'])


%% SIMULATIONS LOCAITONS
flagplot=1;
simname='isinglass_clayton1/'
basedir=[gemini_root,'/../simulations/'];
direc=[basedir,simname];


%% READ IN DATA - need to add the f10.7
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc,activ]=readconfig([direc,filesep,'inputs/config.ini']);


%% TIME OF INTEREST
UTsec=25496;
ymd=[2017,3,2];


%% LOAD THE SIMULATION DATA CLOSEST TO THE REQUESTED TIME
[ne,mlatsrc,mlonsrc,xg,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop,ns,vs1,Ts] = loadframe(direc,ymd,UTsec,ymd0,UTsec0,tdur,dtout,flagoutput,mloc);
[sigP,sigH,sig0,SIGP,SIGH]=conductivity_reconstruct(xg,ymd,UTsec,activ,ne,Ti,Te,v1);


%% THIS COMPUTES THE CURRENTS DIRECTLY FROM THE ELECTRIC FIELDS AND CONDUCTIVITES (AS OPPOSED TO DIRECT MODEL OUTPUT)
[v,E]=Efield(xg,v2,v3);                              %Electric field and drift vectors;
E2=E(:,:,:,2);
E3=E(:,:,:,3);
J2recon=sigP.*E2-sigH.*E3;    %have a sign inconsistency here...
J3recon=sigP.*E3+sigH.*E2;


%% NOW COMPARE RECONSTRUCTED WITH ACTUAL CURRENTS AS A VALIDATION
plotfun=[];
if (flagplot)
    %choose an appropriate function handle for plotting
    plotfun = grid2plotfun(plotfun,xg);

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


