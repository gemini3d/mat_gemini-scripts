
%% path to old_parula
addpath ~/matlab_ext/;
%addpath ~/zettergmdata/Projects/GEMINI-scripts/postprocess/;
%addpath ~/zettergmdata/Projects/GEMINI-scripts/script_utils/;
% from mat_gemini-script directory run
%    buildtool setup



%% Simulation disturbance and control
simname='mooreOK3D_hemis_medres_corrected'
simname_control='mooreOK3D_hemis_medres_corrected_control'
basedir='~/simulations/'
direc=[basedir,simname];
direc2=[basedir,simname_control];


%% Load sizes and grid
if (~exist('xg','var'))
  xg=gemini3d.read.grid([direc,'/inputs/']);    % for now assume that the control grid is the same as the dist; otherwise can get interpolation artifacts in BG subtraction
  x1=xg.x1(3:end-2); x2=xg.x2(3:end-2); x3=xg.x3(3:end-2);
  xgBG=gemini3d.read.grid([direc2,'/inputs/']);
  x1BG=xgBG.x1(3:end-2); x2BG=xgBG.x2(3:end-2); x3BG=xgBG.x3(3:end-2);
  [X2,X1,X3]=meshgrid(x2(:),x1(:),x3(:));
  [X2BG,X1BG,X3BG]=meshgrid(x2BG(:),x1BG(:),x3BG(:));
end %if
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
lh=lx1;lsp=7;


%% Read in config file
cfg=gemini3d.read.config(direc);
ymd0=cfg.ymd; UTsec0=cfg.UTsec0; tdur=cfg.tdur; dtout=cfg.dtout; flagoutput=cfg.flagoutput;
mloc(1)=cfg.sourcemlat; mloc(2)=cfg.sourcemlon;
%[ymd0,UTsec0,tdur,dtout,flagoutput,mloc,activ,indat_size,indat_grid,indat_file]=gemini3d.read.config([direc,'/inputs/']);


%% Source location, interp size, and mlat/mlon slice locations
lat2=44.9397;     % center location of source, magnetic coordinates
lon2=328.7981;
lalt=512;
llon=512;
llat=512;
altlims=[90e3 550e3];
mlonlims=[lon2-12.5,lon2+12.5];
mlatlims=[lat2-12.5,lat2+12.5];


%% DO INTERPOLATION IN Q,P SPACE SO WE CAN USE INTERP2
t=0;
ymd=ymd0;
UTsec=UTsec0;
it=1;
while(t<tdur)

    %% Load the disturbance and BG data
    disp('loading data...')
    disp(ymd)
    disp(UTsec)
    dat=gemini3d.read.frame(direc, time=cfg.times(it));
    datBG=gemini3d.read.frame(direc2, time=cfg.times(it));


    %% Project velocity into geographic coordinates
    vir=dat.v1.*dot(xg.e1,xg.er,4)+dat.v2.*dot(xg.e2,xg.er,4);
    virBG=datBG.v1.*dot(xgBG.e1,xgBG.er,4)+datBG.v2.*dot(xgBG.e2,xgBG.er,4);
    virBG=interp3(X2BG,X1BG,X3BG,virBG,X2(:),X1(:),X3(:));
    virBG=reshape(virBG,[lx1,lx2,lx3]);
    neBG=interp3(X2BG,X1BG,X3BG,datBG.ne,X2(:),X1(:),X3(:));
    neBG=reshape(neBG,[lx1,lx2,lx3]);
    dvir=vir-virBG;
    dnepct=(dat.ne-neBG)./neBG*100;


    %% Sample model data on plotting grid
    disp('interpolating...')
    [dvirilat, alti,~,mlati] = gemini3d.grid.model2magcoords(xg,dvir,lalt,1,llat,altlims,[lon2,lon2],mlatlims);
    [dvirilon, ~, mloni] = gemini3d.grid.model2magcoords(xg,dvir,lalt,llon,1,altlims,mlonlims,[lat2,lat2]);
    dneilat = gemini3d.grid.model2magcoords(xg,dnepct,lalt,1,llat,altlims,[lon2,lon2],mlatlims);
    dneilon = gemini3d.grid.model2magcoords(xg,dnepct,lalt,llon,1,altlims,mlonlims,[lat2,lat2]);


    %% Figure and resizing
    disp('plotting...');
    figure;    %generating a new figure and closing each time prevents resizing issues with print.
    set(gcf,'PaperPosition',[0 0 8.5 11]);
    ax=[lat2-8.5 lat2+8.5 90 550];
    FS=12;

    subplot(221)
    h=imagesc(mlati,alti/1e3,squeeze(dneilat));
    hold on;
    plot([lat2 lat2],altlims/1e3,'w--','LineWidth',2);
    hold off;
%    set(h,'alphadata',~isnan(neI));
    set(gca,'FontSize',FS);
    xlabel('magnetic latitude (deg.)')
    ylabel('altitude (km)')
%    axis(ax);
    axis xy;
    colormap(old_parula(256));
    clim([-15 15]);
    c=colorbar;
    xlabel(c,'\Delta n_e (pct. diff.)')
    set(c,'Location','SouthOutside');
    set(c,'Fontsize',FS)

    timestr=datestr(datenum([ymd,UTsec/3600,0,0]));
    title(timestr);

    subplot(222)
    h=imagesc(mloni,alti/1e3,squeeze(dneilon));
    hold on;
    plot([lon2 lon2],altlims/1e3,'w--','LineWidth',2);
    hold off;
%    set(h,'alphadata',~isnan(neI));
    set(gca,'FontSize',FS);
    xlabel('magnetic longitude (deg.)')
    ylabel('altitude (km)')
%    axis(ax);
    axis xy;
    colormap(old_parula(256));
    clim([-15 15]);
    c=colorbar;
    xlabel(c,'\Delta n_e (pct. diff.)')
    set(c,'Location','SouthOutside');
    set(c,'Fontsize',FS)

    subplot(223)
    h=imagesc(mlati,alti/1e3,squeeze(dvirilat));
    hold on;
    plot([lat2 lat2],altlims/1e3,'w--','LineWidth',2);
    hold off;
%    set(h,'alphadata',~isnan(neI));
    set(gca,'FontSize',FS);
    xlabel('magnetic latitude (deg.)')
    ylabel('altitude (km)')
%    axis(ax);
    axis xy;
    colormap(old_parula(256));
    clim([-75 75]);
    c=colorbar;
    xlabel(c,'\Delta v_{i,r} (m/s)')
    set(c,'Location','SouthOutside');
    set(c,'Fontsize',FS)

    subplot(224)
    h=imagesc(mloni,alti/1e3,squeeze(dvirilon));
    hold on;
    plot([lon2 lon2],altlims/1e3,'w--','LineWidth',2);
    hold off;
%    set(h,'alphadata',~isnan(neI));
    set(gca,'FontSize',FS);
    xlabel('magnetic longitude (deg.)')
    ylabel('altitude (km)')
%    axis(ax);
    axis xy;
    colormap(old_parula(256));
    clim([-75 75]);
    c=colorbar;
    xlabel(c,'\Delta v_{i,r} (m/s)')
    set(c,'Location','SouthOutside');
    set(c,'Fontsize',FS)

    % PRINT
    filename=gemini3d.datelab(ymd,UTsec);
    print('-dpng',['./plots3D/png/',filename,'.png'],'-r300');
    print('-depsc2',['./plots3D/eps/',filename,'.eps']);

    [ymd,UTsec]=gemini3d.dateinc(dtout,ymd,UTsec);
    t=t+dtout;
    it=it+1;
    close all;
end
