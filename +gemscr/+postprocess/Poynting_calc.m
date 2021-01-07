function [E,B,S,mlon,mlat,datmag,datplasma,xg]=Poynting_calc(direc,TOI)

% read in a simulation frame (both plasma and magnetic fields are required for
% the specified frame) and compute the Poynting flux.  Return the electric,
% magnetic, and poynting flux fields on the grid used by magcalc.

% imports
import gemscr.postprocess.*;

% physical constants
mu0=4*pi*1e-7;
Re=6370e3;

% read in grid
xg=gemini3d.read.grid(direc);

% read in plasma
datplasma=gemini3d.read.frame(direc,"time",TOI);

% read in magnetic field, reorganize to use with MATLAB built-in
datmag=gemini3d.read.magframe(direc,"time",TOI);  % if h5 output then the gridsize is stored with the output data
B=cat(4,datmag.Br,datmag.Btheta,datmag.Bphi);     
% organized as:  up dependence, lon dep., lat dep., component

% Compute electric fields from velocities
[v,Emod]=gemscr.postprocess.Efield(xg,datplasma.v2,datplasma.v3);   
% Emod components and functional dependence is x1 (up),x2 (east),x3 (north)

% Rotate electric fields into geomagnetic spherical coordinates, note that
% we need to use unit vectors in the same basis.
Er=Emod(:,:,:,1).*dot(xg.e1,xg.er,4)+Emod(:,:,:,2).*dot(xg.e2,xg.er,4)+ ...
    Emod(:,:,:,3).*dot(xg.e3,xg.er,4);
Etheta=Emod(:,:,:,1).*dot(xg.e1,xg.etheta,4)+Emod(:,:,:,2).*dot(xg.e2,xg.etheta,4)+ ...
    Emod(:,:,:,3).*dot(xg.e3,xg.etheta,4);
Ephi=Emod(:,:,:,1).*dot(xg.e1,xg.ephi,4)+Emod(:,:,:,2).*dot(xg.e2,xg.ephi,4)+ ...
    Emod(:,:,:,3).*dot(xg.e3,xg.etheta,4);

% Grid electric fields onto the grid used for magnetic field computations
lalt=numel(datmag.r); llon=numel(datmag.mlon); llat=numel(datmag.mlat);
altlims=[min(datmag.r),max(datmag.r)]-Re;
mlonlims=[min(datmag.mlon),max(datmag.mlon)];
mlatlims=[min(datmag.mlat),max(datmag.mlat)];
[alti,mloni,mlati,Eri]=model2magcoords(xg,Er,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ethetai]=model2magcoords(xg,Etheta,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ephii]=model2magcoords(xg,Ephi,lalt,llon,llat,altlims,mlonlims,mlatlims);

% Group electric field components together so built-in fns. can be used
E=cat(4,permute(Eri,[1,3,2]),permute(Ethetai,[1,3,2]),permute(Ephii,[1,3,2]));

% Compute the Poynting flux
H=B/mu0;
S=cross(E,H,4);

% Store coordinates in output arguments
mlon=datmag.mlon;
mlat=datmag.mlat;

end %Poynting_calc