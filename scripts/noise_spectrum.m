% create a time and frequency axis
Fs = 1000;                  % sampling frequency
t = 0:1/Fs:1-0.001;
df = Fs/length(t);
f = -Fs/2:df:Fs/2-df;    % frequency axis

% generate a signal of a known spectrum
sigmaf=(max(f)-min(f))/10;
yff=exp(-f.^2/2/sigmaf^2);                   % take this as a power spectrum
yf=sqrt(yff).*exp(2*pi*1i*rand(size(yff)));   % randomize the signal phase
y=ifft(yf);

% recompute the spectrum from our noise-like signal to check
yfcheck=fftshift(fft(y));
yffcheck=yfcheck.*conj(yfcheck);

% plot the signal and its recomputed spectrum to check
subplot(4,1,1);
plot(f,yff);
subplot(4,1,2);
plot(f,real(yf));
hold on;
plot(f,imag(yf));
plot(f,yf.*conj(yf));
hold off;
subplot(4,1,3);
plot(t,y);
subplot(4,1,4);
plot(f,yff)