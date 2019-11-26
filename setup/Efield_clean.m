%% Load data from Rob and compute sizes
addpath ../script_utils/
load ~/SDHCcard/isinglass_clayton/clayton5_step_smooth7.mat;
[lt,lx,ly]=size(outx);
Re=6370e3;


%% Choose a reference point on the grid for zero potential
ix0=floor(lx/2);
iy0=floor(ly/2);


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
    Phinow2=zeros(lx,ly);
    for iy=1:ly      %ix=iy=1 point assumed grounded
        for ix=1:lx
            if (ix==ix0 && iy==iy0)
                fprintf('Center point %d %d grounded\n',ix,iy);
                Phi(ix,iy)=0;
            else
                % integrate x then y
                if (ix<ix0)
                   inds=ix:ix0;
                   dirfact=1;
                else
                   inds=ix0:ix;
                   dirfact=-1;
                end %if
                xhere=x(inds);
                Exhere=Ex(inds,iy0);
                if (numel(inds)>1)
                    Phinow(ix,iy)=trapz(xhere,dirfact*Exhere);
                end
                
                if (iy<iy0)
                    inds=iy:iy0;
                    dirfact=1;
                else
                    inds=iy0:iy;
                    dirfact=-1;
                end %if
                yhere=y(inds);
                Eyhere=Ey(ix,inds);
                if (numel(inds)>1)
                    Phinow(ix,iy)=Phinow(ix,iy)+trapz(yhere,dirfact*Eyhere);
                end
                
                %integrate y then x
                if (iy<iy0)
                    inds=iy:iy0;
                    dirfact=1;
                else
                    inds=iy0:iy;
                    dirfact=-1;
                end %if
                yhere=y(inds);
                Eyhere=Ey(ix0,inds);
                if (numel(inds)>1)
                    Phinow2(ix,iy)=trapz(yhere,dirfact*Eyhere);
                end
                if (ix<ix0)
                   inds=ix:ix0;
                   dirfact=1;
                else
                   inds=ix0:ix;
                   dirfact=-1;
                end %if
                xhere=x(inds);
                Exhere=Ex(inds,iy);
                if (numel(inds)>1)
                    Phinow2(ix,iy)=Phinow2(ix,iy)+trapz(xhere,dirfact*Exhere);
                end
            end %if
            
%             if (ix==1 && iy==1)
%                 Phinow(ix,iy)=0;
%             else
% Integrate x then y
%                if (ix>1)
%                    Phinow(ix,iy)=trapz(x(1:ix),-1*Ex(1:ix,1));                %integrate along x part of path
%                end %if
%                if (iy>1)
%                    Phinow(ix,iy)=Phinow(ix,iy)+trapz(y(1:iy),-1*Ey(ix,1:iy));    %now integrate in y
%                end %if
% Integrate y then x
%                 if (iy>1)
%                     Phinow(ix,iy)=trapz(y(1:iy),-1*Ey(1,1:iy));                   %integrate along x part of path
%                 end %if
%                 if (ix>1)
%                     Phinow(ix,iy)=Phinow(ix,iy)+trapz(x(1:ix),-1*Ex(1:ix,iy));    %now integrate in y
%                 end %if
%            end %if
        end %for
    end %for
    [~,Excleannow]=gradient(-1*(Phinow2),y,x);                   %note backwardness of array dims...
    [Eycleannow,~]=gradient(-1*(Phinow),y,x);    
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
    title('E_x cleaned');
    caxx=caxis;
    
    subplot(222)
    imagesc(x,y,Eycleannow');
    axis xy;
    colorbar;
    title('E_y cleaned');
    caxy=caxis;
    
    subplot(223)
    imagesc(x,y,Ex');
    axis xy;
    colorbar;
    title('E_x original');
    caxis(caxx);
    
    subplot(224)
    imagesc(x,y,Ey');
    axis xy;
    colorbar;
    title('E_y original');
    caxis(caxy);
    
    pause(0.01);
end %for


rmpath ../script_utils;