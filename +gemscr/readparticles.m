function [mlon,mlat,simdate,Qit,E0it] = readparticles(outdir)
%% READ IN THE CONFIG FILE FOR A PARTICULAR RUN
narginchk(1,1)


%% GRAB THE SIZE AND GRID FOR THE INPUT FILES (COULD BE DIFFERENT FROM SIM
%GRID)
filename = fullfile(outdir,'simsize.dat');
fid=fopen(filename,'r');
llon=fread(fid,1,'integer*4');
llat=fread(fid,1,'integer*4');
fclose(fid);

filename= fullfile(outdir,'simgrid.dat');
fid=fopen(filename,'r');
mlon=fread(fid,llon,'real*8');
mlat=fread(fid,llat,'real*8');
fclose(fid);


%% PRODUCE A LIST OF FILES IN THE DIRECTORY
files=dir(outdir);
ifile=1;
for it=1:numel(files)
   if ~files(it).isdir && ...
       ~strcmp(files(it).name,'simsize.dat') && ...
       ~strcmp(files(it).name,'simgrid.dat') && ...
       ~strcmp(files(it).name,'particles.mat')
     filestrim(ifile)=files(it);
     ifile=ifile+1;
   end
end
lt=numel(filestrim);


simdate=zeros(lt,6);
for it=1:lt
    filename=filestrim(it).name;
    fid=fopen(fullfile(outdir,filename), 'r');
    datatmp=fread(fid,llon*llat,'real*8');
    Qit(:,:,it)=reshape(datatmp,[llon,llat]);
    datatmp=fread(fid,llon*llat,'real*8');
    E0it(:,:,it)=reshape(datatmp,[llon,llat]);
    fclose(fid);

    ymd=[str2num(filestrim(it).name(1:4)),str2num(filestrim(it).name(5:6)), ...
        str2num(filestrim(it).name(7:8))];
    UTsec=str2num(filestrim(it).name(10:21));
    simdate(it,:)=[ymd,UTsec/3600,0,0];
end

end
