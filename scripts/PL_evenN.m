% N is even
%% 1D1
N=2^10;
% N = 10;
%  yff=zeros(1,N);
l0 = 10^3;          % Outer scale
k0 = 2*pi./l0;      % Outer scale wavenumber
x = linspace(0,1,N);
fs = 1/x(2)-x(1);
kx = linspace(-fs/2,fs/2,N);
ky = kx;

yff=zeros(1,numel(kx));
for ifreq=1:numel(kx)
    if ( abs(kx(ifreq)) < 1 )
        yff(ifreq)=1;
    else
        %         yff(ifreq)=kx(ifreq).^(-5/3);
        yff(ifreq) = (1./(1+(kx(ifreq)/k0).^(-5/3)));
    end %if
end %for

yf = awgn(yff,10,'measured');

% yf(1:floor(N/2)-1)=fliplr(conj(yf(floor(N/2)+2:N)));
% yf(floor(N/2))=real(yf(floor(N/2)));
% yf(floor(N/2)+1)=real(yf(floor(N/2)+1));

yf(floor(N/2)+2:floor(N))=fliplr(conj(yf(2:floor(N/2))));
yf(floor(N/2)+1)=real(yf(floor(N/2)+1));
yf(1)=real(yf(1));

% yf(1:floor(N/2))=fliplr(conj(yf(floor(N/2)+2:N)));
% yf(floor(N/2)+1)=real(yf(floor(N/2)+1));

figure, p1 = loglog(kx,yf,'r');
hold on
p2 = loglog(kx,yff,'b');
y=ifft(ifftshift(yf));

% recompute the spectrum from our noise-like signal to check
yfcheck=fftshift(fft(y));
yffcheck=yfcheck.*conj(yfcheck);

% plot the signal and its recomputed spectrum to check
figure;
subplot(4,1,1);
plot(kx,yff);
xlabel("freq.")
ylabel("Power spectrum")
title("Original (Power Law)")

subplot(4,1,2);
plot(kx,real(yf));
hold on;
plot(kx,imag(yf));
plot(kx,yf.*conj(yf));
hold off;
xlabel("freq.")
ylabel("signal fft")

subplot(4,1,3);
plot(x,y);
xlabel("time")
ylabel("signal")

subplot(4,1,4);
plot(kx,yffcheck)
xlabel("freq.")
ylabel("Power spectrum")
title("Recomputed")

%% 2D
[Ky,Kx]=meshgrid(ky,kx);
Ky = flip(Ky);
K = sqrt(Kx.^2+Ky.^2);

yff2d=zeros(size(Ky));

for ifreq=1:N
    for kfreq = 1:N
        if ( abs(K(ifreq,kfreq)) < 1 )
            yff2d(ifreq,kfreq)=1;
        else
            yff2d(ifreq,kfreq)=K(ifreq,kfreq).^(-5/3);
            %         yff2d(ifreq,kfreq) = 100*(1./(1+(Ky(ifreq,kfreq)/k0).^(-5/3)));
        end %if
    end
end

% for i = 1:N
% yff2d(i,floor(N/2)+2:floor(N))=fliplr(conj(yff2d(i,1:floor(N/2)-1)));
% yff2d(i,floor(N/2)+1) = real(yff2d(i,floor(N/2)+1));
% yff2d(i,floor(N/2)) = real(yff2d(i,floor(N/2)));
% end

%yf2d = awgn(yff2d,10,'measured');
yf2d=sqrt(yff2d).*exp(2*pi*1i*rand(size(yff2d)));

% for i=1:N
% yf2d(i,floor(N/2)+2:floor(N))=fliplr(conj(yf2d(i,1:floor(N/2)-1)));
% yf2d(i,floor(N/2)+1)=real(yf2d(i,floor(N/2)+1));
% yf2d(i,floor(N/2))=real(yf2d(i,floor(N/2)));
% end

% MZ - enforce known (Hermitian) symmetry - viz. the 1st and 3rd quadrants
% of the fft2 of a real-valued signal are complex conjugates.  Likewise for
% the 2nd and 4th quadrant.  For now we assume that we have an even number
% of samples so that yf2d(floor((N/2))+1,floor(N/2))+1) is the DC 
% component.  We also assume numel(kx)=numel(ky).
iDC=floor(N/2)+1;
yf2d_q13=yf2d(iDC:end,iDC:end);
yf2d_q24=yf2d(1:iDC-1,iDC:end);
yf2d(1:iDC-1,1:iDC-1)=fliplr(flipud(conj(yf2d_q13)));
yf2d(iDC:end,1:iDC-1)=fliplr(flipud(conj(yf2d_q24)));

% MZ - force kx,ky=0 axes to be real
%yf2d(iDC,:)=real(yf2d(iDC,:));
%yf2d(:,iDC)=real(yf2d(:,iDC));

% for i=1:N
%     yf2d(i,floor(N/2)+2:floor(N))=fliplr(conj(yf2d(i,2:floor(N/2))));
%     yf2d(i,floor(N/2)+1)=real(yf2d(i,floor(N/2)+1));
%     yf2d(i,1)=real(yf2d(i,1));
% end

figure;
subplot(131);
imagesc(log10(yf2d.*conj(yf2d)))
caxis([-5 0]);
axis xy;
colorbar;

% MZ - complete the ifft to get spatial signal
y2d=ifft2(ifftshift(yf2d),'symmetric');    % why tf does this need symmetric????

subplot(132);
imagesc(y2d);
axis xy;
colorbar;

% MZ - check results
yf2d_check=fftshift(fft2(y2d));
subplot(133);
imagesc(log10(yf2d_check.*conj(yf2d_check)));
caxis([-5 0]);
axis xy;
colorbar;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % MZ - diagnostic plots
% figure, 
% p1 = loglog(kx,yf2d);
% hold on
% p2 = loglog(kx,yff);
% 
% figure, 
% loglog(K(512,1:512),yff2d(512,1:512),'b')
% hold on
% loglog(Ky(512,:),yf2d(512,:),'r')
% 
% % MZ - spatial signal
% y2d=zeros(size(yf2d));
% for i = 1:N
%     y2d(i,:)=ifft(ifftshift(yf2d(i,:)));
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load('shapefn.mat');
% Qpk = 25;
% QBG = 1;
% Qittmp=Qpk.*shapefn;
% inds=Qittmp<QBG;
% Qittmp(inds)=QBG;
% arc = Qittmp>1;
% figure, pcolor(arc), shading flat, colorbar
% arc_noise = 10*Qpk*(abs(y2d).*arc);
% figure, pcolor(arc_noise), shading flat, colorbar
% arc_w_noise = Qittmp+arc_noise;
% figure, pcolor(arc_w_noise), shading flat, colorbar
%
% % recompute the spectrum from our noise-like signal to check
% yfcheck=fftshift(fft(arc_noise));
% yffcheck=yfcheck.*conj(yfcheck);
%
% figure, loglog(kx,yfcheck)
%
% %% noise at arc indices only
%
% N1 = 601;
% N2 = 401;
% % N = 5;
% %  yff=zeros(1,N);
%  l0 = 10^3;          % Outer scale
%  k0 = 2*pi./l0;      % Outer scale wavenumber
%  x = linspace(0,1,N1);
%  y = linspace(0,1,N2);
%  fsx = 1/x(2)-x(1);
%  fsy = 1/y(2)-y(1);
%  kx = linspace(-fsx/2,fsx/2,N1);
%  ky = linspace(-fsy/2,fsy/2,N2);
%
% %% 2D
% [Ky,Kx]=meshgrid(ky,kx);
% Ky = flip(Ky);
% K = sqrt(Kx.^2+Ky.^2);
%
% yff2d=zeros(size(Ky));
%
% for ifreq=1:N1
% for kfreq = 1:N2
%     if ( abs(Ky(ifreq,kfreq)) < 1 )
%         yff2d(ifreq,kfreq)=1;
%     else
%         yff2d(ifreq,kfreq)=Ky(ifreq,kfreq).^(-5/3);
% %         yff2d(ifreq,kfreq) = (1./(1+(Ky(ifreq,kfreq)/k0).^(-5/3)));
%     end %if
% end
% end
%
% % for i = 1:N
% % yff2d(i,floor(N/2)+2:floor(N))=fliplr(conj(yff2d(i,1:floor(N/2))));
% % yff2d(i,floor(N/2)+1) = real(yff2d(i,floor(N/2+1)));
% % end
%
%
% yf2d = awgn(yff2d,10,'measured');
%
% for i=1:N1
% yf2d(i,floor(N2/2)+2:floor(N2))=fliplr(conj(yf2d(i,1:floor(N2/2))));
% yf2d(i,floor(N2/2)+1)=real(yf2d(i,floor(N2/2)+1));
% end
%
% y2d=zeros(size(yf2d));
% for i = 1:N1
% y2d(i,:)=ifft(ifftshift(yf2d(i,:)));
% end
%
% load('shapefn.mat');
% Qpk = 25;
% QBG = 1;
% Qittmp=Qpk.*shapefn;
% inds=Qittmp<QBG;
% Qittmp(inds)=QBG;
% figure, pcolor(Qittmp), shading flat, colorbar
% arc = Qittmp>5;
% figure, pcolor(arc), shading flat, colorbar
% arc_only = arc(200:800,350:750);
% figure, pcolor(arc_only), shading flat, colorbar
% arc_noise = 100*Qpk*(abs(y2d).*arc_only);
% figure, pcolor(arc_noise), shading flat, colorbar
% Qittmp(200:800,350:750)= Qittmp(200:800,350:750)+(arc_noise);
% arc_w_noise = Qittmp;
% figure, pcolor(arc_w_noise), shading flat, colorbar
%
% % recompute the spectrum from our noise-like signal to check
% yfcheck=fftshift(fft(arc_noise));
% yffcheck=yfcheck.*conj(yfcheck);
%
% figure, loglog(kx,yfcheck)