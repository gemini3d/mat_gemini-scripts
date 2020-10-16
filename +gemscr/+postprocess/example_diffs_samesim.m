%SIMULATION LOCATION
direc1='~/simulations/ICI2_glow2/';


%DATE AND TIME OF INTEREST
time = datetime(2013,2,20) + seconds(18300);

%LOAD TWO FRAMES TO DIFF
dat1 = gemini3d.loadframe(direc1, "time", time);
dat2 = gemini3d.loadframe(direc1, "time", time - seconds(2));


%PLOT DIFF
pcolor(xg.x2(3:end-2), xg.x1(3:end-2), dat1.ne - dat2.ne);
shading flat;
colorbar;
xlabel('horiztonal distance (m)')
ylabel('altitude (m)');
title('n_e diffs for frames 2 s apart');
print -dpng -r300 ~/nediffs.png;
