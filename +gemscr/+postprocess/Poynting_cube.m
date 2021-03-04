
% Look at Poynting flux calculations through various surfaces of the
% simulation "cube"

% Input sim. and time, load and process Poynting vector
if (~exist("S","var"))
    direc="~/simulations/arcs_angle_wide_nonuniform_large_highresx1/";
    TOI=datetime([2017,3,2,0,0,27285]);
    [E,B,S,mlon,mlat,datmag,datplasma,xg]=gemscr.postprocess.Poynting_calc(direc,TOI);
    alt=(datmag.r-6370e3)/1e3;
end %if

% Plot flux through all six cube surfaces

% x1 slices
figure(1);
subplot(331);
imagesc(mlon,mlat,squeeze(S(end,:,:,1)));
xlabel("mlon");
ylabel("mlat");
title("end boundary S_1");
axis xy;
colorbar;

subplot(332);
imagesc(mlon,mlat,squeeze(S(1,:,:,1)));
xlabel("mlon");
ylabel("mlat");
title("beginning boundary S_1");
axis xy;
colorbar;

subplot(333);
imagesc(mlon,mlat,squeeze(S(1,:,:,1))-squeeze(S(end,:,:,1)));
xlabel("mlon");
ylabel("mlat");
title("\Delta S_1");
axis xy;
colorbar;

% x2 slices
subplot(334);
imagesc(mlon,alt,squeeze(S(:,end,:,2)));
xlabel("mlon");
ylabel("alt");
title("end boundary S_2");
axis xy;
colorbar;

subplot(335);
imagesc(mlon,alt,squeeze(S(:,1,:,2)));
xlabel("mlon");
ylabel("alt");
title("beginning boundary S_2");
axis xy;
colorbar;

subplot(336);
imagesc(mlon,alt,squeeze(S(:,1,:,2))-squeeze(S(:,end,:,2)));
xlabel("mlon");
ylabel("alt");
title("\Delta S_2");
axis xy;
colorbar;

% x3 slices
subplot(337);
imagesc(mlat,alt,squeeze(S(:,:,end,2)));
xlabel("mlat");
ylabel("alt");
title("end boundary S_3");
axis xy;
colorbar;

subplot(338);
imagesc(mlat,alt,squeeze(S(:,:,1,2)));
xlabel("mlat");
ylabel("alt");
title("beginning boundary S_3");
axis xy;
colorbar;

subplot(339);
imagesc(mlat,alt,squeeze(S(:,:,1,2))-squeeze(S(:,:,end,2)));
xlabel("mlat");
ylabel("alt");
title("\Delta S_3");
axis xy;
colorbar;
