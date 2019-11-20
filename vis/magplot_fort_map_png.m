direc='~/SDHCcard/iowa3D_hemis_medres2/';
filename='magfields_fort_diff.mat';
load([direc,filename]);
lt=size(simdate_series,1);


%INTERPOLATE TO HIGHER SPATIAL RESOLUTION FOR PLOTTING
llonp=200;
llatp=200;
mlonp=linspace(min(mlon(:)),max(mlon(:)),llonp);
mlatp=linspace(min(mlat(:)),max(mlat(:)),llatp);
[MLONP,MLATP]=meshgrid(mlonp,mlatp);
for it=1:lt
    param=interp2(mlon,mlat,squeeze(Brt(:,:,:,it)),MLONP,MLATP);
    Brtp(:,:,:,it)=reshape(param,[1, llonp, llatp]);
    param=interp2(mlon,mlat,squeeze(Bthetat(:,:,:,it)),MLONP,MLATP);
    Bthetatp(:,:,:,it)=reshape(param,[1, llonp, llatp]);
    param=interp2(mlon,mlat,squeeze(Bphit(:,:,:,it)),MLONP,MLATP);
    Bphitp(:,:,:,it)=reshape(param,[1, llonp, llatp]);
end
fprintf('...Done interpolating...\n');


%SIMULATION META-DATA
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc]=readconfig([direc, filesep, 'inputs']);


%TABULATE THE SOURCE OR GRID CENTER LOCATION
if (~isempty(mloc))
  mlatsrc=mloc(1);
  mlonsrc=mloc(2);
  thdist=pi/2-mlatsrc*pi/180;    %zenith angle of source location
  phidist=mlonsrc*pi/180;
else
  thdist=mean(theta(:));
  phidist=mean(phi(:));
  mlatsrc=90-thdist*180/pi;
  mlonsrc=phidist*180/pi;
end


%MAKE THE PLOTS AND SAVE TO A FILE
for it=1:lt-1
    fprintf('Printing magnetic field plots...\n');
    %CREATE A MAP AXIS
    figure(1);
    FS=8;

    datehere=simdate_series(it,:);
    ymd=datehere(1:3);
    UTsec=datehere(4)*3600+datehere(5)*60+datehere(6);
    filename=datelab(ymd,UTsec);
    filename=[filename,'.dat']
    titlestring=datestr(datenum(datehere));

%    subplot(131);
    figure(1);
    clf;
    mlatlimplot=[min(mlat)-0.5,max(mlat)+0.5];
    mlonlimplot=[min(mlon)-0.5,max(mlon)+0.5];
    axesm('MapProjection','Mercator','MapLatLimit',mlatlimplot,'MapLonLimit',mlonlimplot);
    param=squeeze(Brtp(:,:,:,it))*1e9;
    mlatlim=[min(mlatp),max(mlatp)];
    mlonlim=[min(mlonp),max(mlonp)];
    [MLAT,MLON]=meshgrat(mlatlim,mlonlim,size(param));
    pcolorm(MLAT,MLON,param);
    colormap(parula(256));
    set(gca,'FontSize',FS);
    tightmap;
    caxlim=max(abs(param(:)))
    caxlim=max(caxlim,0.001);
    caxis([-caxlim,caxlim]);
    c=colorbar
    set(c,'FontSize',FS)
    title(sprintf(['B_r (nT)  ',titlestring,' \n\n']));
    xlabel(sprintf('magnetic long. (deg.) \n\n'))
    ylabel(sprintf('magnetic lat. (deg.)\n\n\n'))
    hold on;
    ax=axis;
    plotm(mlatsrc,mlonsrc,'r^','MarkerSize',6,'LineWidth',2);
    hold off;

%    subplot(132);
    figure(2);
    clf;
    axesm('MapProjection','Mercator','MapLatLimit',mlatlimplot,'MapLonLimit',mlonlimplot);
    param=squeeze(Bthetatp(:,:,:,it))*1e9;
    pcolorm(MLAT,MLON,param);
    colormap(parula(256));
    set(gca,'FontSize',FS);
    tightmap;
    caxlim=max(abs(param(:)))
    caxlim=max(caxlim,0.001);
    caxis([-caxlim,caxlim]);
    c=colorbar
    set(c,'FontSize',FS)
    title(sprintf(['B_\\theta (nT)  ',titlestring,' \n\n']));
    xlabel(sprintf('magnetic long. (deg.) \n\n'))
    ylabel(sprintf('magnetic lat. (deg.)\n\n\n'))
    hold on;
    ax=axis;
    plotm(mlatsrc,mlonsrc,'r^','MarkerSize',6,'LineWidth',2);
    hold off;

%    subplot(133);
    figure(3);
    clf;
    axesm('MapProjection','Mercator','MapLatLimit',mlatlimplot,'MapLonLimit',mlonlimplot);
    param=squeeze(Bphitp(:,:,:,it))*1e9;
    %imagesc(mlon,mlat,param);
    pcolorm(MLAT,MLON,param);
    colormap(parula(256));
    set(gca,'FontSize',FS);
    tightmap;
    caxlim=max(abs(param(:)))
    caxlim=max(caxlim,0.001);
    caxis([-caxlim,caxlim]);
    c=colorbar
    set(c,'FontSize',FS)
    title(sprintf(['B_\\phi (nT)  ',titlestring,' \n\n']));
    xlabel(sprintf('magnetic long. (deg.) \n\n'))
    ylabel(sprintf('magnetic lat. (deg.)\n\n\n'))
    hold on;
    ax=axis;
    plotm(mlatsrc,mlonsrc,'r^','MarkerSize',6,'LineWidth',2);
    hold off;


    %ADD A MAP OF COASTLINES
%    if (license('test','Map_Toolbox'))
        load coastlines;
        [thetacoast,phicoast]=geog2geomag(coastlat,coastlon);
        mlatcoast=90-thetacoast*180/pi;
        mloncoast=phicoast*180/pi;

        if (360-mlonsrc<20)
            inds=find(mloncoast>180);
            mloncoast(inds)=mloncoast(inds)-360;
        end

%        subplot(131);
        figure(1);
        hold on;
        ax=axis;
        plotm(mlatcoast,mloncoast,'k-','LineWidth',1);
%        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',10,'PLineLocation',5,'MLabelLocation',10,'PLabelLocation',5);
        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',2,'PLineLocation',1,'MLabelLocation',2,'PLabelLocation',1);
        gridm on;
        print('-dpng',[direc,'/Brplots/',filename,'.png'],'-r300');
%        print('-depsc2',[direc,'/Brplots_eps/',filename,'.eps']);

%        subplot(132);
        figure(2);
        hold on;
        ax=axis;
        plotm(mlatcoast,mloncoast,'k-','LineWidth',1);
%        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',10,'PLineLocation',5,'MLabelLocation',10,'PLabelLocation',5);
        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',2,'PLineLocation',1,'MLabelLocation',2,'PLabelLocation',1);
        gridm on;
        print('-dpng',[direc,'/Bthplots/',filename,'.png'],'-r300');
%        print('-depsc2',[direc,'/Bthplots_eps/',filename,'.eps']);

%        subplot(133);
        figure(3);
        hold on;
        ax=axis;
        plotm(mlatcoast,mloncoast,'k-','LineWidth',1);
%        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',10,'PLineLocation',5,'MLabelLocation',10,'PLabelLocation',5);
        setm(gca,'MeridianLabel','on','ParallelLabel','on','MLineLocation',2,'PLineLocation',1,'MLabelLocation',2,'PLabelLocation',1);
        gridm on;
        print('-dpng',[direc,'/Bphiplots/',filename,'.png'],'-r300');
%        print('-depsc2',[direc,'/Bphiplots_eps/',filename,'.eps']);
%    end
    axis(ax);
end