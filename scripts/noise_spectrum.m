% create a time and frequency axis
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
y=ifft(yf);

% recompute the spectrum from our noise-like signal to check
yfcheck=fft(y);
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


% %% power law with outer scale?
% yff=zeros(1,numel(f));
% for ifreq=1:numel(f)
%     if ( abs(f(ifreq)) < 1 )
%         yff(ifreq)=1;
%     else
%         yff(ifreq)=f(ifreq).^(-5/3);
%     end %if
% end %for
% yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));
% ytmp=ifft(yf);
% y=zeros(numel(ytmp));
% y(250:750)=ytmp(250:750);    % square window generates ringing, big suprise
% y=ytmp.*exp(-(t-mean(t)).^2/2/(0.05)^2);
% 
% recompute the spectrum from our noise-like signal to check
% yfcheck=fft(y);
% yffcheck=yfcheck.*conj(yfcheck);
% 
% plot the signal and its recomputed spectrum to check
% figure; 
% subplot(4,1,1);
% loglog(f,yff);
% xlabel("freq.")
% ylabel("Power spectrum")
% title("Original (Power Law)")
% 
% subplot(4,1,2);
% plot(f,real(yf));
% hold on;
% plot(f,imag(yf));
% plot(f,yf.*conj(yf));
% hold off;
% xlabel("freq.")
% ylabel("signal fft")
% 
% subplot(4,1,3);
% plot(t,y);
% xlabel("time")
% ylabel("signal")
% 
% subplot(4,1,4);
% loglog(f,yffcheck)
% xlabel("freq.")
% ylabel("Power spectrum")
% title("Recomputed")