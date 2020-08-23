
function [nusn,nus,nusj,nuss,Phisj,Psisj]=collisions3D(natm,Ts,ns,vsx1,ms)

narginchk(5,5)
%HOUSEKEEPING INFO
nO=natm(:,:,:,1);
nN2=natm(:,:,:,2);
nO2=natm(:,:,:,3);
Tn=natm(:,:,:,4);
nH=natm(:,:,:,7);

[lx1,lx2,lx3,lsp]=size(ns);
ln=4;

nusn=zeros(lx1,lx2,lx3,lsp,ln);
nus=zeros(lx1,lx2,lx3,lsp);
nusj=zeros(lx1,lx2,lx3,lsp,lsp);
nuss=zeros(lx1,lx2,lx3,lsp);
Psisj=ones(lx1,lx2,lx3,lsp,lsp);
Phisj=ones(lx1,lx2,lx3,lsp,lsp);

kb=1.3806503e-23;


% Collision frequencies of O+, NO+, N2+, O2+ with O, N, and O2.

% Species O+
    T=0.5*(Tn+Ts(:,:,:,1));

    ROp = 3.67E-11*(1-.064*log10(T)).^2.*(T.^.5).*nO;
    ROpH = 4.63E-12*(Tn+Ts(:,:,:,1)/16).^.5.*nH;
    nusn(:,:,:,1,1) = ROp*1e-6;
    nusn(:,:,:,1,2) = 6.82E-10*nN2*1E-6;
    nusn(:,:,:,1,3) = 6.64E-10*nO2*1E-6;
    nusn(:,:,:,1,4) = ROpH*1e-6;

    nus(:,:,:,1) = sum(nusn(:,:,:,1,:),5);


% Species NO+
    nusn(:,:,:,2,1) = 2.44E-10*nO*1E-6;
    nusn(:,:,:,2,2) = 4.34E-10*nN2*1E-6;
    nusn(:,:,:,2,3) = 4.27E-10*nO2*1E-6;
    nusn(:,:,:,2,4) = 0.69E-10*nH*1E-6;

    nus(:,:,:,2) = sum(nusn(:,:,:,2,:),5);


% Species N2+
    T=0.5*(Tn+Ts(:,:,:,3));

    nusn(:,:,:,3,1) = 2.58E-10*nO*1E-6;
    RN2 = 5.14e-11*(1-.069*log10(T)).^2.*(T.^.5).*nN2;
    nusn(:,:,:,3,2) =  RN2*1E-6;
    nusn(:,:,:,3,3) = 4.49E-10*nO2*1E-6;
    nusn(:,:,:,3,4) = 0.74E-10*nH*1E-6;

    nus(:,:,:,3) = sum(nusn(:,:,:,3,:),5);


% Species O2+
    T=0.5*(Tn+Ts(:,:,:,4));

    nusn(:,:,:,4,1) = 2.31E-10*nO*1E-6;
    nusn(:,:,:,4,2) = 4.13E-10*nN2*1E-6;
    RO2 = 2.59e-11*(1-.073*log10(T)).^2.*(T.^.5).*nO2;
    nusn(:,:,:,4,3) =  RO2*1E-6;
    nusn(:,:,:,4,4) = 0.65E-10*nH*1E-6;

    nus(:,:,:,4) = sum(nusn(:,:,:,4,:),5);


% Species N+
    nusn(:,:,:,5,1) = 4.42E-10*nO*1E-6;
    nusn(:,:,:,5,2) = 7.47E-10*nN2*1E-6;
    nusn(:,:,:,5,3) =  7.25e-10*nO2*1E-6;
    nusn(:,:,:,5,4) = 1.45e-10*nH*1E-6;

    nus(:,:,:,5) = sum(nusn(:,:,:,5,:),5);


% Species H+
    T=0.5*(Tn+Ts(:,:,:,6));

    RHpO = 6.61E-11*(1-.047*log10(Ts(:,:,:,6))).^2.*(Ts(:,:,:,6).^.5).*nO;
    RHpH = 2.65E-10*(1-0.083*log10(T)).^2.*(T.^.5).*nH;
    nusn(:,:,:,6,1) = RHpO*1e-6;
    nusn(:,:,:,6,2) = 33.6E-10*nN2*1E-6;
    nusn(:,:,:,6,3) = 32.0e-10*nO2*1E-6;
    nusn(:,:,:,6,4) = RHpH*1e-6;

    nus(:,:,:,6) = sum(nusn(:,:,:,6,:),5);


% Species electrons
%    T=0.5*(Tn+Ts(:,:,:,6));
    T=Ts(:,:,:,lsp);

    nusn(:,:,:,lsp,1) = 8.9E-11*(1+5.7E-4*T).*(T.^.5).*nO*1e-6;
    nusn(:,:,:,lsp,2) = 2.33E-11*(1-1.21E-4*T).*(T).*nN2*1e-6;
    nusn(:,:,:,lsp,3) = 1.82E-10*(1+3.6E-2*(T.^.5)).*(T.^.5).*nO2*1e-6;
    nusn(:,:,:,lsp,4) = 4.5E-9*(1-1.35E-4*T).*(T.^.5).*nH*1e-6;

    nus(:,:,:,lsp) = sum(nusn(:,:,:,lsp,:),5);


%COULOMB COLLISIONS

    Csj=[0.22, 0.26, 0.25, 0.26, 0.22, 0.077, 1.87e-3; ...
         0.14, 0.16, 0.16, 0.17, 0.13, 0.042, 9.97e-4; ...
         0.15, 0.17, 0.17, 0.18, 0.14, 0.045, 1.07e-3; ...
         0.13, 0.16, 0.15, 0.16, 0.12, 0.039, 9.347e-4; ...
         0.25, 0.28, 0.28, 0.28, 0.24, 0.088, 2.136e-3; ...
         1.23, 1.25, 1.25, 1.25, 1.23, 0.90,  29.7e-3; ...
         54.5, 54.5, 54.5, 54.5, 54.5, 54.5,  54.5/sqrt(2)];
     for is1=1:lsp
         for is2=1:lsp
             T=(ms(is2)*Ts(:,:,:,is1)+ms(is1)*Ts(:,:,:,is2))/(ms(is2)+ms(is1));
             nusj(:,:,:,is1,is2)=Csj(is1,is2)*ns(:,:,:,is2)*1e-6./T.^1.5;            %standard collision frequencies

              mred=ms(is1)*ms(is2)/(ms(is1)+ms(is2));                            %high speed correction factors (S&N 2000)
              Wst=abs(vsx1(:,:,:,is1)-vsx1(:,:,:,is2))./sqrt(2*kb*T./mred);
              Psisj(:,:,:,is1,is2)=exp(-Wst.^2);
              %Wst=max(Wst,0.01);       %major numerical issues with asymptotic form (as Wst -> 0)!!!

              Phinow=3/4*sqrt(pi)*erf(Wst)./Wst.^3 ...
                  -3/2./Wst.^2.*Psisj(:,:,:,is1,is2);
              Phinow(Wst < 0.1)=1;
              Phisj(:,:,:,is1,is2)=Phinow;
         end
     end

    for is1=1:lsp
        nuss(:,:,:,is1)=nusj(:,:,:,is1,is1);
        nusj(:,:,:,is1,is1)=zeros(lx1,lx2,lx3);     %self collisions in Coulomb array need to be zero for later code in momentum and energy sources
    end

end
