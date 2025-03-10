% Compute the Poynting flux from a single frame and compare it against
% dissipation
%
% from mat_gemini-script directory run
%    buildtool setup

% simulation location, date, and time
simname='arcs_angle_wide_nonuniform_large_highresx1/';
basedir='~/simulations/';
direc=[basedir,simname];
ymd=[2017,3,2];
UTsec=27285;
TOI=datetime([ymd,0,0,UTsec]);

% call the Poynting flux utility function
[E,B,S,mlon,mlat]=gemscr.postprocess.Poynting_calc(direc,TOI);

% plots
figure;
subplot(131);
imagesc(mlon,mlat,squeeze(S(1,:,:,1))*1e3);
axis xy;
xlabel("mag. lon. (deg.)");
ylabel("mag. lat. (deg.)");
c=colorbar;
cax=clim;
caxval=max(abs(cax));
clim([-caxval,caxval]);
ylabel(c,"Poynting Flux (mW/m^2)");
title("S_1");

subplot(132);
imagesc(mlon,mlat,squeeze(S(1,:,:,2))*1e3);
axis xy;
xlabel("mag. lon. (deg.)");
ylabel("mag. lat. (deg.)");
c=colorbar;
clim([-caxval,caxval]);
ylabel(c,"Poynting Flux (mW/m^2)");
title("S_2");

subplot(133);
imagesc(mlon,mlat,squeeze(S(1,:,:,3))*1e3);
axis xy;
xlabel("mag. lon. (deg.)");
ylabel("mag. lat. (deg.)");
c=colorbar;
clim([-caxval,caxval]);
ylabel(c,"Poynting Flux (mW/m^2)");
title("S_3");
