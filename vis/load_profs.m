function [xg,neprof,Teprof,Tiprof,viprof,simdate] = load_profs(direc,xg)

validateattributes(direc, {'char'}, {'vector'}, mfilename, 'simulation top-level path', 1)
if nargin > 1
  validateattributes(xy, {'struct'}, {'scalar'}, mfilename, 'grid parameters', 2)
end

cwd = fileparts(mfilename('fullpath'));
gemini_root = [cwd,filesep,'../../gemini'];
addpath([gemini_root, filesep, 'script_utils'])
addpath([gemini_root, filesep, 'vis',filesep, 'plotfunctions'])
addpath([gemini_root, filesep, 'vis'])


%%READ IN THE SIMULATION INFORMATION
[ymd0,UTsec0,tdur,dtout,~,mloc]=readconfig([direc,filesep,'inputs/config.ini']);


%CHECK WHETHER WE NEED TO RELOAD THE GRID (WHICH CAN BE TIME CONSUMING)
if nargin < 2
  xg = readgrid([direc,filesep,'inputs',filesep]);
end


% COMPUTE SOURUCE LOCATION IN MCOORDS
if (~isempty(mloc))
 mlat=mloc(1);
 mlon=mloc(2);
else
 mlat=[];
 mlon=[];
end


%% TIMES OF INTEREST
times=UTsec0:dtout:UTsec0+tdur;
lt=numel(times);


%LOCATIONS OF THE FIELD ALIGNED PROFILES TO BE EXTRACTED
ix2=find(xg.x2(3:end-2)>0, 1 );
ix3=find(xg.x3(3:end-2)>0, 1 ) + floor(xg.lx(3)/8);
if isempty(ix3), ix3=1; end  % 2-D case


%ALLOCATE SPACE FOR TIME SERIES
neprof=zeros(xg.lx(1),lt);
Tiprof=zeros(xg.lx(1),lt);
Teprof=zeros(xg.lx(1),lt);
viprof=zeros(xg.lx(1),lt);


%MAIN TIME LOOP FOR LOADING AND EXTRACTING DATA OF INTEREST
ymd=ymd0;
UTsec=UTsec0;
simdate=[];
for it=1:lt
    simdate=cat(1,simdate,[ymd,UTsec/3600,0,0]);
    [ne,mlatsrc,mlonsrc,v1,Ti,Te,J1,v2,v3,J2,J3,filename,Phitop] = loadframe(direc,UTsec,ymd,UTsec0,ymd0,mloc,xg);
    disp(filename)

    neprof(:,it) = ne(:,ix2,ix3);
    Teprof(:,it) = Te(:,ix2,ix3);
    Tiprof(:,it) = Ti(:,ix2,ix3);
    viprof(:,it) = v1(:,ix2,ix3);
    
    [ymd,UTsec]=dateinc(dtout,ymd,UTsec);
end % for
    
    
end % function
