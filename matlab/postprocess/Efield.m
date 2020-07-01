function [v,E]=Efield(xg,v2,v3)


%COMPUTE THE ELECTRIC FIELD FROM THE PERP DRIFT OUTPUT FROM THE MODEL
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);


%DETECT WHETHER INVERTED GRID OR CLOSED
if (xg.x1(1)-xg.x1(end)>0)
  ix1ref=1;
else
  ix1ref=lx1;
end
if (abs(xg.x1(1)-xg.x1(end))<1.0)
  ix1ref=floor(lx1/2);
end


%COMPILE A V VECTOR
vperp2=squeeze(v2(ix1ref,:,:));
vperp2=repmat(vperp2,[1,1,lx1]);
vperp3=squeeze(v3(ix1ref,:,:));
vperp3=repmat(vperp3,[1,1,lx1]);
v=cat(4,vperp2,vperp3,zeros(lx2,lx3,lx1));           %create a vector for the ExB drift in the curvilinear basis (i.e. e1,e2,e3 basis vectors), permuted as 231 so that the parallel direction is the third dimension

B=cat(4,zeros(lx2,lx3,lx1),zeros(lx2,lx3,lx1),ones(lx2,lx3,lx1).*permute(xg.Bmag,[2,3,1]));
E=cross(-1*v,B,4);


%PERMUTE OUTPUTS TO MATCH MODEL natural ordering - this handles functional
%dependence
v=permute(v,[3,1,2,4]);
E=permute(E,[3,1,2,4]);


%NOW DEAL WITH THE COMPONENT WHICH SHOULD BE CYCLICALLY PERMUTED IN DIM 4
v=circshift(v,1,4);
E=circshift(E,1,4);

end %function Efield
