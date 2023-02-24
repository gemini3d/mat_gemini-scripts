%% Read and organize simulation data
% load mat_gemini
run("~/Projects/mat_gemini/setup.m")
run("~/Projects/mat_gemini-scripts/setup.m")

% simulation location
simname='/arcs_highres/';
basedir='~/simulations/';
direc=[basedir,simname];

% Time of interest
cfg = gemini3d.read.config(direc);    % config file
TOI=cfg.times(6);
xg = gemini3d.read.grid(direc);    % grid structure

% Read in simulation data
dat=gemini3d.read.frame(direc,time=TOI);

% Conductivities and conductances
disp("Computing conductivities and conductance...");
[sigP,sigH,sig0,SIGP,SIGH,incap,INCAP]=gemscr.postprocess.conductivity_reconstruct(TOI,dat,cfg,xg);   % Conductivities on the simulation grid

% Get the electric fields
disp("Computing Ohmic dissipation...");
[v,E]=gemscr.postprocess.Efield(xg,dat.v2,dat.v3);   % fields, etc. on the simulation grid


%% Calculate energy source terms for neutral gas
% Compute the Joule dissipation and do a quick sanity check.  Cf. appendix
% B of St. Maurice and Schunk, 1981; here we assume that the neutrals ar
% not drifting so the electric field in the Earth-fixed frame is the same
% as the field in the neutral frame (E' in their paper).  
E2=squeeze(E(:,:,:,2)); E3=squeeze(E(:,:,:,3));
%ohmicdissipation=sigP.*(E2.^2+E3.^2);
jouleheating=dat.J2.*E2 + dat.J3.*E3;
%errorjoule=jouleheating-ohmicdissipation;


%% Calculate momentum source terms for the neutral gas
% Also from the same paper eq. A4 shows the momentum source term, which may
% be computed from collision frequencies etc.  
disp("Recompute neutrals...");
params=cfg;
params.msis_infile="/tmp/msis_input.h5";
params.msis_outfile="/tmp/msis_output.h5";
natm= gemini3d.model.msis(params,xg,TOI);

% constants
%kb=1.3806503e-23;
elchrg=1.60217646e-19;
amu=1.66053886e-27;
ms=[16,30,28,32,14,1,9.1e-31/amu]*amu;
%gammas=[5/3,7/5,7/5,7/5,5/3,5/3,5/3];
qs=[1,1,1,1,1,1,-1]*elchrg;

% ion collision frequencies
disp("Recompute collision frequencies...");
[nusn,nus,nusj,nuss,Phisj,Psisj]= gemscr.postprocess.collisions3D(natm,dat.Ts,dat.ns,dat.vs1,ms);

% neutral collision frequencies (cf. Schunk and Nagy 2010).  The
% calculation here is a bit superfluous but I wanted to illustrate how all
% of the different collision terms appearing in the various equations are
% related.  
disp("Computing body force...");
[lx1,lx2,lx3,lsp]=size(dat.ns);
rhos=zeros(lx1,lx2,lx3);    % aggregate plasma mass density
for isp=1:lsp-1
  rhos=rhos+dat.ns(:,:,:,isp)*ms(isp);
end %for
rhon=natm.nN2*28*amu+natm.nO2*32*amu+natm.nO*16*amu;   % aggregate neutral gas mass density
nun=rhos./rhon.*sum(nus(:,:,:,1:lsp-1),4);     % use collisions/sec across all ion species for neutral collision rate
bodyforce=zeros(lx1,lx2,lx3,3);
bodyforce(:,:,:,1)=rhon.*nun.*(dat.vs1(:,:,:,end));    % approximate aggregate drift from electron motion
bodyforce(:,:,:,2)=rhon.*nun.*(dat.v2(:,:,:,end));    % approximate aggregate drift from electron motion
bodyforce(:,:,:,3)=rhon.*nun.*(dat.v3(:,:,:,end));    % approximate aggregate drift from electron motion

z=squeeze(xg.x1(3:end-2));
x=squeeze(xg.x2(3:end-2));
y=squeeze(xg.x3(3:end-2)); 
bfmag=sqrt(bodyforce(:,:,:,1).^2 + bodyforce(:,:,:,2).^2 + bodyforce(:,:,:,3).^2);


%% Make some plots to check things
% figure(1);
% subplot(131);
% pcolor(x,z,jouleheating(:,:,end/2));
% colorbar;
% shading flat;
% subplot(132);
% pcolor(y,z,squeeze(jouleheating(:,end/2,:)));
% colorbar;
% shading flat;
% subplot(133);
% pcolor(x,y,squeeze(jouleheating(floor(end/2),:,:))');
% colorbar;
% shading flat;
% 
% figure(2);
% subplot(431);
% pcolor(x,z,bfmag(:,:,end/2));
% colorbar;
% shading flat;
% subplot(432);
% pcolor(y,z,squeeze(bfmag(:,end/2,:)));
% colorbar;
% shading flat;
% subplot(433);
% pcolor(x,y,squeeze(bfmag(floor(end/2),:,:))');
% colorbar;
% shading flat;
% 
% subplot(434);
% pcolor(x,z,bodyforce(:,:,end/2,1));
% colorbar;
% shading flat;
% subplot(435);
% pcolor(y,z,squeeze(bodyforce(:,end/2,:,1)));
% colorbar;
% shading flat;
% subplot(436);
% pcolor(x,y,squeeze(bodyforce(floor(end/2),:,:,1))');
% colorbar;
% shading flat;
% 
% subplot(437);
% pcolor(x,z,bodyforce(:,:,end/2,2));
% colorbar;
% shading flat;
% subplot(438);
% pcolor(y,z,squeeze(bodyforce(:,end/2,:,2)));
% colorbar;
% shading flat;
% subplot(439);
% pcolor(x,y,squeeze(bodyforce(floor(end/2),:,:,2))');
% colorbar;
% shading flat;
% 
% subplot(4,3,10);
% pcolor(x,z,bodyforce(:,:,end/2,3));
% colorbar;
% shading flat;
% subplot(4,3,11);
% pcolor(y,z,squeeze(bodyforce(:,end/2,:,3)));
% colorbar;
% shading flat;
% subplot(4,3,12);
% pcolor(x,y,squeeze(bodyforce(floor(end/2),:,:,3))');
% colorbar;
% shading flat;


%% Make a separate plot of specific energy and acceleration of neutral gas
specen=jouleheating./rhon;

figure("Name","Energy dissipation [J/kg-s]");
subplot(131);
pcolor(x,z,specen(:,:,end/2));
xlabel("east");
ylabel("alt.");
colorbar;
shading flat;
subplot(132);
pcolor(y,z,squeeze(specen(:,end/2,:)));
xlabel("north")
ylabel("alt.")
colorbar;
shading flat;
subplot(133);
pcolor(x,y,squeeze(specen(floor(end/2),:,:))');
xlabel("east")
ylabel("north")
colorbar;
shading flat;

acc=zeros(lx1,lx2,lx3,3);
for idim=1:3
  acc(:,:,:,idim)=bodyforce(:,:,:,idim)./rhon(:,:,:);
end %for
accmag=sqrt(acc(:,:,:,1).^2 + acc(:,:,:,2).^2 + acc(:,:,:,3).^2);

figure("Name","Acceleration [m/s^2]");
subplot(431);
pcolor(x,z,accmag(:,:,end/2));
xlabel("east");
ylabel("alt.");
colorbar;
shading flat;
subplot(432);
pcolor(y,z,squeeze(accmag(:,end/2,:)));
xlabel("north")
ylabel("alt.")
colorbar;
shading flat;
subplot(433);
pcolor(x,y,squeeze(accmag(floor(end/2),:,:))');
xlabel("east")
ylabel("north")
colorbar;
shading flat;

subplot(434);
pcolor(x,z,acc(:,:,end/2,1));
xlabel("east");
ylabel("alt.");
colorbar;
shading flat;
subplot(435);
pcolor(y,z,squeeze(acc(:,end/2,:,1)));
xlabel("north")
ylabel("alt.")
colorbar;
shading flat;
subplot(436);
pcolor(x,y,squeeze(acc(floor(end/2),:,:,1))');
xlabel("east")
ylabel("north")
colorbar;
shading flat;

subplot(437);
pcolor(x,z,acc(:,:,end/2,2));
xlabel("east");
ylabel("alt.");
colorbar;
shading flat;
subplot(438);
pcolor(y,z,squeeze(acc(:,end/2,:,2)));
xlabel("north")
ylabel("alt.")
colorbar;
shading flat;
subplot(439);
pcolor(x,y,squeeze(acc(floor(end/2),:,:,2))');
xlabel("east")
ylabel("north")
colorbar;
shading flat;

subplot(4,3,10);
pcolor(x,z,acc(:,:,end/2,3));
xlabel("east");
ylabel("alt.");
colorbar;
shading flat;
subplot(4,3,11);
pcolor(y,z,squeeze(acc(:,end/2,:,3)));
xlabel("north")
ylabel("alt.")
colorbar;
shading flat;
subplot(4,3,12);
pcolor(x,y,squeeze(acc(floor(end/2),:,:,3))');
xlabel("east")
ylabel("north")
colorbar;
shading flat;
