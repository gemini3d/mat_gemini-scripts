function [E,B,S,mloni,mlati,datmag,datplasma,xg]=Poynting_calc(direc,TOI,lalt,llon,llat)

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
%B=cat(4,datmag.Br,datmag.Btheta,datmag.Bphi);     
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
    Emod(:,:,:,3).*dot(xg.e3,xg.ephi,4);

% Grid electric fields uniformly using the extents of the magnetic field
% computation grid.  This may not do a great job if the source grid is
% very nonuniform.
if ~exist("lalt","var")
    lalt=numel(datmag.r); llon=numel(datmag.mlon); llat=numel(datmag.mlat);
end %if
altlims=[min(datmag.r),max(datmag.r)]-Re;
mlonlims=[min(datmag.mlon),max(datmag.mlon)];
mlatlims=[min(datmag.mlat),max(datmag.mlat)];
[alti,mloni,mlati,Eri]=model2magcoords(xg,Er,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ethetai]=model2magcoords(xg,Etheta,lalt,llon,llat,altlims,mlonlims,mlatlims);
[~,~,~,Ephii]=model2magcoords(xg,Ephi,lalt,llon,llat,altlims,mlonlims,mlatlims);

% Group electric field components together so built-in fns. can be used
%  These are permuted x1,x2,x3 -> r,theta,phi
E=cat(4,permute(Eri,[1,3,2]),permute(Ethetai,[1,3,2]),permute(Ephii,[1,3,2]));

%  In the even the magnetic field points have been nonuniformly spaced,
%  sample it uniformly, as well using the same grid as used for the
%  electric field.  Two different situations need to be handled here.  2D
%  and 3D have to be handled differently.
if (lalt==1)
    [MLONI,MLATI]=meshgrid(mloni(:),mlati(:));
    Bri=interp2(datmag.mlon,datmag.mlat,squeeze(datmag.Br),MLONI(:),MLATI(:));
    Bri=reshape(Bri,[1,llon,llat]);
    Bthetai=interp2(datmag.mlon,datmag.mlat,squeeze(datmag.Btheta),MLONI(:),MLATI(:));
    Bthetai=reshape(Bthetai,[1,llon,llat]);
    Bphii=interp2(datmag.mlon,datmag.mlat,squeeze(datmag.Bphi),MLONI(:),MLATI(:));
    Bphii=reshape(Bphii,[1,llon,llat]);
else
    [MLONI,ALTI,MLATI]=meshgrid(mloni(:),alti(:),mlati(:));
    Bri=interp3(datmag.r-Re,datmag.mlon,datmag.mlat,datmag.Br,ALTI(:),MLONI(:),MLATI(:));
    Bthetai=interp3(datmag.r-Re,datmag.mlon,datmag.mlat,datmag.Btheta,ALTI(:),MLONI(:),MLATI(:));
    Bphii=interp3(datmag.r-Re,datmag.mlon,datmag.mlat,datmag.Bphi,ALTI(:),MLONI(:),MLATI(:));
end %if
B=cat(4,Bri,Bthetai,Bphii);

% Compute the Poynting flux
H=B/mu0;
S=cross(E,H,4);

end %Poynting_calc