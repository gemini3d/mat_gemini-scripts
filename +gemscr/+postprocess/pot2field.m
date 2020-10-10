function [E1,E2,E3]=pot2field(xg,Phival)

% This converts potential into electric field.  Right now it only works in
% 3D and requires a full grid input structure in order to work (i.e. need
% the metric factors and sizes in order to compute gradient).  Please note
% that this will ***not take into account any background fields*** These
% must independently be added!!!


% Input checking and data prep
ndims=length(xg.lx);
lx1=xg.lx(1);
lx2=xg.lx(2);
lx3=xg.lx(3);
if (ndims~=3)
    error('This function only support taking gradient for a 3D simulation right now');
else
    shapePhi=size(Phival);
    if (length(shapePhi)==2)    % go ahead and turn into a 3D array as needed
        Phi=repmat(reshape(Phival,[1,lx2,lx3]),[lx1,1,1]);
    end %if
end %if
Phi=-1*Phi;

%x1 component of gradient
dx1b=xg.dx1b(2:lx1+1);               % backward differences re-indexed to remove ghost cells
h1=xg.h1(3:lx1+2,3:lx2+2,3:lx3+2);   % re-index metrix factors to exclude ghost cells
E1=zeros(lx1,lx2,lx3);
E1(1,:,:)=( Phi(2,:,:)-Phi(1,:,:) )./( h1(1,:,:).*dx1b(2) );
for ix1=2:lx1-1
    E1(ix1,:,:)=( Phi(ix1+1,:,:)-Phi(ix1-1,:,:) )./( h1(ix1,:,:).*(dx1b(ix1+1)+dx1b(ix1)) );
end %for
E1(lx1,:,:)=( Phi(lx1,:,:)-Phi(lx1-1,:,:) )./( h1(lx1,:,:).*dx1b(lx1) );

%x2 component of gradient
dx2b=xg.dx2b(2:lx2+1);               % backward differences re-indexed to remove ghost cells
h2=xg.h2(3:lx1+2,3:lx2+2,3:lx3+2);   % re-index metrix factors to exclude ghost cells
E2=zeros(lx1,lx2,lx3);
E2(:,1,:)=( Phi(:,2,:)-Phi(:,1,:) )./( h2(:,1,:).*dx2b(2) );
for ix2=2:lx2-1
    E2(:,ix2,:)=( Phi(:,ix2+1,:)-Phi(:,ix2-1,:) )./( h2(:,ix2,:).*(dx2b(ix2+1)+dx2b(ix2)) );
end %for
E2(:,lx2,:)=( Phi(:,lx2,:)-Phi(:,lx2-1,:) )./( h2(:,lx2,:).*dx2b(lx2) );

%x3 component of gradient
dx3b=xg.dx3b(2:lx3+1);               % backward differences re-indexed to remove ghost cells
h3=xg.h3(3:lx1+2,3:lx2+2,3:lx3+2);   % re-index metrix factors to exclude ghost cells
E3=zeros(lx1,lx2,lx3);
E3(:,:,1)=( Phi(:,:,2)-Phi(:,:,1) )./( h3(:,:,1).*dx3b(2) );
for ix3=2:lx3-1
    E3(:,:,ix3)=( Phi(:,:,ix3+1)-Phi(:,:,ix3-1) )./( h3(:,:,ix3).*(dx3b(ix3+1)+dx3b(ix3)) );
end %for
E3(:,:,lx3)=( Phi(:,:,lx3)-Phi(:,:,lx3-1) )./( h3(:,:,lx3).*dx3b(lx3) );

end %function pot2field
