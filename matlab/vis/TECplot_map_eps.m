addpath ~/matlab_ext/;
run('../../../mat_gemini/setup.m')

%SIMULATION LOCAITONS
simname='mooreOK3D_hemis_medres_corrected/';
basedir=['~/simulations/'];
direc=[basedir,simname];
%mkdir([direc,'/TECplots']);    %store output plots with the simulation data
mkdir([direc,'/TECplots_eps']);    %store output plots with the simulation data


%LOAD THE COMPUTED MAGNETIC FIELD DATA
load([direc,'/vTEC.mat']);
lt=numel(t);
mlon=mlong;


%SIMULATION META-DATA
cfg = gemini3d.read_config(direc);
%[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=readconfig([direc,'/inputs/config.ini']);


%TABULATE THE SOURCE LOCATION
thdist = pi/2 - deg2rad(cfg.sourcemlat);    %zenith angle of source location
phidist = deg2rad(cfg.sourcemlon);


figure(1);
%set(gcf,'PaperPosition',[0 0 4 8]);


%MAKE THE PLOTS AND SAVE TO A FILE
for it=1:lt
    fprintf('Printing TEC plots...\n');
    %CREATE A MAP AXIS
    figure(1);
    clf;
%    FS=16;
    FS=10;

    datehere=datevec(cfg.times(it));
    ymd=datehere(1:3);
    UTsec=datehere(4)*3600+datehere(5)*60+datehere(6);
    filename=gemini3d.datelab(ymd,UTsec);
    filename=[filename,'.dat'];
    titlestring=datestr(datenum(datehere));

    mlatlimplot=double([min(mlat)-0.5,max(mlat)+0.5]);
    mlonlimplot=double([min(mlon)-0.5,max(mlon)+0.5]);
    axesm('MapProjection','Mercator','MapLatLimit',mlatlimplot,'MapLonLimit',mlonlimplot);
    
    param=dvTEC(:,:,it);
%     imagesc(mlon,mlat,param);
%     axis xy;
%     axis equal;    
%     axis([mlonlimplot,mlatlimplot]);
    mlatlim=double([min(mlat),max(mlat)]);
    mlonlim=double([min(mlon),max(mlon)]);
    [MLAT,MLON]=meshgrat(mlatlim,mlonlim,size(param));
    pcolorm(MLAT,MLON,param);
    
    colormap(old_parula(256));
    set(gca,'FontSize',FS);
    tightmap;
%    caxis([-3,3]);
    caxis([-0.62,0.62]);
    c=colorbar
    set(c,'FontSize',FS)
    xlabel(c,'\Delta vTEC (TECU)')
    xlabel(sprintf('magnetic long. (deg.)\n\n'))
    ylabel(sprintf('magnetic lat. (deg.)\n\n\n'))

    titlestring=datestr(datenum(datehere));
    title(sprintf([titlestring,'\n\n']));
    print('-depsc2',[direc,'/TECplots_eps/',filename,'.eps']);


    %MAKE A MAP OF THE COAST ON THE FIRST TIME STEP
    if (it==1)
      load coastlines;
      [thetacoast,phicoast]=gemini3d.geog2geomag(coastlat,coastlon);
      mlatcoast=90-thetacoast*180/pi;
      mloncoast=phicoast*180/pi;

      if (360-cfg.sourcemlon<20)
          inds=find(mloncoast>180);
          mloncoast(inds)=mloncoast(inds)-360;
      end

     figure(2)
      axesm('MapProjection','Mercator','MapLatLimit',mlatlimplot,'MapLonLimit',mlonlimplot);
      mlatlim=double([min(mlat)-0.5,max(mlat)+0.5]);
      mlonlim=double([min(mlon)-0.5,max(mlon)+0.5]);
      [MLAT,MLON]=meshgrat(mlatlim,mlonlim,size(param));
      plotm(mlatcoast,mloncoast,'k-','LineWidth',1);
      setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',10,'PLineLocation',5,'MLabelLocation',10,'PLabelLocation',5);
%      setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',1,'PLineLocation',1,'MLabelLocation',1,'PLabelLocation',1);
      hold on;
      plotm(cfg.sourcemlat,cfg.sourcemlon,'r^','MarkerSize',10,'LineWidth',2);
      hold off;
      axis equal;
      tightmap;
      gridm on;
      print('-depsc2',[direc,'/TECplots_eps/','map.eps']);
    end
end
