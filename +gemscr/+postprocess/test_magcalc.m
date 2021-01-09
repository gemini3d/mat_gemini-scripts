run("~/Projects/mat_gemini/setup.m");
run("~/Projects/GEMINI-scripts/setup.m");

% data set to test with
ymd=[2017,3,2];
UTsec=27285;
TOI=datetime([ymd,0,0,UTsec]);
direc="~/simulations/arcs_angle_wide_nonuniform_large_highresx1/";

% load the magnetic field perturbations
dat=gemini3d.read.magframe(direc,"time",TOI);
Bx=dat.Bphi;          % alt,theta,phi; east is phi direction
By=-1*dat.Btheta;     % theta goes against northward distance
%Byt=dat.Bthetat;
Bz=dat.Br;            % r same direction as up
it=10;

% convert the coordinates into something we can differentiate as Cartesian
% x=east, y=north, z=altitude
[z,x,y]=gemscr.geomag2UENgeomag(dat.r-6370e3,dat.mlon,dat.mlat);
[X,Y,Z]=meshgrid(x(:),y(:),z(:));

% permute magnetic field data to righthanded wrt to UEN coords.
% originally these will come out as r,theta,phi
Bz=permute(Bz(:,:,:),[1,3,2]);  % -> r,phi,theta (up,east,north)
Bx=permute(Bx(:,:,:),[1,3,2]);
By=permute(By(:,:,:),[1,3,2]);

% compute a numerical curl of the magnetic field
mu0=4*pi*1e-7;
% for taking curl permute to x,y,z (from z,x,y)
Hx=permute(Bx/mu0,[2,3,1]); % permute to east, north, up
Hy=permute(By/mu0,[2,3,1]); 
Hz=permute(Bz/mu0,[2,3,1]);

% wtf does matlab curl just not work???  I literally cannot get it to take
% a curl correctly; perhaps I'm just using the function wrong???
%[Jx,Jz,Jy]=curl(X,Z,Y,Hx,Hz,Hy);
%[Jx,Jy,Jz]=curl(X,Y,Z,Hx,Hy,Hz);
%[Jx,Jy,Jz]=curl(X,Y,Z,Hx,zeros(size(Hx)),zeros(size(Hx)));

dx=x(2)-x(1);
dy=y(2)-y(1);
dz=z(2)-z(1);

Jx=zeros(size(Hx)); Jy=zeros(size(Hy)); Jz=zeros(size(Hz));
dHzdy=diff(Hz,1,2)/dy;
dHydz=diff(Hy,1,3)/dz;
Jx(2:end-1,2:end-1,2:end-1)=dHzdy(2:end-1,2:end,2:end-1)-dHydz(2:end-1,2:end-1,2:end);

dHzdx=diff(Hz,1,1)/dx;
dHxdz=diff(Hx,1,3)/dz;
Jy(2:end-1,2:end-1,2:end-1)=-1*(dHzdx(2:end,2:end-1,2:end-1)-dHxdz(2:end-1,2:end-1,2:end));

dHydx=diff(Hy,1,1)/dx;
dHxdy=diff(Hx,1,2)/dy;
Jz(2:end-1,2:end-1,2:end-1)=dHydx(2:end,2:end-1,2:end-1)-dHxdy(2:end-1,2:end,2:end-1);

% fix units
Bx=Bx/1e-9; By=By/1e-9; Bz=Bz/1e-9;    %so B in nT
% for plotting permute back to up,east,north
Jx=permute(Jx/1e-6,[3,1,2]); 
Jy=permute(Jy/1e-6,[3,1,2]); 
Jz=permute(Jz/1e-6,[3,1,2]);    %so J in uA/m^2

% make some diagnostic plots
% magnetic field
figure(1);
subplot(331);
pcolor(x/1e3,z/1e3,Bz(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('B_z (up) nT');
colorbar;

subplot(332);
pcolor(x/1e3,z/1e3,Bx(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('B_x (east) nT');
colorbar;

subplot(333);
pcolor(x/1e3,z/1e3,By(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('B_y (north) nT');
colorbar;

subplot(334)
pcolor(y/1e3,z/1e3,squeeze(Bz(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('B_z (up) nT');
colorbar;

subplot(335);
pcolor(y/1e3,z/1e3,squeeze(Bx(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('B_x (east) nT');
colorbar;

subplot(336);
pcolor(y/1e3,z/1e3,squeeze(By(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('B_y (north) nT');
colorbar;

subplot(337)
pcolor(x/1e3,y/1e3,squeeze(Bz(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('B_z (up) nT');
colorbar;

subplot(338);
pcolor(x/1e3,y/1e3,squeeze(Bx(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('B_x (east) nT');
colorbar;

subplot(339);
pcolor(x/1e3,y/1e3,squeeze(By(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('B_y (north) nT');
colorbar;

% current density
figure(2);
subplot(331);
pcolor(x/1e3,z/1e3,Jz(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('J_z (up) uA/m^2');
colorbar;

subplot(332);
pcolor(x/1e3,z/1e3,Jx(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('J_x (east) uA/m^2');
colorbar;

subplot(333);
pcolor(x/1e3,z/1e3,Jy(:,:,end/2));
shading flat;
xlabel('x (east)');
ylabel('z (alt.)');
title('J_y (north) uA/m^2');
colorbar;

subplot(334)
pcolor(y/1e3,z/1e3,squeeze(Jz(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('J_z (up) uA/m^2');
colorbar;

subplot(335);
pcolor(y/1e3,z/1e3,squeeze(Jx(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('J_x (east) uA/m^2');
colorbar;

subplot(336);
pcolor(y/1e3,z/1e3,squeeze(Jy(:,end/2,:)));
shading flat;
xlabel('y (north)');
ylabel('z (alt.)');
title('J_y (north) uA/m^2');
colorbar;

subplot(337)
pcolor(x/1e3,y/1e3,squeeze(Jz(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('J_z (up) uA/m^2');
colorbar;

subplot(338);
pcolor(x/1e3,y/1e3,squeeze(Jx(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('J_x (east) uA/m^2');
colorbar;

subplot(339);
pcolor(x/1e3,y/1e3,squeeze(Jy(end/2,:,:))');
shading flat;
xlabel('x (east)');
ylabel('y (north)');
title('J_y (north) uA/m^2');
colorbar;
