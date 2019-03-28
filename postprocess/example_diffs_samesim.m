addpath ~/Projects/GEMINI/vis;

direc1='~/simulations/ICI2_glow2/';



ymd=[2013,02,20];
UTsec=18300;
[ne1,mlatsrc,mlonsrc,xg,v1,Ti,Te1,J1,v2,v3,J2,J3,filename,Phitop1,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec);
[ne2,mlatsrc,mlonsrc,xg,v1,Ti,Te2,J1,v2,v3,J2,J3,filename,Phitop1,ns,vs1,Ts] = loadframe(direc1,ymd,UTsec-2);
