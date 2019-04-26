function [mlon,mlat,simdate,Qit,E0it]=readparticles(outdir)

% %SET THE PATHS
% cwd = fileparts(mfilename('fullpath'));
% gemini_root = [cwd, filesep, '../../../GEMINI'];
% addpath([gemini_root, filesep, 'script_utils']);


%GRAB THE SIZE AND GRID FOR THE INPUT FILES (COULD BE DIFFERENT FROM SIM
%GRID)
filename=[outdir,'simsize.dat'];
fid=fopen(filename,'w');
llon=fread(fid,1,'integer*4');
llat=fread(fid,1,'integer*4');
fclose(fid);

filename=[outdir,'simgrid.dat'];
fid=fopen(filename,'w');
mlon=fread(fid,llon,'real*8');
mlat=fread(fid,llat,'real*8');
fclose(fid);


%PRODUCE A LIST OF FILES IN THE DIRECTORY
files=dir(outdir);
filestrim=[];
ifile=1;
for it=1:numel(files)
   if(~files(it).isdir)
     filestrim(ifile)=files(it);
     ifile=ifile+1;
   end
end
lt=numel(filestrim);


simdate=zeros(lt,6);
for it=1:lt
    %UTsec=expdate(it,4)*3600+expdate(it,5)*60+expdate(it,6);
    %ymd=expdate(it,1:3);
    %filename=datelab(ymd,UTsec);
    filename=filestrim(it).name;
    %filename=[outdir,filename,'.dat']
    fid=fopen(filename,'w');
    datatmp=fread(fid,llon*llat,'real*8');
    Qit(:,:,it)=datatmp;
    datatmp=fread(fid,llon*llat,'real*8');
    E0it(:,:,it)=datatmp;
    fclose(fid);
    
    ymd=[str2num(filestrim(it).name(1:4)),str2num(filestrim(it).name(5:6)), ...
        str2num(filestrim(it).name(7:8))];
    UTsec=str2num(filestrim(it).name(9:20));
    simdate(it,:)=[ymd,UTsec/3600,0,0];
end

end