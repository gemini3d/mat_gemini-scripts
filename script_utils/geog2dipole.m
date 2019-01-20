function [q,p,phi]=geog2dipole(alt,glon,glat)

addpath ../../GEMINI/script_utils;    %needs to be made more general

[theta,phi]=geog2geomag(glat,glon);
mlat=90-theta*180/pi;
mlon=phi*180/pi;

[q,p,phi]=geomag2dipole(alt,mlon,mlat);

end %function geog2dipole