%% Load data from Rob and compute sizes
addpath ../script_utils/;
addpath ../../GEMINI/script_utils;
direc='~/SDHCcard/isinglass_clayton/';
load([direc,'clayton5_step_smooth7.mat']);
mkdir([direc,'/plots/']);
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
    x0=x(ix0);
    y0=y(iy0);
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
                %find a line connected present point to reference point
                xhere=x(ix);
                yhere=y(iy);
                
                %x-y pairs for line integration
                xline=linspace(x0,xhere,32);
                if (abs(xline(2)-xline(1))<0.1)    %degenerate slope
                    slope=0;
                    yline=linspace(y0,yhere,32);
                else
                    slope=(yhere-y0)/(xhere-x0);
                    yline=y0+slope*(xline-x0);
                end %if
                
                %interpolate electric field data to this line
                Exline=interp2(x,y,Ex',xline,yline);     %transpose to deal with x,y->y,x matlab weirdness
                Exline=Exline';
                Eyline=interp2(x,y,Ey',xline,yline);
                Eylin=Eyline';                
                
                %perform integral
                Phinow(ix,iy)=-1*trapz(xline,Exline)-trapz(yline,Eyline);
            end %if
                
%                 % integrate x then y
%                 if (ix<ix0)
%                    inds=ix:ix0;
%                    dirfact=1;
%                 else
%                    inds=ix0:ix;
%                    dirfact=-1;
%                 end %if
%                 xhere=x(inds);
%                 Exhere=Ex(inds,iy0);
%                 if (numel(inds)>1)
%                     Phinow(ix,iy)=trapz(xhere,dirfact*Exhere);
%                 end
%                 
%                 if (iy<iy0)
%                     inds=iy:iy0;
%                     dirfact=1;
%                 else
%                     inds=iy0:iy;
%                     dirfact=-1;
%                 end %if
%                 yhere=y(inds);
%                 Eyhere=Ey(ix,inds);
%                 if (numel(inds)>1)
%                     Phinow(ix,iy)=Phinow(ix,iy)+trapz(yhere,dirfact*Eyhere);
%                 end
%                 
%                 %integrate y then x
%                 if (iy<iy0)
%                     inds=iy:iy0;
%                     dirfact=1;
%                 else
%                     inds=iy0:iy;
%                     dirfact=-1;
%                 end %if
%                 yhere=y(inds);
%                 Eyhere=Ey(ix0,inds);
%                 if (numel(inds)>1)
%                     Phinow2(ix,iy)=trapz(yhere,dirfact*Eyhere);
%                 end
%                 if (ix<ix0)
%                    inds=ix:ix0;
%                    dirfact=1;
%                 else
%                    inds=ix0:ix;
%                    dirfact=-1;
%                 end %if
%                 xhere=x(inds);
%                 Exhere=Ex(inds,iy);
%                 if (numel(inds)>1)
%                     Phinow2(ix,iy)=Phinow2(ix,iy)+trapz(xhere,dirfact*Exhere);
%                 end
%             end %if
            
            
            
            
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
%    [~,Excleannow]=gradient(-1*(Phinow2),y,x);                   %note backwardness of array dims...
%    [Eycleannow,~]=gradient(-1*(Phinow),y,x);    
    [Eycleannow,Excleannow]=gradient(-1*(Phinow),y,x);  
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
    title(sprintf('E_x cleaned: %f',outt(it)));
    xlabel('E');
    ylabel('N');
    caxx=caxis;
    
    subplot(222)
    imagesc(x,y,Eycleannow');
    axis xy;
    colorbar;
    title('E_y cleaned');
    xlabel('E');
    ylabel('N');
    caxy=caxis;
    
    subplot(223)
    imagesc(x,y,Ex');
    axis xy;
    colorbar;
    title('E_x original');
    xlabel('E');
    ylabel('N');
    caxis(caxx);
    
    subplot(224)
    imagesc(x,y,Ey');
    axis xy;
    colorbar;
    title('E_y original');
    xlabel('E');
    ylabel('N');
    caxis(caxy);
    
    ymd=[2017,3,2];
    UTsec=outt(it)*3600;
    filestr=datelab(ymd,UTsec);
    filename=[direc,'/plots/',filestr,'.png']
    print('-dpng','-r300',filename);
end %for


rmpath ../script_utils;