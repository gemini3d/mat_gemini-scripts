%% Load a GDI simulation
direc='~/simulations/GDI_periodic_lowres_tmp4/';
xg=readgrid([direc,'/inputs/']);
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc,activ,indat_size,indat_grid,indat_file] = readconfig([direc,'/inputs/']);


%% Pick a reference point to extract a line of density
x2=xg.x2;
ix1=min(find(xg.x1>300e3))-2;    %F-region location in terms of grid index
x2ref=-85e3;


%% Loop over data and pull in the density for main part of gradient
neline=[];
t=0;
it=1;
UTsec=UTsec0;
ymd=ymd0;
while (t<=tdur)
    data=loadframe(direc,ymd,UTsec);
    x2now=x2ref+t*1e3    %moving at 1 kms/
    ix2=min(find(x2>x2now))-2;
    neline(it,:)=squeeze(data.ne(ix1,ix2,:));
    
    t=t+dtout;
    it=it+1;
    [ymd,UTsec]=dateinc(dtout,ymd,UTsec);
end %while

