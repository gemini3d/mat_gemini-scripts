function [muP,muH,mu0,sigP,sigH,sig0,incap] = conductivities3D(nus,nusj,ns,ms,qs,B)
arguments
    nus (:,:,:,:)
    nusj (:,:,:,:,:)
    ns (:,:,:,:)
    ms (1,:)
    qs (1,:)
    B (1,1)
end

[lx1,lx2,lx3,lsp]=size(nus);
mu0=zeros(lx1,lx2,lx3,lsp);
muP=zeros(lx1,lx2,lx3,lsp);
muH=zeros(lx1,lx2,lx3,lsp);
mubase=zeros(lx1,lx2,lx3,lsp);
cfact=zeros(lx1,lx2,lx3,lsp);


%% MOBILITIES;
for is=1:lsp
   OMs=qs(is)*B/ms(is);                 %cycltron

   if is~=lsp
       mu0(:,:,:,is)=qs(is)/ms(is)./nus(:,:,:,is);        %parallel mobility
       mubase(:,:,:,is)=mu0(:,:,:,is);
   else
       nuse=sum(nusj(:,:,:,lsp,:),5);
       mu0(:,:,:,lsp)=qs(lsp)/ms(lsp)./(nus(:,:,:,lsp)+nuse);
       mubase(:,:,:,is)=qs(lsp)/ms(lsp)./nus(:,:,:,lsp);
   end

   muP(:,:,:,is)=mubase(:,:,:,is).*nus(:,:,:,is).^2./(nus(:,:,:,is).^2+OMs.^2);            %Pederson
   muH(:,:,:,is)=-1*mubase(:,:,:,is).*nus(:,:,:,is).*OMs./(nus(:,:,:,is).^2+OMs.^2);       %Hall
end


%% CONDUCTIVITIES
sig0=ns(:,:,:,lsp)*qs(lsp).*mu0(:,:,:,lsp);        %parallel includes only electrons...

for is=1:lsp
   cfact(:,:,:,is)=ns(:,:,:,is)*qs(is);
end
sigP=sum(cfact.*muP,4);
sigH=sum(cfact.*muH,4);


%% Inertial capacitance
incap=0.0;
for isp=1:lsp
  incap=incap+ns(:,:,:,isp)*ms(isp);
end %for
incap = incap./B.^2;

end
