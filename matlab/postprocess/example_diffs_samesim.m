addpath ~/Projects/GEMINI/vis;


%SIMULATION LOCATION
direc1='~/simulations/ICI2_glow2/';


%DATE AND TIME OF INTEREST
ymd=[2013,02,20];
UTsec=18300;


%LOAD TWO FRAMES TO DIFF
[ne1,mlatsrc,mlonsrc,xg,v1,Ti,Te1,J1,v2,v3,J2,J3,filename,Phitop1,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec);
[ne2,mlatsrc,mlonsrc,xg,v1,Ti,Te2,J1,v2,v3,J2,J3,filename,Phitop1,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec-2);


%PLOT DIFF
pcolor(xg.x2(3:end-2),xg.x1(3:end-2),ne1-ne2);
shading flat;
colorbar;
xlabel('horiztonal distance (m)')
ylabel('altitude (m)');
title('n_e diffs for frames 2 s apart');
print -dpng -r300 ~/nediffs.png;
