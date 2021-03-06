function [sigP,sigH,sig0,SIGP,SIGH,incap,INCAP]=conductivity_reconstruct(time,dat,cfg, xg)

% Compute conductivity and conductance from output simluation data.
% Requires a call to MSIS and some assumes about ion composition which do
% not tend to affect computed values overmuch.

narginchk(4,4)
validateattributes(time, {'datetime'}, {'scalar'}, 1)
validateattributes(dat, {'struct'}, {'scalar'}, 2)
validateattributes(cfg, {'struct'}, {'scalar'}, 3)
validateattributes(xg, {'struct'}, {'scalar'}, 4)

%% GET THE NEUTRAL ATMOSPHERE NEEDED FOR COLLISIONS, ETC.
%params.activ = cfg.activ;
params=cfg;
params.msis_infile="/tmp/msis_input.h5";
params.msis_outfile="/tmp/msis_output.h5";
natm= gemini3d.model.msis(params,xg,time);

%% MASS AND CHARGE VARIABLES DESCRIBING SPECIES (needed to recompute the collision freqs.) - this is a little messy maybe have some global script that sets???
%kb=1.3806503e-23;
elchrg=1.60217646e-19;
amu=1.66053886e-27;
ms=[16,30,28,32,14,1,9.1e-31/amu]*amu;
%gammas=[5/3,7/5,7/5,7/5,5/3,5/3,5/3];
qs=[1,1,1,1,1,1,-1]*elchrg;

%% DEFINE A COMPOSITION OF THE PLASMA - THIS ACTUALLY DOESN'T MUCH IMPACT THE CONDUCTIVITY
p=1/2+1/2*tanh((xg.alt-220e3)/20e3);
ns=zeros(xg.lx(1),xg.lx(2),xg.lx(3),7);
ns(:,:,:,1)=p .* dat.ne;
nmolc=(1-p) .* dat.ne;
ns(:,:,:,2)=1/3*nmolc;
ns(:,:,:,3)=1/3*nmolc;
ns(:,:,:,4)=1/3*nmolc;
ns(:,:,:,7)= dat.ne;               %if you don't separately assign electron density the hall and parallel terms are wrong

Ts(:,:,:,1:6)=repmat(dat.Ti,[1,1,1,6]);
Ts(:,:,:,7)= dat.Te;
vs1=repmat(dat.v1,[1 1 1 7]);


%% NEED TO CREATE A FULL IONOSPHERIC OUT OF A PARTIAL CALCULATION
[nusn,nus,nusj,nuss,Phisj,Psisj]= gemscr.postprocess.collisions3D(natm,Ts,ns,vs1,ms);
%B=abs(xg.Bmag);                                                         %need to check whether abs is okay here...
B=xg.Bmag;                                                               %carries to sign of B1...
[muP,muH,mu0,sigP,sigH,sig0,incap]= gemscr.postprocess.conductivities3D(nus,nusj,ns,ms,qs,B);


%% COMPUTE THE INTEGRATED CONDUCTANCES
h1=xg.h1(3:end-2,3:end-2,3:end-2);                                      %trim off ghost cells
dx1=xg.dx1b(2:end-2);
dx1=dx1(:);
dl1=h1.*repmat(dx1,[1,xg.lx(2),xg.lx(3)]);                              %differential length along geomagnetic field lines
l1=cumsum(dl1);

SIGP=zeros(xg.lx(2),xg.lx(3));
SIGH=zeros(xg.lx(2),xg.lx(3));
INCAP=zeros(xg.lx(2),xg.lx(3));
for ix2=1:xg.lx(2)
    for ix3=1:xg.lx(3)
        SIGP(ix2,ix3)=trapz(l1(:,ix2,ix3),sigP(:,ix2,ix3),1);
        SIGH(ix2,ix3)=trapz(l1(:,ix2,ix3),sigH(:,ix2,ix3),1);
        INCAP(ix2,ix3)=trapz(l1(:,ix2,ix3),incap(:,ix2,ix3),1);
    end %for
end %for

end %function conductivity_reconstruct
