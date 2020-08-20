%% Load a GDI simulation
%direc='~/simulations/GDI_periodic_lowres_nocap/';
direc='~/simulations/GDI_ionospheric_noinertia_paper/';
xg= gemini3d.readgrid(fullfile(direc, 'inputs'));
cfg = gemini3d.read_config(direc);


%% Pick a reference point to extract a line of density
x2=xg.x2(3:end-2);
x3=xg.x3(3:end-2);
lx3=numel(x3);
ix1=min(find(xg.x1>300e3));    %F-region location in terms of grid index
x2ref=-85e3;


%% Loop over data and pull in the density for main part of gradient
neline=[];
t=0;
it=1;
UTsec=UTsec0;
ymd=ymd0;
while (t<=tdur)
    simdatenow=[ymd,0,0,UTsec]
    simdate(it,:)=simdatenow;
    data= gemini3d.vis.loadframe( gemini3d.get_frame_filename(direc,ymd,UTsec));
    x2now=x2ref+t*0.5e3;    %moving at 0.5 kms/
    ix2=min(find(x2>x2now));
    neline(it,:)=squeeze(data.ne(ix1,ix2,:));

    t=t+dtout;
    it=it+1;
    [ymd,UTsec]= gemini3d.dateinc(dtout,ymd,UTsec);
end %while


%% Compute amplitude of fluctuations (BG subtract)
lt=size(neline,1);
dneline=zeros(size(neline));
meanne=zeros(lt,1);
for it=1:lt
    meanne(it)=mean(neline(it,:));
    dneline(it,:)=neline(it,:)-meanne(it);
end %for


%% Fluctuation average and relative change
% The GDI growth rate
nepwr=std(dneline,0,2);   %compute a standard deviation along the x2-direction on the grid (tangent to gradient)
nerelpwr=nepwr./meanne;


%% Evaluate time constant empirically from the simulation output
tconsts=log(nepwr);       % time elapsed measured in growth times
dtconsts=diff(tconsts);   % difference in time constants between outputs
itslinear=find(nerelpwr<0.1);
itmin=5;                  % first few frames involve some settling, remove these
avgdtconst=mean(dtconsts(itmin:max(itslinear)));   % average time constants elapsed per output, only use times after itmin output to allow settling from initial condition
growthtime=dtout/avgdtconst;


%% Growth rate from linear estimate Im{omega} = E/(B*ell)
t=datenum(simdate);
t0=t(itmin);
gamma=0.5e3/10e3;     % 0.5 km/s drift, gradient scale ~ 10km, hardcoded specific user defined choices here... OR FIXME:  read in config.nml file and figure it out...
lineargrowthtime=1/gamma;
linear_nerelpwr=nerelpwr(itmin)*exp(gamma*(t-t0)*86400);


%% Do some basic plot containing this info (avg'd over space)
figure;
plot(t,100*nerelpwr);    % growth from simulation
ax=axis;
hold on;
plot(t,100*linear_nerelpwr);    %pure linear growth
hold off;
axis(ax);
datetick;
legend({'simulation','linear growth'})
xlabel('UT');
ylabel('% variation from background (avg.)');
title(sprintf('Theoretical \\tau:  %d; model \\tau:  %d',lineargrowthtime,growthtime));


%% Break down the growth according to wavenumber
dx=xg.x3(2)-xg.x3(1);            %grid spacing
M=2*numel(x3)-1;                     %number of spatial samples in acf
k=2*pi*[-(M-1)/2:(M-1)/2]/M/dx;  %wavenumber axis for fft
Snn=zeros(lt,numel(k));
for it=1:lt
    acfne=xcorr(dneline(it,:));           %autocorrelation function (spatial) of density variations at this time
    Snn(it,:)=fftshift(fft(acfne));         %power spectral density, no window
end %for
Snnmag=abs(Snn);
Snnmag(:,lx3)=NaN;


%% Plot wavenumber dependent growth
figure;

its=2*[2,4,6,8,10,12];
subplot(121);
plot(x3,dneline(its,:));
xlabel('horizontal distance (m)');
ylabel('\Delta n_e');
for it=1:numel(its)
  leg{it}=[num2str(its(it)*10),' s'];
end %for
legend(leg);

subplot(122);
semilogy(k,Snnmag(its,:));
xlabel('wavenumber (1/m)');
ylabel('\Delta n_e power spectral density');


%% Log plot absolute growth of irregularities
hf3=figure(3);
FS=22;

refval=nepwr(itmin);
linear_neabspwr=refval*exp(gamma*(t-t0)*86400);

semilogy(t(itmin:end),nepwr(itmin:end),'LineWidth',1.5);
set(gca,'FontSize',FS);
datetick;
xlabel('UT');
ylabel('Fluctuation amplitude (m^{-3})');
axis tight;
ax=axis;
hold on;
semilogy(t(itmin:end),linear_neabspwr(itmin:end),'o','LineWidth',1.5);
axis(ax);
hold off;

leglinear=sprintf('linear growth; \\tau = %4.2f s',lineargrowthtime);
legsim=   sprintf('simulation growth; \\tau = %4.2f s',growthtime);
legend(legsim,leglinear,'Location','SouthEast');

%print(3,[direc,'/plots/growth_compare.eps'],'-depsc');
export_graphics(hf3, fullfile(direc, 'plots/growth_compare.eps'))
