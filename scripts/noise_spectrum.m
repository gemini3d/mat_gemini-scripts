N=2^10+1;
t=linspace(0,1,N);
Fs = 1/(t(2)-t(1));         % sampling frequency
df = Fs/length(t);
f = linspace(-Fs/2,Fs/2,N);
N=numel(t);

%% Gaussian spectrum
% generate a signal of a known spectrum
sigmaf=(max(f)-min(f))/10;
yff=exp(-f.^2/2/sigmaf^2);                    % take this as a power spectrum
yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));   % randomize the signal phase
y=ifft(ifftshift(yf));

% recompute the spectrum from our noise-like signal to check
yfcheck=fftshift(fft(y));
yffcheck=yfcheck.*conj(yfcheck);

% plot the signal and its recomputed spectrum to check
figure;
subplot(4,1,1);
plot(f,yff);
xlabel("freq.")
ylabel("Power spectrum")
title("Original (Gaussian)")

subplot(4,1,2);
plot(f,real(yf));
hold on;
plot(f,imag(yf));
plot(f,yf.*conj(yf));
hold off;
xlabel("freq.")
ylabel("signal fft")

subplot(4,1,3);
plot(t,y);
xlabel("time")
ylabel("signal")

subplot(4,1,4);
plot(f,yffcheck)
xlabel("freq.")
ylabel("Power spectrum")
title("Recomputed")


%% try with power law
yff=zeros(1,numel(f));
for ifreq=1:numel(f)
    if ( abs(f(ifreq)) < 1 )
        yff(ifreq)=1;
    else
        yff(ifreq)=f(ifreq).^(-5/3);
    end %if
end %for
yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));
% we need to force the negative frequencies to be complex conjugate of pos.
% frequency
yf(1:floor(N/2))=fliplr(conj(yf(floor(N/2)+2:N)));
yf(floor(N/2)+1)=real(yf(floor(N/2))+1);
y=ifft(ifftshift(yf));

% recompute the spectrum from our noise-like signal to check
yfcheck=fftshift(fft(y));
yffcheck=yfcheck.*conj(yfcheck);

% plot the signal and its recomputed spectrum to check
figure; 
subplot(4,1,1);
loglog(f,yff);
xlabel("freq.")
ylabel("Power spectrum")
title("Original (Power Law)")

subplot(4,1,2);
plot(f,real(yf));
hold on;
plot(f,imag(yf));
plot(f,yf.*conj(yf));
hold off;
xlabel("freq.")
ylabel("signal fft")

subplot(4,1,3);
plot(t,y);
xlabel("time")
ylabel("signal")

subplot(4,1,4);
loglog(f,yffcheck)
xlabel("freq.")
ylabel("Power spectrum")
title("Recomputed")


 %% 1D power law with outer scale
 N=2^10+1;
 yff=zeros(1,N);
 l0 = 10^4;          % Outer scale
 k0 = 2*pi./l0;      % Outer scale wavenumber
 x = linspace(0,1,N);
 fs = 1/x(2)-x(1);
 kx = linspace(-fs/2,fs/2,N);
 ky = kx;
 SI = 5/3;
 k = sqrt(kx.^2+ky.^2);
 
 for ifreq=1:numel(kx)
    if ( abs(kx(ifreq)) < 1 )
        yff(ifreq)=1;
    else
        yff(ifreq)=(1./(1+(k(ifreq)/k0).^SI));
    end %if
end %
% yff=(1./(1+(k./k0).^SI));
%  yff=(sqrt(Kx.^2 + Ky.^2)/k0).^(-5/3);
 %yff=(1./(sqrt(kx.^2 + ky.^2)).^(5/3));
%  yff = (1./(1+((sqrt(Kx.^2 + Ky.^2))/k0).^SI)); %power spectrum

yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));
% we need to force the negative frequencies to be complex conjugate of pos.
% frequency
yf(1:floor(N/2))=fliplr(conj(yf(floor(N/2)+2:N)));
yf(floor(N/2)+1)=real(yf(floor(N/2))+1);
y=ifft(ifftshift(yf));

% recompute the spectrum from our noise-like signal to check
yfcheck=fftshift(fft(y));
yffcheck=yfcheck.*conj(yfcheck);

% plot the signal and its recomputed spectrum to check
figure; 
subplot(4,1,1);
loglog(kx./2*pi,yff);
xlabel("kx")
ylabel("Power spectrum")
title("Original (Power Law)")

subplot(4,1,2);
plot(kx./2*pi,real(yf));
hold on;
plot(kx./2*pi,imag(yf));
plot(kx./2*pi,yf.*conj(yf));
hold off;
xlabel("kx")
ylabel("signal fft")

subplot(4,1,3);
plot(x,y);
xlabel("x")
ylabel("signal")

subplot(4,1,4);
loglog(kx./2*pi,yffcheck)
xlabel("kx")
ylabel("Power spectrum")
title("Recomputed")

%% 2D power law with outer scale

N=2^10;
%  yff=zeros(1,N);
 l0 = 10^3;          % Outer scale
 k0 = 2*pi./l0;      % Outer scale wavenumber
 x = linspace(0,1,N);
 fs = 1/x(2)-x(1);
 kx = linspace(-fs/2,fs/2,N);
  ky = kx;
  
%  x = linspace(0,1,520);
%  y = linspace(0,1,374);
%  fx = 1/x(2)-x(1);
%  fy = 1/y(2)-y(1);
%  kx = linspace(-fx/2,fx/2,numel(x));
%  ky = linspace(-fy/2,fy/2,numel(y));
 
%  kx = 2*pi./x;

 SI = 5/3;
 k = sqrt(kx.^2+ky.^2);

[Ky,Kx]=meshgrid(ky,kx);  
Ky = flip(Ky);
K = sqrt(Kx.^2+Ky.^2);

yff=10^7*(1./(1+(K./k0).^SI));
% yff = yff./max(yff(:));
% yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));
yf = awgn(yff,10,'measured');
% yf = yf./max(yf(:));
% 
% figure, p1 = loglog(k(1:end/2)./2*pi,(mean(yf(1:end/2,1:end/2))),'r');
% hold on
% p2 = loglog(k(1:end/2)./2*pi,(mean(yff(1:end/2,1:end/2))),'b');


% we need to force the negative frequencies to be complex conjugate of pos.
% frequency
for i = 1:numel(x)
yf(i,1:floor(numel(k)/2))=fliplr(conj(yf(i,floor(numel(k)/2)+1:numel(k))));
end
% yf(floor(N/2)+1)=real(yf(floor(N/2))+1);

figure, p1 = loglog(kx./2*pi,yf(:,end/2),'r');
hold on
p2 = loglog(kx./2*pi,(yff(:,end/2)),'b');
% xlabel("1/size [1/m]")
% ylabel("Spectral Power [dB]")
% title("1D Power Law Noise")
ax = gca
ax.GridLineStyle = ':'
ax.GridColor = 'k'
ax.GridAlpha = 0.5;
ax.LineWidth = 1.3
xlabel('1/size [1/m]','FontSize',14,'Color','black');
ylabel('Spectral Power [dB]','FontSize',14,'Color','black');
hold on;
a = get(gca,'XTickLabel');
b = get(gca,'YTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
set(gca,'YTickLabel',b,'FontName','Times','fontsize',18)
title("Power Law Noise Spectrum")
fontlg= 16;
linewd =2.5;
set(p1,'linewidth',linewd)
set(p2,'linewidth',linewd)
% xticklabels({'10^{-6}','10^{-5}','10^{-4}','10^{-3}','10^{-2}'})
% axis([0.1 10 -inf inf])


hlg=legend('Noise','Orig');
set(hlg,'fontsize',fontlg);
hlg.FontSize = 20;
grid on;

yy=ifft(ifftshift(yf));

load('shapefn.mat');
arc = shapefn>0.2;
figure, pcolor(arc), shading flat, colorbar
arc_noise = (abs(yy).*arc);
figure, pcolor(arc_noise), shading flat, colorbar

figure, loglog(kx./2*pi,arc_noise(:,end/2))
figure, semilogx(kx./2*pi,10*log10(arc_noise(:,end/2)))

% plot the signal and its recomputed spectrum to check
figure; 
subplot(4,1,1);
loglog(kx./2*pi,yff(end/2,:));
xlabel("kx")
ylabel("Power spectrum")
title("Original (Power Law)")

subplot(4,1,2);
plot(kx./2*pi,real(yf(end/2,:)));
hold on;
plot(kx./2*pi,imag(yf(end/2,:)));
plot(kx./2*pi,yf(end/2,:).*conj(yf(end/2,:)));
hold off;
xlabel("kx")
ylabel("signal fft")

subplot(4,1,3);
plot(x,y(end/2,:));
xlabel("x")
ylabel("signal")

subplot(4,1,4);
loglog(kx./2*pi,yffcheck(end/2,:))
xlabel("kx")
ylabel("Power spectrum")
title("Recomputed")

load('shapefn.mat');
arc = shapefn>0.2;
figure, pcolor(arc), shading flat, colorbar
%y = abs((y./max(y(:))));
y=y.*conj(y);
y=y./max(y(:));
arc_noise = 1000*(y.*arc);
figure, pcolor(arc_noise), shading flat, colorbar
% inds = arc_noise<0;
% arc_noise(inds)=0;
