%% ESF tests
%p.dtheta=3.5;
p.dtheta=4.5;    % puts boundary farther away
p.dphi=34;
%p.lp=522;
p.lp=256;
p.lq=256;
%p.lphi=580;
p.lphi=288;
p.altmin=80e3;
p.glat=8.35;
p.glon=360-76.9;     %Jicamarca
p.gridflag=1;
p.flagsource=0;
p.iscurv=true;
p.file_format="h5";


%% RUN THE GRID GENERATION CODE
if ~exist('xg', 'var')
    xg= gemini3d.grid.tilted_dipole(p);
end


%% PLOT THE OUTLINES OF THE DIPOLE GRID - THIS VERSION USES MLAT,MLON.,ALT. COORDS.
figure;
Re=6370e3;
mlat=90-xg.theta*180/pi;
dphi=max(xg.phi(:))-min(xg.phi(:));
mlon=xg.phi*180/pi;
alt=xg.alt/1e3;
hold on;

LW=2;
altlinestyle='-';

h=plot3(mlon(:,1,1),mlat(:,1,1),alt(:,1,1),'LineWidth',LW);
linecolor1=h.Color;
plot3(mlon(:,1,end),mlat(:,1,end),alt(:,1,end),altlinestyle,'LineWidth',LW-1);
plot3(mlon(:,end,1),mlat(:,end,1),alt(:,end,1),'LineWidth',LW);
h=plot3(mlon(:,end,end),mlat(:,end,end),alt(:,end,end),altlinestyle,'LineWidth',LW-1);
linecolor2=h.Color;

y=squeeze(mlat(1,:,1));
x=squeeze(mlon(1,:,1));
z=squeeze(alt(1,:,1));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(1,:,end));
x=squeeze(mlon(1,:,end));
z=squeeze(alt(1,:,end));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

y=squeeze(mlat(end,:,1));
x=squeeze(mlon(end,:,1));
z=squeeze(alt(end,:,1));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(end,:,end));
x=squeeze(mlon(end,:,end));
z=squeeze(alt(end,:,end));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

ix3=floor(xg.lx(3)/2);
y=squeeze(mlat(1,1,1:ix3));
x=squeeze(mlon(1,1,1:ix3));
z=squeeze(alt(1,1,1:ix3));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(1,1,ix3:xg.lx(3)));
x=squeeze(mlon(1,1,ix3:xg.lx(3)));
z=squeeze(alt(1,1,ix3:xg.lx(3)));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

y=squeeze(mlat(1,end,1:ix3));
x=squeeze(mlon(1,end,1:ix3));
z=squeeze(alt(1,end,1:ix3));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(1,end,ix3:xg.lx(3)));
x=squeeze(mlon(1,end,ix3:xg.lx(3)));
z=squeeze(alt(1,end,ix3:xg.lx(3)));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

y=squeeze(mlat(end,1,1:ix3));
x=squeeze(mlon(end,1,1:ix3));
z=squeeze(alt(end,1,1:ix3));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(end,1,ix3:xg.lx(3)));
x=squeeze(mlon(end,1,ix3:xg.lx(3)));
z=squeeze(alt(end,1,ix3:xg.lx(3)));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

y=squeeze(mlat(end,end,1:ix3));
x=squeeze(mlon(end,end,1:ix3));
z=squeeze(alt(end,end,1:ix3));
plot3(x,y,z,'LineWidth',LW);

y=squeeze(mlat(end,end,ix3:xg.lx(3)));
x=squeeze(mlon(end,end,ix3:xg.lx(3)));
z=squeeze(alt(end,end,ix3:xg.lx(3)));
plot3(x,y,z,altlinestyle,'LineWidth',LW-1);

ylabel('magnetic latitude (deg.)');
xlabel('magnetic longitude (deg.)');
zlabel('altitidue (km)');
%set(gca,'XTickLabel',{},'YTickLabel',{},'ZTickLabel',{});    %removes tick labels - useful for AI


%% GO BACK AND MAKE ALL LINES THE SAME COLOR
h=gca;
lline=numel(h.Children);
for iline=1:16    %the last three children are the surface and text label objects
    h.Children(iline).Color=[0 0 0];
end


%% ESF tests source location(s)
[sourcelat,sourcelong]=gemini3d.geomag2geog(pi/2,354*pi/180);
[sourcelat2,sourcelong2]=gemini3d.geomag2geog(pi/2-10*pi/180,354*pi/180);


%% Convert to magnetic
[sourcetheta,sourcephi]= gemini3d.geog2geomag(sourcelat,sourcelong);
sourcemlat=90-sourcetheta*180/pi;
sourcemlon=sourcephi*180/pi;
[sourcetheta2,sourcephi2]= gemini3d.geog2geomag(sourcelat2,sourcelong2);
sourcemlat2=90-sourcetheta2*180/pi;
sourcemlon2=sourcephi2*180/pi;


%% Plot source locations
hold on;
plot3(sourcemlon,sourcemlat,0,'o','MarkerSize',14,'Color',linecolor1);
plot3(sourcemlon2,sourcemlat2,0,'o','Markersize',14,'Color',linecolor2);

%% NOW CREATE A NEUTRAL GRID 
zmin=0;
zmax=660;    %Moore, OK
lz=330;
rhomin=0;
rhomax=1800;    %Moore, OK
lrho=750;
zn=linspace(zmin,zmax,lz);
rhon=linspace(rhomin,rhomax,lrho);
rn=6370+zn;    %geocentric distance (in km)


%% Lines comprising grid #1
drho=rhomax-rhomin;                                %radius of circle, in kilometers, describing perp. directions of axisymmetric model
xn=linspace(-1*drho,drho,100);           %N-S distance spanned by neutral model ("fake" number of grid points used here)
dthetan=(max(xn(:))-min(xn(:)))/rn(1);   %equivalent theta coordinates of the neutral mesh (used in the plot of grid)
thetan=linspace(sourcetheta-dthetan/2,sourcetheta+dthetan/2,100);    %theta coordinates of N-S distance specified
phinhalf1=sourcephi+sqrt((dthetan/2)^2-(thetan-sourcetheta).^2);
phinhalf2=sourcephi-sqrt((dthetan/2)^2-(thetan-sourcetheta).^2);
mlatn=90-thetan*180/pi;
mlonnhalf1=phinhalf1*180/pi;
mlonnhalf2=phinhalf2*180/pi;


%% Lines comprising grid #2
thetan2=linspace(sourcetheta2-dthetan/2,sourcetheta2+dthetan/2,100);    %theta coordinates of N-S distance specified
phinhalf12=sourcephi2+sqrt((dthetan/2)^2-(thetan2-sourcetheta2).^2);
phinhalf22=sourcephi2-sqrt((dthetan/2)^2-(thetan2-sourcetheta2).^2);
mlatn2=90-thetan2*180/pi;
mlonnhalf12=phinhalf12*180/pi;
mlonnhalf22=phinhalf22*180/pi;


%% AND OVERPLOT #1
hold on;
plot3(real(mlonnhalf1),mlatn,zn(1)*ones(size(mlatn)),altlinestyle,'LineWidth',LW-1);
plot3(real(mlonnhalf2),mlatn,zn(1)*ones(size(mlatn)),'LineWidth',LW);
plot3(real(mlonnhalf1),mlatn,zn(end)*ones(size(mlatn)),altlinestyle,'LineWidth',LW-1);
plot3(real(mlonnhalf2),mlatn,zn(end)*ones(size(mlatn)),'LineWidth',LW);
plot3(sourcephi*ones(size(zn))*180/pi,min(mlatn)*ones(size(zn)),zn,'LineWidth',LW);
plot3(sourcephi*ones(size(zn))*180/pi,max(mlatn)*ones(size(zn)),zn,'LineWidth',LW);
hold off;

h=gca;
lline=numel(h.Children);
for iline=1:6    %the line objects for each axis are added in a "stack" fashion (last in first out)
    h.Children(iline).Color=linecolor1;
%    h.Children(iline).LineWidth=0.60;
end


%% OVERPLOT #2
hold on;
plot3(real(mlonnhalf12),mlatn2,zn(1)*ones(size(mlatn2)),altlinestyle,'LineWidth',LW-1);
plot3(real(mlonnhalf22),mlatn2,zn(1)*ones(size(mlatn2)),'LineWidth',LW);
plot3(real(mlonnhalf12),mlatn2,zn(end)*ones(size(mlatn2)),altlinestyle,'LineWidth',LW-1);
plot3(real(mlonnhalf22),mlatn2,zn(end)*ones(size(mlatn2)),'LineWidth',LW);
plot3(sourcephi2*ones(size(zn))*180/pi,min(mlatn2)*ones(size(zn)),zn,'LineWidth',LW);
plot3(sourcephi2*ones(size(zn))*180/pi,max(mlatn2)*ones(size(zn)),zn,'LineWidth',LW);
hold off;

h=gca;
lline=numel(h.Children);
for iline=1:6    %the line objects for each axis are added in a "stack" fashion (last in first out)
    h.Children(iline).Color=linecolor2;
%    h.Children(iline).LineWidth=0.60;
end


%% adjust plot parameters
FS=12;
set(gca,'FontSize',FS);
grid on;
set(gca,'LineWidth',LW-0.5)
view(1,2);


%CARTESIAN NEUTRAL GRID
%{
dz=72e3;
drho=72e3;

lz=9;
lrho=6;

zn=linspace(0,lz*dz,lz)';
rhon=linspace(0,lrho*drho,lrho);
xn=[-1*fliplr(rhon),rhon(2:lrho)];
lx=numel(xn);
yn=xn;          %all based off of axisymmetric model
rn=zn+6370e3;   %convert altitude to geocentric distance

dtheta=(max(xn(:))-min(xn(:)))/rn(1);    %equivalent theta coordinates of the neutral mesh
dphi=(max(yn(:))-min(yn(:)))/rn(1);      %should be a sin(theta) there?
thetan=linspace(meanth-dtheta/2,meanth+dtheta/2,2*lx-1);    %fudge this to make it look good.
phin=linspace(meanphi-dphi/2,meanphi+dphi/2,2*lx-1);
[THETAn,PHIn,Rn]=meshgrid(thetan,phin,rn);

MLATn=90-THETAn*180/pi;
MLONn=PHIn*180/pi;
Zn=(Rn-6370e3)/1e3;

hold on;
plot3(MLATn(:,end,1),MLONn(:,end,1),Zn(:,end,1),'LineWidth',LW);
h=plot3(MLATn(:,end,end),MLONn(:,end,end),Zn(:,end,end),'LineWidth',LW);
linecolor=h.Color;    %grab the color of the second line
plot3(MLATn(:,1,1),MLONn(:,1,1),Zn(:,1,1),'LineWidth',LW);
plot3(MLATn(:,1,end),MLONn(:,1,end),Zn(:,1,end),'LineWidth',LW);
plot3(squeeze(MLATn(1,:,1)),squeeze(MLONn(1,:,1)),squeeze(Zn(1,:,1)),'LineWidth',LW);
plot3(squeeze(MLATn(1,:,end)),squeeze(MLONn(1,:,end)),squeeze(Zn(1,:,end)),'LineWidth',LW);
plot3(squeeze(MLATn(end,:,1)),squeeze(MLONn(end,:,1)),squeeze(Zn(end,:,1)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(end,:,end)),squeeze(MLONn(end,:,end)),squeeze(Zn(end,:,end)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(1,1,:)),squeeze(MLONn(1,1,:)),squeeze(Zn(1,1,:)),'LineWidth',LW);
plot3(squeeze(MLATn(1,end,:)),squeeze(MLONn(1,end,:)),squeeze(Zn(1,end,:)),'LineWidth',LW);
plot3(squeeze(MLATn(end,1,:)),squeeze(MLONn(end,1,:)),squeeze(Zn(end,1,:)),altlinestyle,'LineWidth',LW);
plot3(squeeze(MLATn(end,end,:)),squeeze(MLONn(end,end,:)),squeeze(Zn(end,end,:)),altlinestyle,'LineWidth',LW);
%}

%print -dpng 3Datmosionos_grid.png;
%print -depsc2 -painters 3Datmosionos_grid.eps;
%print -dpdf -painters 3Datmosionos_grid.pdf;


%% Add map lines if possible
if (license('test','Map_Toolbox'))
    %    figure;
    %    thetarange=[pi/2-max(mlat(:))*pi/180,pi/2-min(mlat(:))*pi/180];
    %    phirange=[min(mlon(:))*pi/180,max(mlon(:))*pi/180];
    %    [glatrange,glonrange]=geomag2geog(thetarange,phirange);
    %    glatrange=sort(glatrange);
    %    glonrange=sort(glonrange);
    %    glatrange(1)=glatrange(1)-10;
    %    glatrange(2)=glatrange(2)+10;
    %    glonrange(1)=glonrange(1)-10;
    %    glonrange(2)=glonrange(2)+10;
    %    worldmap(glatrange,glonrange);
    %    load coastlines;
    %    plotm(coastlat,coastlon);
    
    hold on;
    ax=axis;
    load coastlines;
    [thetacoast,phicoast]= gemini3d.geog2geomag(coastlat,coastlon);
    mlatcoast=90-thetacoast*180/pi;
    mloncoast=phicoast*180/pi;
    %  mlatcoast=sort(mlatcoast);
    %  mloncoast=sort(mloncoast);
    
    bufferlon=40;
    bufferlat=50;
    
    if 360-sourcemlon<bufferlon
        inds=find(mloncoast<180);
        mloncoast(inds)=mloncoast(inds)+360;
    end
    
    inds=find(mloncoast>sourcemlon-bufferlon & mloncoast<sourcemlon+bufferlon & ...
        mlatcoast>sourcemlat-bufferlat & mlatcoast<sourcemlat+bufferlat);
    mloncoast=mloncoast(inds);
    mlatcoast=mlatcoast(inds);
    
    plot3(mloncoast,mlatcoast,zeros(size(mlatcoast)),'k.','MarkerSize',0.5);
    %  axis(ax);    %reset axis
end


%% OLD/EXTRA CODE THAT I'M LOATH TO PART WITH (MZ)
%MAKE A MOVIE OF THE GRID ROTATING
direc='~/Downloads/gridplot/';
mkdir(direc)
azstart=255;
az=azstart:1:azstart+359;
el=35;
for iaz=1:numel(az)
    view(az(iaz),el);
    axis tight;
    azstr=num2str(az(iaz));
    ndigits=floor(log10(az(iaz)));
    while(ndigits<2)
       azstr=['0',azstr];
       ndigits=ndigits+1;
    end
    print('-dpng',[direc,azstr,'.png'],'-r300');
    %print('-depsc2',[direc,azstr,'.eps']);
end
