%% Load data from Rob and compute sizes
addpath ../script_utils/
load ~/SDHCcard/isinglass_clayton/clayton1_step_smooth7.mat;
[lt,lx,ly]=size(outx);
Re=6370e3;


%% Loop over dataset and compute a line integral from the bottom left corner to each grid point
Phi=zeros(lx,ly,lt);              %storage space for electric potential
Exclean=zeros(lx,ly,lt);          %cleaned electric field (curl free)
Eyclean=zeros(lx,ly,lt);
for it=1:lt
    mlon=squeeze(outx(it,:,:));
    mlat=squeeze(outy(it,:,:));
    alt=zeros(lx,ly);
    
    % Clean the data of any residual curl
    [zUEN,xUEN,yUEN]=geomag2UENgeomag(alt,mlon,mlat);
    x=xUEN(:,1);
    y=yUEN(1,:);
    Ex=squeeze(outu(it,:,:));
    Ey=squeeze(outv(it,:,:));
    Phinow=zeros(lx,ly);
    for iy=1:ly      %ix=iy=1 point assumed grounded
        for ix=1:lx
            if (ix==1 && iy==1)
                Phinow(ix,iy)=0;
            else
                if (ix>1)
                    Phinow(ix,iy)=trapz(x(1:ix),-1*Ex(1:ix,1));                %integrate along x part of path
                end %if
                if (iy>1)
                    Phinow(ix,iy)=Phinow(ix,iy)+trapz(y(1:iy),-1*Ey(ix,1:iy));    %now integrate in y
                end %if
            end %if
        end %for
    end %for
    [Eycleannow,Excleannow]=gradient(-1*Phinow,y,x);                   %note backwardness of array dims...
    Exclean(:,:,it)=Excleannow;
    Eyclean(:,:,it)=Eycleannow;
    Phi(:,:,it)=Phinow;
    
    % Test for residual curl;
    curlE=curl(x,y,Ex',Ey');
    curlEnow=curl(x,y,Excleannow',Eycleannow');
    disp('Old max curl:  ');
    disp(max(abs(curlE(:))));
    disp('Max curl of cleaned data:  ');    
    disp(max(abs(curlEnow(:))));
    
    figure(1);
    clf;
    subplot(221)
    imagesc(x,y,Excleannow');
    axis xy;
    colorbar;
    caxx=caxis;
    
    subplot(222)
    imagesc(x,y,Eycleannow');
    axis xy;
    colorbar;
    caxy=caxis;
    
    subplot(223)
    imagesc(x,y,Ex');
    axis xy;
    colorbar;
    caxis(caxx);
    
    subplot(224)
    imagesc(x,y,Ey');
    axis xy;
    colorbar;
    caxis(caxy);
    
    pause(0.01);
end %for


rmpath ../script_utils;