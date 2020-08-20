%% Simulations
direc='../../simulations/KHI_Andres/'
direc2='../../simulations/KHI_Andres_ne/'
mkdir(direc2);


%% NEED TO READ INPUT FILE TO GET DURATION OF SIMULATION AND START TIME
cfg = gemini3d.read_config(direc);


%% CHECK WHETHER WE NEED TO RELOAD THE GRID (check if one is given because this can take a long time)
%if isempty(xg)
  disp('Reloading grid...')
  xg = gemini3d.readgrid(direc);
%end


%% TIMES OF INTEREST
times=UTsec0:dtout:UTsec0+tdur;
lt=numel(times);
%UTsec=UTsec0;
UTsec=29329;
ymd=ymd0;
for it=1:lt
  %load data for this frame
  dat = gemini3d.vis.loadframe(direc,ymd,UTsec);

  %deflate down to just the density
  dmy=[ymd(3),ymd(2),ymd(1)]
  direc2,filename
  fid=fopen([direc2,'/',filename],'w');
  fwrite(fid,dmy,'real*8');
  fwrite(fid,UTsec,'real*8');
  fwrite(fid,ne,'real*8');
  fclose(fid);

  [ymd,UTsec]= gemini3d.dateinc(dtout,ymd,UTsec);
end %for
