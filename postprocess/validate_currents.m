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
debugdir=[direc,filesep,'debugplots'];
mkdir(debugdir);


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


%% NOW COMPARE RECONSTRUCTED (FROM CONDUCTANCES AND FIELDS) WITH ACTUAL CURRENTS AS A VALIDATION
plotfun=[];
if (flagplot)
    %choose an appropriate function handle for plotting
    plotfun = grid2plotfun(plotfun,xg);

    %make plots
    J2lim=max(abs(J2(:)));
    plotfun(ymd,UTsec,xg,J2(:,:,:),'J_2 (A/m^2)',[-J2lim,J2lim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J2model.png']);
    J2reconlim=max(abs(J2recon(:)));    
    plotfun(ymd,UTsec,xg,J2recon(:,:,:),'J_2 recon. (A/m^2)',[-J2reconlim J2reconlim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J2fromsigma.png'],'-r300');
    
    J3lim=max(abs(J3(:)));
    plotfun(ymd,UTsec,xg,J3(:,:,:),'J_3 (A/m^2)',[-J3lim J3lim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J3model.png']);
    J3reconlim=max(abs(J3recon(:)));        
    plotfun(ymd,UTsec,xg,J3recon(:,:,:),'J_3 recon. (A/m^2)',[-J3reconlim J3reconlim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J3fromsigma.png'],'-r300');
end %if


%% GET JP AND JH DIRECTION FROM MODEL OUTPUT CURRENTS AND ELECTRIC FIELDS
[JP,JH,Jfac]=current_decompose(xg,v2,v3,J1,J2,J3);
J2recon2=JP(:,:,:,2)+JH(:,:,:,2);   %reconstruct J2 as a check...
J3recon2=JP(:,:,:,3)+JH(:,:,:,3);


%% COMPARE RECONSTRUCTED (FROM JP/JH) WITH ACTUAL CURRENTS AS A VALIDATION
plotfun=[];
if (flagplot)
    %choose an appropriate function handle for plotting
    plotfun = grid2plotfun(plotfun,xg);

    %make plots
    %J2lim=max(abs(J2(:)));
    %plotfun(ymd,UTsec,xg,J2(:,:,:),'J_2 (A/m^2)',[-J2lim,J2lim],[mlatsrc,mlonsrc]);
    J2reconlim=max(abs(J2recon2(:)));    
    plotfun(ymd,UTsec,xg,J2recon2(:,:,:),'J_2 recon. 2 (A/m^2)',[-J2reconlim J2reconlim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J2fromJPJH.png'],'-r300');

    %J3lim=max(abs(J3(:)));
    %plotfun(ymd,UTsec,xg,J3(:,:,:),'J_3 (A/m^2)',[-J3lim J3lim],[mlatsrc,mlonsrc]);
    J3reconlim=max(abs(J3recon2(:)));        
    plotfun(ymd,UTsec,xg,J3recon2(:,:,:),'J_3 recon. 2 (A/m^2)',[-J3reconlim J3reconlim],[mlatsrc,mlonsrc]);
    print('-dpng',[debugdir,filesep,'J3fromJPJH.png'],'-r300');
end %if


%% RECONSTRUCT FAC FROM PERP. CURRENT DIVERGENCES
x2=xg.x2(3:end-2);    %strip off ghost cells
x3=xg.x3(3:end-2);
x1=xg.x1(3:end-2);
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);  

divJ=divergence(x2,x3,x1,permute(J2,[3,2,1]),permute(J3,[3,2,1]),zeros(lx3,lx2,lx1));     %permute b/c MATLAB wants the column dim to be y-->x3
intdivJ=trapz(x1,divJ,3);
intdivJ=squeeze(intdivJ);
intdivJ=-1*intdivJ;    %we are solving for Jfac at the top of the domain (z positive "up") so it's -integral of div...
if(flagplot)
    figure;
    subplot(122);
    imagesc(x2/1e3,x3/1e3,intdivJ);
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \int \nabla \cdot J_\perp')
    colorbar;
    
    subplot(121);
    imagesc(x2/1e3,x3/1e3,squeeze(Jfac(end,:,:,1))');     %transpose again to deal with MATLAB y expectations
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from model');
    colorbar;
    print('-dpng',[debugdir,filesep,'Jparcomparison.png'],'-r300');
end %if


%% CREATE A .MAT FILE WITH THE DEBUG INFO
save([debugdir,filesep,'currents_debug.mat'],'JP','JH','Jfac','v','E','SIGP','SIGH','x1','x2','x3');


%% COMPUTE VARIOUS TERMS OF THE CURRENT CONTINUITY EQUATION
divE=divergence(x2,x3,squeeze(E2(end,:,:))',squeeze(E3(end,:,:))');     %all of the transposing in what follow is just a way for me to deal with matlab's x vs. y expectations in terms of ordering of indices
divE=divE';
JdivE=-1*(SIGP.*divE);

[gradSIGP2,gradSIGP3]=gradient(SIGP',x2,x3);
gradSIGP2=gradSIGP2';
gradSIGP3=gradSIGP3';
JgradSIGP=-1*(gradSIGP2.*squeeze(E2(end,:,:))+gradSIGP3.*squeeze(E3(end,:,:)));

e1=cat(4,-1*ones(lx1,lx2,lx3),zeros(lx1,lx2,lx3),zeros(lx1,lx2,lx3));    %unit vector along field in curvilinear basis - opposite of the z-direction in my simulation since northern hemisphere
[gradSIGH2,gradSIGH3]=gradient(abs(SIGH'),x2,x3);                     %abs due to my wacky sign convention of positive x1 is up...
gradSIGH=cat(3,gradSIGH2',gradSIGH3');       %3rd index is components, go back to index ordering used in GEMINI
e1xE=cross(e1,E,4);                          %cross product to be taken along 4th dim of arrays
e1xE=squeeze(e1xE(end,:,:,2:3));             %should be constant along x1, just use the final cell - also only need to x2 and x3 components since field-line integrated...
JgradSIGH=-1*dot(gradSIGH,e1xE,3);


%% PLOT THE DIFFERENT CONTRIBUTIONS TO FAC
if(flagplot)
    figure;
    set(gcf,'PaperPosition',[0 0 11 6]);
    
    subplot(235);
    imagesc(x2/1e3,x3/1e3,squeeze(Jfac(end,:,:,1))');
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from model')
    colorbar; 
    cax=caxis;
    
    subplot(231);
    imagesc(x2/1e3,x3/1e3,JdivE');
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \Sigma_P \nabla \cdot E')
    caxis(cax);
    colorbar;
    
    subplot(232);
    imagesc(x2/1e3,x3/1e3,JgradSIGP');
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \nabla \Sigma_P \cdot E')
    caxis(cax);
    colorbar;
    
    subplot(233);
    imagesc(x2/1e3,x3/1e3,JgradSIGH');
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \nabla \Sigma_H \cdot (e_1 \times E)')
    caxis(cax);
    colorbar;
      
    subplot(234);
    imagesc(x2/1e3,x3/1e3,(JdivE+JgradSIGP+JgradSIGH)');
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from sum of sources')
    caxis(cax);
    colorbar;    
        
    print('-dpng',[debugdir,filesep,'Jpardecomp.png'],'-r300');
end %if