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

divJ=divergence(x2,x3,x1,permute(J2recon,[3,2,1]),permute(J3recon,[3,2,1]),zeros(lx3,lx2,lx1));     %permute b/c MATLAB wants the column dim to be y-->x3
intdivJrecon=trapz(x1,divJ,3);
intdivJrecon=squeeze(intdivJrecon);
intdivJrecon=-1*intdivJrecon;    %we are solving for Jfac at the top of the domain (z positive "up") so it's -integral of div...

divJ=divergence(x2,x3,x1,permute(J2recon2,[3,2,1]),permute(J3recon2,[3,2,1]),zeros(lx3,lx2,lx1));     %permute b/c MATLAB wants the column dim to be y-->x3
intdivJrecon2=trapz(x1,divJ,3);
intdivJrecon2=squeeze(intdivJrecon2);
intdivJrecon2=-1*intdivJrecon2;    %we are solving for Jfac at the top of the domain (z positive "up") so it's -integral of div...

if(flagplot)
    figure;
    
    subplot(142);
    imagesc(x2/1e3,x3/1e3,intdivJ);
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \int \nabla \cdot J_\perp')
    colorbar;
    
    subplot(143);
    imagesc(x2/1e3,x3/1e3,intdivJrecon);
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \int \nabla \cdot J_\perp recon.')
    colorbar;

    subplot(144);
    imagesc(x2/1e3,x3/1e3,intdivJrecon2);
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \int \nabla \cdot J_\perp recon. 2')
    colorbar;    
    
    subplot(141);
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
gradSIGP2=gradSIGP2';                          %go back to GEMINI index ordering to avoid confusion
gradSIGP3=gradSIGP3';
JgradSIGP=-1*(gradSIGP2.*squeeze(E2(end,:,:))+gradSIGP3.*squeeze(E3(end,:,:)));

bhat=cat(4,-1*ones(lx1,lx2,lx3),zeros(lx1,lx2,lx3),zeros(lx1,lx2,lx3));    %unit vector along field in curvilinear basis - opposite of the z-direction in my simulation since northern hemisphere
[gradSIGH2,gradSIGH3]=gradient(abs(SIGH'),x2,x3);                     %abs due to my wacky sign convention of positive x1 is up...
gradSIGH=cat(3,gradSIGH2',gradSIGH3');       %3rd index is components, go back to index ordering used in GEMINI with tranposes...
bhatxE=cross(bhat,E,4);                          %cross product to be taken along 4th dim of arrays
bhatxE=squeeze(bhatxE(end,:,:,2:3));             %should be constant along x1, just use the final cell - also only need to x2 and x3 components since field-line integrated...
JgradSIGH=-1*dot(gradSIGH,bhatxE,3);


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
    title('J_{||} from \nabla \Sigma_H \cdot (b \times E)')
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


%% COMPARE DIFFERENT WAYS OF COMPUTING DIV JH
JH2=JH(:,:,:,2);
JH3=JH(:,:,:,3);
divJH=divergence(x2,x3,x1,permute(JH2,[3,2,1]),permute(JH3,[3,2,1]),zeros(lx3,lx2,lx1));
intdivJH=trapz(x1,divJH,3);
intdivJH=squeeze(intdivJH);
intdivJH=-1*intdivJH;    %we are solving for Jfac at the top of the domain (z positive "up") so it's -integral of div...

JH2=SIGH.*squeeze(E3(end,:,:));    %abs to assume Hall current positive definite
JH3=-SIGH.*squeeze(E2(end,:,:));
divperpSIGHE=divergence(x2,x3,JH2',JH3');
divperpSIGHE=divperpSIGHE';    %back to model index ordering

if(flagplot)
    figure;
    
    subplot(131);
    imagesc(x2/1e3,x3/1e3,JgradSIGH');        %transpose again to deal with MATLAB y expectation
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \nabla \Sigma_H \cdot (b \times E)')
    colorbar;
      
    subplot(132);
    imagesc(x2/1e3,x3/1e3,intdivJH);
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \int \nabla \cdot J_H');
    colorbar;
    cax=caxis;
    
    subplot(133);
    imagesc(x2/1e3,x3/1e3,divperpSIGHE');     %transpose again to deal with MATLAB y expectations
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \nabla \cdot (\Sigma_H E)');
    colorbar;
end %if


%% CHECK THE CURL OF THE ELECTRIC FIELD AND ITS CONTRIBUTION TO FAC
[c1,c2,c3]=curl(x1,x2,x3,permute(E(:,:,:,1),[2,1,3]),permute(E(:,:,:,2),[2,1,3]),permute(E(:,:,:,3),[2,1,3]));
c1=permute(c1,[2,1,3]);

if(flagplot)
    figure
    
    subplot(121)
    imagesc(x2,x3,-1*abs(SIGH).*squeeze(c1(end,:,:))')
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('\Sigma_H (b \cdot \nabla \times E) (FAC from curl E)');
    caxis(cax);
    colorbar;
    
    subplot(122);
    imagesc(x2/1e3,x3/1e3,JgradSIGH'-abs(SIGH).*squeeze(c1(end,:,:))');        %transpose again to deal with MATLAB y expectation
    axis xy;
    axis square;
    xlabel('mag. east dist. (km)');
    ylabel('mag. north dist. (km)');
    title('J_{||} from \nabla \Sigma_H \cdot (b \times E) + \Sigma_H (e_1 \cdot \nabla \times E)')
    caxis(cax)
    colorbar;    
end %if