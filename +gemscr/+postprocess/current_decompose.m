function [JP,JH,Jfac] = current_decompose(xg, dat)
arguments
  xg (1,1) struct
  dat (1,1) struct
end

%RESOLVE CURRENTS INTO PEDERSEN AND HALL COMPONENTS
[v,E]= gemscr.postprocess.Efield(xg, dat.v2, dat.v3);
% outputs permuted according to natural model ordering (z,x,y) -> 312
lx1=xg.lx(1); lx2=xg.lx(2); lx3=xg.lx(3);

magvperp=sqrt(sum(v.^2,4));
evperp=v./repmat(magvperp,[1,1,1,3]);
% unit vector for ExB drift (curv. basis), permuted as 312 (same as Efield output)

magE=sqrt(sum(E.^2,4));
eE=E./repmat(magE,[1,1,1,3]);
% unit vector in the direction of the electric field

J=cat(4, dat.J1, dat.J2, dat.J3);
JH=dot(J,-1*evperp,4);
% projection of current in -evperp direction
JH=-1*evperp.*repmat(JH,[1,1,1,3]);
JP=dot(J,eE,4);
% project of current in eE unit vector direction (direction of electric field)
JP=eE.*repmat(JP,[1,1,1,3]);
Jfac=cat(4, dat.J1,zeros(lx1,lx2,lx3),zeros(lx1,lx2,lx3));
% field aligned current vector

end
