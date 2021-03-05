% Compute the Poynting flux from a single frame and compare it against
% dissipation of ionospheric electromagnetic energy.  

% flags
flagplot=true;
flagfile=true;

% load mat_gemini
run("~/Projects/mat_gemini/setup.m")

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;
TOI=datetime([ymd,0,0,UTsec]);

if (~exist("S","var"))
    % Load/recompute auxiliary information
    % call the Poynting flux utility function
    lalt=1; llon=128; llat=128;
    cfg = gemini3d.read.config(direc);    % config file
    disp("Computing Poynting flux...");
    [Ei,B,S,mlon,mlat,datmag,datplasma,xg]=gemscr.postprocess.Poynting_calc(direc,TOI,lalt,llon,llat);    % Poynting flux, electric, and magnetic fields
    disp("Computing conductivities and conductance...");
    [sigP,sigH,sig0,SIGP,SIGH,incap,INCAP]=gemscr.postprocess.conductivity_reconstruct(TOI,datplasma,cfg,xg);   % Conductivities on the simulation grid
    
    % Get the electric fields
    disp("Computing Ohmic dissipation...");
    [v,E]=gemscr.postprocess.Efield(xg,datplasma.v2,datplasma.v3);   % fields, etc. on the simulation grid
    
    % Compute the Joule dissipation
    E2=squeeze(E(:,:,:,2)); E3=squeeze(E(:,:,:,3));
    ohmicdissipation=sigP.*(E2.^2+E3.^2);
    
    % Interpolate the energy dissipation rate onto a magnetic coordinate system
    % for plotting
    altlims=[80e3,900e3];
    mlonlims=[min(datmag.mlon),max(datmag.mlon)];
    mlatlims=[min(datmag.mlat),max(datmag.mlat)];
    [alti,mloni,mlati,ohmici]=gemscr.postprocess.model2magcoords(xg,ohmicdissipation,256,llon,llat,altlims,mlonlims,mlatlims);
    
    % Compute a field-integrated energy dissipation to compare to Poynting flux
    int_ohmic=zeros(llon,llat);
    for ilon=1:llon
        for ilat=1:llat
            int_ohmic(ilon,ilat)=trapz(alti(:),ohmici(:,ilon,ilat),1);
        end %for
    end %for
end %if

% Write output if desired
if (flagfile)
    Spar=-int_ohmic;    % force this to agree with conservation of energy
    Jtop=squeeze(datplasma.J1(end,:,:));
    mlonp=squeeze(xg.phi(1,:,1)*180/pi);
    mlatp=squeeze(90-xg.theta(1,1,:)*180/pi);
    [MLON,MLAT]=meshgrid(mlon,mlat);
    Jpar=interp2(mlatp(:),mlonp(:),Jtop,MLAT(:),MLON(:));
    Jpar=reshape(Jpar,[llon,llat]);
    E=Ei;
    save ~/scen1.mat mlon mlat Spar Jpar E SIGP SIGH sigP sigH mlonp mlatp ohmici int_ohmic;
end %if

% Plot the electric and magnetic fields
if (flagplot)
    figure;
    subplot(231);
    imagesc(mlon,mlat,squeeze(Ei(end,:,:,1))*1e3);
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("E_r (mV/m)")
    
    subplot(232);
    imagesc(mlon,mlat,squeeze(Ei(end,:,:,2))*1e3);
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("E_\theta (mV/m)")
    
    subplot(233);
    imagesc(mlon,mlat,squeeze(Ei(end,:,:,3))*1e3);
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("E_\phi (mV/m)")
    
    subplot(234);
    pcolor(mlon,mlat,squeeze(B(end,:,:,1))*1e9);
    shading flat;
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("B_r (nT)")
    
    subplot(235);
    pcolor(mlon,mlat,squeeze(B(end,:,:,2))*1e9);
    shading flat;
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("B_\theta (nT)")
    
    subplot(236);
    pcolor(mlon,mlat,squeeze(B(end,:,:,3))*1e9);
    shading flat;
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    colorbar;
    title("B_\phi (nT)")
    
    % Make a comparison plot of Poynting flux vs. Ohmic dissipation
    figure;
    
    subplot(121);
    imagesc(mlon,mlat,squeeze(S(end,:,:,1))*1e3);
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    c=colorbar;
    cax=caxis;
    caxval=max(abs(cax));
    caxis([-caxval,caxval]);
    ylabel(c,"Poynting Flux (mW/m^2)");
    title("S_1");
    
    % subplot(132);
    % imagesc(mloni,mlati,SIGP');
    % axis xy;
    % xlabel("mag. lon. (deg.)");
    % ylabel("mag. lat. (deg.)");
    % c=colorbar;
    % cax=caxis;
    % caxval=max(abs(cax));
    % caxis([-caxval,caxval]);
    % ylabel(c,"Pedersen Conductance (mhos)");
    % title("\Sigma_P");
    
    subplot(122);
    int_ohmic=int_ohmic';
    imagesc(mloni,mlati,int_ohmic*1e3);
    axis xy;
    xlabel("mag. lon. (deg.)");
    ylabel("mag. lat. (deg.)");
    c=colorbar;
    cax=caxis;
    caxval=max(abs(cax));
    caxis([-caxval,caxval]);
    ylabel(c,"Energy Dissipation (mW/m^2)");
    title("\Sigma_P E_\perp^2");
end %if
