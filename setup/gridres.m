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


%% PLOTS
figure;
imagesc(log10(dl1(:,:,1)/1e3));
colorbar;
title('log_{10} Resolution along field line (min x3)')
datacursormode;

figure;
imagesc(xg.alt(:,:,1)/1e3);
colorbar;
title('altitude (min x3)')
datacursormode;

figure;
imagesc(dl2(:,:,1)/1e3);
colorbar;
title('Resolution perp. to field line (min x3)')
datacursormode;

figure;
imagesc(squeeze(dl3(1,:,:))/1e3);
colorbar;
title('ZONAL Resolution perp. to field line (min x1)')
datacursormode;

figure;
imagesc(squeeze(dl3(floor(end/2),:,:))/1e3);
colorbar;
title('ZONAL Resolution perp. to field line (mid x1)')
datacursormode;


%% FOR A GIVEN GRID ATTEMPT TO DEFINE A CONSTANT STRIDE IN THE X2 DIRECTION (VERY OFTEN DESIRABLE)
dl2trial=dl2(end/2,:,end/2);
x2=xg.x2(3:end-2);
dl2target=10e3;                            %define a desired grid step size in x2
dx2target=dl2target./h2(end/2,:,end/2);   %what dx2 needs to be to hit target grid size
coeffs=polyfit(x2,dx2target,2);
dx2new=polyval(coeffs,x2);

figure;
plot(x2,dx2new,x2,dx2target);

dl2new=dx2new.*h2(end/2,:,end/2);

figure;
plot(x2,dl2new,x2,dl2trial);



