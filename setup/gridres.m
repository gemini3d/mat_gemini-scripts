function [dl1,dl2,dl3]=gridres(xg)

%% GRID RESOLUTIONS


lx1=xg.lx(1);
lx2=xg.lx(2);
lx3=xg.lx(3);

h1=xg.h1(3:end-2,3:end-2,3:end-2);
h2=xg.h2(3:end-2,3:end-2,3:end-2);
h3=xg.h3(3:end-2,3:end-2,3:end-2);
dx1b=xg.dx1b(2:end-2);
dx2b=xg.dx2b(2:end-2);
dx3b=xg.dx3b(2:end-2);

dl1=repmat(dx1b(:),[1 lx2 lx3]).*h1;
dl2=repmat(dx2b(:)',[lx1 1 lx3]).*h2;
dl3=repmat(reshape(dx3b(:),[1 1 lx3]),[lx1 lx2 1]).*h3;

end %function gridres


