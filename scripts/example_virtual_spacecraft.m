%% This is a driver script to show how to use th virtual_spacecraft
% extraction utility on gemini output.

% imports
run("setup.m");

% input data
direc="~/simulations/arcs_angle_wide_nonuniform_large_highresx1/";

% Satellite track
load ~/Documents/proposals/ARCS/scraper/orbits.mat;

% call the tracker
track=gemscr.postprocess.virtual_spacecraft(direc,glonsat,glatsat,altsat,tsat);

% plot something
figure(1);
plot(tsat,track.visat);


%% some extra code I don't want to bulldoze yet...
%{
%DEFINE SOME SORT OF SATELLITE ORB.
%Use a common time bases for all satellites (facilitates processes without having to reread files too much)
lorb=3000;    %number of times series for satellite orbit
UTsat=linspace(min(times),max(times),lorb);
ymdsat=repmat(ymd0,[lorb,1]);
datevecsat=[ymdsat,UTsat(:)/3600,zeros(lorb,1),zeros(lorb,1)];
datesat=datenum(datevecsat);
%}

%{
%THIS IS A TEST FOR AETHER
vsp=7e3;                %spacecraft velocity
toffset=linspace(0,180,12);      %spacecraft separations in seconds
ltoffset=numel(toffset);
lsat=ltoffset;
ysp0=min(xg.x3(:));     %spacecraft reference point is the end of the grid in N-S
ysp=zeros(lorb,ltoffset);
for itoffset=1:ltoffset
  ysp(:,itoffset)=ysp0+vsp*((datesat-datesat(1))*86400-toffset(itoffset));
end
xsp=zeros(lorb,ltoffset);
zsp=400e3*ones(lorb,ltoffset);
[altsat,glonsat,glatsat]=UEN2geog(zsp,xsp,ysp,thetactr,phictr);
%}

%THIS IS A BASIC TWO SATELLITE TEST
%{
%Individual orbit alt,lon,lat
lsat=2;    %number of satellites
thetasat(:,1)=linspace(min(xg.theta(:)),max(xg.theta(:)),lorb);
phisat(:,1)=linspace(min(xg.phi(:)),max(xg.phi(:)),lorb);
altsat(:,1)=linspace(100e3,600e3,lorb);
thetasat(:,2)=flipud(thetasat(:,1));
phisat(:,2)=flipud(phisat(:,1));
altsat(:,2)=flipud(altsat(:,1));
glatsat=zeros(lorb,lsat);
glonsat=zeros(lorb,lsat);
for isat=1:lsat
  [glatsattmp,glonsattmp]=gemini3d.geomag2geog(thetasat(:,isat),phisat(:,isat));
  glatsat(:,isat)=glatsattmp(:);
  glonsat(:,isat)=glonsattmp(:);
end
%}
