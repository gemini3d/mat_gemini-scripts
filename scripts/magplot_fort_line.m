t=datenum(simdate_series);
T=(t(2)-t(1))*86400;
Br=squeeze(Brt(1:end-1)/1e-9);
lt=numel(t);


%% Show the time series
figure;
set(gcf,'PaperPosition',[0 0 8.5 4]);
%subplot(311);
plot(t,Br,'LineWidth',2);
datetick;
ylabel('B_z (nT)');
xlabel('UTC')
set(gca,'FontSize',14);
grid on;
print -dpng -r300 ~/Br_time.png;


%% Now do windowed spectra to pick out different features
SBr=[];
for it=1:lt
    %WINDOW SIZE AND INDICES
    winlen=3600;
    %windowsize=T*60/T;
    windowsize=floor(winlen/T);
    minit=max(floor(it-windowsize/2),1);
    maxit=min(minit+windowsize,lt);
    if (maxit==lt)
        minit=maxit-windowsize;
    end
    its=minit:maxit;


    %FREQUENCY AXIS FOR FFTS
    acfBr=xcorr(Br(its),Br(its));
    M=numel(acfBr);                %number of samples for this station
    f=[-(M-1)/2:(M-1)/2]/M/T;    %frequency grid
    f=f(:);
    window=ones(M,1);    %this is the ACF window!!!


    %IF WE ARE DOING SOMETHING OTHER THAN A RECTANGULAR WINDOW WE NEED
    %AN ADDITIONAL 'ENVELOPE' FUNCTION
    if (minit~=1 & maxit~=lt)    %don't adjust window if we are hitting edges...
        %alpha=0.5; beta=0.5;    %Hann window
        alpha=25/46; beta=21/46;    %Hamming window (first sidelobe is better)
        window=alpha-beta*cos((2*pi*0:(M-1))/(M-1));
        window=window(:);
    end

    SBr(:,it)=fftshift(fft(window.*acfBr));
end


flim=1/2/T;
ifs=find(f>0 & f<flim);
PSD=log10(abs(SBr(ifs,:)));
subplot(312);
pcolor(t-3600,f(ifs),PSD);
%axis([0 3600 1e-3 10e-3])
shading flat;
Pmax=max(PSD(:));
Pmin=Pmax-3;
clim([Pmin,Pmax]);
datetick;


%% Some extra code from prior stuff
% SBx=[];
% for it=1:lt
%     %WINDOW SIZE AND INDICES
%     windowsize=10*60/10;
%     minit=max(floor(it-windowsize/2),1);
%     maxit=min(minit+windowsize,lt);
%     if (maxit==lt)
%         minit=maxit-windowsize;
%     end
%     its=minit:maxit;
%
%
%     %FREQUENCY AXIS FOR FFTS
%     acfBx=xcorr(Bxpad(its));
%     M=numel(acfBx);
%     f=[-(M-1)/2:(M-1)/2]/M/T;
%     f=f(:);
%     window=ones(M,1);    %this is the ACF window!!!
%
%
%     %IF WE ARE DOING SOMETHING OTHER THAN A RECTANGULAR WINDOW WE NEED
%     %AN ADDITIONAL 'ENVELOPE' FUNCTION
%     if (minit~=1 & maxit~=lt)    %don't adjust window if we are hitting edges...
%         %alpha=0.5; beta=0.5;    %Hann window
%         alpha=25/46; beta=21/46;    %Hamming window (first sidelobe is better)
%         window=alpha-beta*cos((2*pi*0:(M-1))/(M-1));
%         window=window(:);
%     end
%
%     SBx(:,it)=fftshift(fft(window.*acfBx));
% end
