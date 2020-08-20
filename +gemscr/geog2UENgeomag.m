function [zUEN,xUEN,yUEN] = geog2UENgeomag(alt,glon,glat,mlonctr,mlatctr)

narginchk(5, 5)
% must also have center of the grid in mlat/mlon...

Re=6370e3;

%mag coords. of input grid points
[theta,phi] = gemini3d.geog2geomag(glat,glon);

meantheta=pi/2-mlatctr*pi/180;
meanphi=mlonctr*pi/180;

yUEN=-1*Re*(theta-meantheta);               %north dist. runs backward from zenith angle
xUEN=Re*sin(meantheta)*(phi-meanphi);       %some warping done here (using meantheta)
zUEN=alt;

end %function
