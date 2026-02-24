function [E,v]=vfield(xg,E2,E3)
arguments
  xg (1,1) struct
  E2 (:,:,:)
  E3 (:,:,:)
end
% This is a standard interface to be used for conversion of plasma drifts
% into electric fields.  The output vectors (field E, and drift v) are stored as 4D arrays with
% dimensions:
% x1,x2,x3,component (field-aligned, field perp 1, field perp 2)

if (~isfield(xg,'Bmag'))
    error('The field xg.Bmag must be defined for the 1st argument.')
end %if

%COMPUTE THE ELECTRIC FIELD FROM THE PERP DRIFT OUTPUT FROM THE MODEL
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);


%DETECT WHETHER INVERTED GRID OR CLOSED
if (xg.x1(1)-xg.x1(end)>0)
  ix1ref=1;
else
  ix1ref=lx1;
end %if
if (abs(xg.x1(1)-xg.x1(end))<1.0)
  ix1ref=floor(lx1/2);
end %if


%COMPILE A V VECTOR
Eperp2=squeeze(E2(ix1ref,:,:));
Eperp2=repmat(Eperp2,[1,1,lx1]);
Eperp3=squeeze(E3(ix1ref,:,:));
Eperp3=repmat(Eperp3,[1,1,lx1]);
E=cat(4,Eperp2,Eperp3,zeros(lx2,lx3,lx1));           %create a vector for the Electric field in the curvilinear basis (i.e. e1,e2,e3 basis vectors), permuted as 231 so that the parallel direction is the third dimension

B=cat(4,zeros(lx2,lx3,lx1),zeros(lx2,lx3,lx1),ones(lx2,lx3,lx1).*permute(xg.Bmag,[2,3,1]));
v=cross(E,B,4);
B2=dot(B,B,4);
for icomp=1:3
  v(:,:,:,icomp)=v(:,:,:,icomp)./B2;
end %for


%PERMUTE OUTPUTS TO MATCH MODEL natural ordering - this handles functional
%dependence
v=permute(v,[3,1,2,4]);
E=permute(E,[3,1,2,4]);


%NOW DEAL WITH THE COMPONENT WHICH SHOULD BE CYCLICALLY PERMUTED IN DIM 4
v=circshift(v,1,4);
E=circshift(E,1,4);

end %function vfield