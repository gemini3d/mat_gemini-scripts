function h=plot2D_curv_north(t,dmy,xg,parm,parmlbl,caxlims)

%CLEAR AND SET FIGURE HANDLES
clf;
h=gcf;


%SIZE OF SIMULATION
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);
inds1=3:lx1+2;
inds2=3:lx2+2;
inds3=3:lx3+2;
Re=6370e3;


%JUST PICK AN X3 LOCATION FOR THE PLOT
ix3=floor(lx3/2);


%SIZE OF PLOT GRID THAT WE ARE INTERPOLATING ONTO
%ix1s=floor(lx1/2):lx1;    %only valide for a grid which is symmetric aboutu magnetic equator... (I think)
ix1s=find(xg.x1(inds1)>=0);

minz=0;
maxz=500;
[tmp,ix1]=min(abs(xg.alt(ix1s,1,1)-maxz*1e3));
ix1=ix1s(ix1);
thetavals=xg.theta(ix1:lx1,:,:);
meantheta=mean(thetavals(:));
phivals=xg.phi(ix1:lx1,:,:);
meanphi=mean(phivals(:));
x=(thetavals-meantheta);      %this is a mag colat. coordinate and is only used for defining grid in linspaces below and the parametric surfaces in the plots
y=(phivals-meanphi);          %mag. lon coordinate
z=xg.alt(ix1:lx1,:,:)/1e3;    %altitude
lxp=500;
lyp=500;
lzp=500;
minx=min(x(:));
maxx=max(x(:));%+0.5*(max(x(:))-min(x(:)));
miny=min(y(:));
maxy=max(y(:));
xp=linspace(minx,maxx,lxp);
yp=linspace(miny,maxy,lyp);
zp=linspace(minz,maxz,lzp)';


%INTERPOLATE ONTO PLOTTING GRID
[X,Z]=meshgrid(xp,zp*1e3);

%{
    %WE NEED THE Q,P PAIRS FOR THIS GRID
    %BACK TO SPHERICAL FIRST (ROTATE)
    r1=mean(xg.r(1,:));
    r2=mean(xg.r(lx1,:));
    if abs(r1-r2)>10e3
        if r1<r2
            meanth=mean(xg.theta(1,:));
        else
            meanth=mean(xg.theta(lx1,:));
        end
    else
        meanth=pi/2;
    end
    rotmat=[cos(meanth), -sin(meanth); sin(meanth), cos(meanth)]';
    xx=X(:);
    zx=Z(:);
    xxp=zeros(size(xx));
    zxp=xxp;
    lk=numel(xx);
    for k=1:lk
        xz=rotmat*[xx(k); zx(k)];
        xxp(k)=xz(1); zxp(k)=xz(2);
    end

    %NOW OFFSET
    xsurf=Re*sin(meanth);
    zsurf=Re*cos(meanth);
    xxp=xxp+xsurf;
    zxp=zxp+zsurf;


    %NOW TO SPHERICAL
    rxp=sqrt(xxp.^2+zxp.^2);
    thetaxp=acos(zxp./rxp);
%}

%DIRECT TO SPHERICAL
rxp=Z(:)+Re;
thetaxp=X(:)+meantheta;
%phixp=Y(:)+meanphi;


%NOW SPHERICAL TO DIPOLE
qplot=(Re./rxp).^2.*cos(thetaxp);
pplot=rxp/Re./sin(thetaxp).^2;
%phiplot=phixp;    %phi is same in spherical and dipole


%NOW WE CAN DO A `PLAID' INTERPOLATION
parmtmp=parm(:,:,ix3);
parmp=interp2(xg.x2(inds2),xg.x1(inds1),parmtmp,pplot,qplot);
parmp=reshape(parmp,lzp,lxp);    %slice expects the first dim. to be "y"


%CONVERT ANGULAR COORDINATES TO MLAT,MLON
xp=90-(xp+meantheta)*180/pi;
[xp,inds]=sort(xp);
parmp=parmp(:,inds);

%yp=(yp+meanphi)*180/pi;
%[yp,inds]=sort(yp);
%parmp=parmp(inds,:,:);


%COMPUTE SOME BOUNDS FOR THE PLOTTING
minxp=min(xp(:));
maxxp=max(xp(:));
minyp=min(yp(:));
maxyp=max(yp(:));
minzp=min(zp(:));
maxzp=max(zp(:));


%NOW THAT WE'VE SORTED, WE NEED TO REGENERATE THE MESHGRID
[XP,YP,ZP]=meshgrid(xp,yp,zp);
FS=18;

%MAKE THE PLOT!
%subplot(2,11,1:3,'align');
%subplot(2,11,1:3);
h=imagesc(xp,zp,parmp);
set(h,'alphadata',~isnan(parmp));
set(gca,'FontSize',FS);
axis xy;
%axis tight;
%ax=axis;
%ax(3)=80;
%axis(ax);
clim(caxlims)
c=colorbar;
xlabel(c,parmlbl);
xlabel('magnetic latitude (deg.)');
ylabel('altitude (km)');

%{
%MAKE THE PLOTS!
FS=16;
%xslice=[90-meantheta*180/pi];   %make a few slices at differen altitudes
xslice=[];
yslice=[];
zslice=[150,300,750];
h=slice(XP,YP,ZP,parmp,xslice,yslice,zslice);
shading flat;
hold on;
ix3=floor(lx3/2);
surfx=90-(x(:,:,ix3)+meantheta)*180/pi;    %create a surface out of a meridional slice
surfy=(y(:,:,ix3)+meanphi)*180/pi;
surfz=z(:,:,ix3);
h=slice(XP,YP,ZP,parmp,surfx,surfy,surfz);
shading flat;
ix2=floor(lx2/2);
surfx=squeeze(90-(x(:,ix2,:)+meantheta)*180/pi);    %create a another surface out of slice along constant L-shell
surfy=squeeze((y(:,ix2,:)+meanphi)*180/pi);
surfz=squeeze(z(:,ix2,:));
h=slice(XP,YP,ZP,parmp,surfx,surfy,surfz);
shading flat;
hold off;
%set(h,'alphadata',~isnan(parmp));
set(gca,'FontSize',FS);
axis xy;
axis tight;
clim(caxlims)
c=colorbar;
%ax=axis;
%axis([ax(1:4),0,ax(6)]);
%xlabel(c,sprintf('n_{e} (log_{10} m^{-3})'))
xlabel(c,parmlbl)
xlabel('mag. lat. (deg.)');
ylabel('mag. long. (deg.)');
zlabel('alt. (km)')
axis([minxp,maxxp,minyp,maxyp,minzp,maxzp]);
%}



%CONSTRUCT A STRING FOR THE TIME AND DATE
UThrs=floor(t);
UTmin=floor((t-UThrs)*60);
UTsec=floor((t-UThrs-UTmin/60)*3600);
UThrsstr=num2str(UThrs);
UTminstr=num2str(UTmin);
if (numel(UTminstr)==1)
  UTminstr=['0',UTminstr];
end
UTsecstr=num2str(UTsec);
if (numel(UTsecstr)==1)
  UTsecstr=['0',UTsecstr];
end

timestr=[UThrsstr,':',UTminstr,':',UTsecstr];
%strval=sprintf('%s \n %s',[num2str(dmy(1)),'/',num2str(dmy(2)),'/',num2str(dmy(3))], ...
%    [num2str(t),' UT']);
strval=sprintf('%s \n %s',[num2str(dmy(2)),'/',num2str(dmy(1)),'/',num2str(dmy(3))], ...
    [timestr,' UT']);
%text(xp(round(lxp/10)),zp(lzp-round(lzp/7.5)),strval,'FontSize',18,'Color',[0.66 0.66 0.66],'FontWeight','bold');
%text(xp(round(lxp/10)),zp(lzp-round(lzp/7.5)),strval,'FontSize',16,'Color',[0.5 0.5 0.5],'FontWeight','bold');
title(strval);

end
