%% Load a GDI simulation
direc='~/simulations/KHI_periodic_lowres_K88_large_0.5km_signcorrect_long/';
xg=readgrid([direc,'/inputs/']);
[ymd0,UTsec0,tdur,dtout,flagoutput,mloc,activ,indat_size,indat_grid,indat_file] = readconfig([direc,'/inputs/']);


%% Pick a reference point to extract a line of density
x2=xg.x2(3:end-2);
x3=xg.x3(3:end-2);
lx2=numel(x2);
lx3=numel(x3);
ix1=min(find(xg.x1>300e3));    %F-region location in terms of grid index


%% Loop over data and pull in the density for location of density gradient
neline=[];
t=0;
it=1;
UTsec=UTsec0;
ymd=ymd0;
while (t<=tdur)
    simdatenow=[ymd,0,0,UTsec]
    simdate(it,:)=simdatenow;
    data=loadframe(direc,ymd,UTsec);
    
    ix2=floor(lx2/2);    % measure perturbations at the middle x2 point of the domain.
    neline(it,:)=squeeze(data.ne(ix1,ix2,:));

    if (it==1)     % on the first time step compute the conductance and inertial capacitance for the simulation
        ne=data.ne; Ti=data.Ti; Te=data.Te; v1=data.v1;
        [sigP,sigH,sig0,SIGP,SIGH,incap,INCAP]=conductivity_reconstruct(xg,ymd,UTsec,activ,ne,Ti,Te,v1);
        
        % mean relaxation parameter over entire grid, first time step
        nutilde=mean(SIGP(:)./(INCAP(:)+30));    %FIXME:  need to manually add in the magnetospheric capacitance, should be read from input file
    end %if
    
    t=t+dtout;
    it=it+1;
    [ymd,UTsec]=dateinc(dtout,ymd,UTsec);
end %while


%% Parameters for the KHI run
v0=500;         %drift value
ell=1e3;         % shear scale length from input script for KHI run
kellmax=0.44;    % k*ell for max growth rate per Figure 3 of Keskinen, 1988
k=kellmax/ell;
lambda=2*pi/k;   % wavelength of fastest growing KHI mode (can be compared against the nonlinear simulation)


%% Compute amplitude of fluctuations (BG subtract)
lt=size(neline,1);
dneline=zeros(size(neline));
meanne=zeros(lt,1);
for it=1:lt
    meanne(it)=mean(neline(it,:));
    dneline(it,:)=neline(it,:)-meanne(it);
end %for


%% Fluctuation average and relative change
nepwr=std(dneline,0,2);   %compute a standard deviation along the x2-direction on the grid (tangent to gradient)
nerelpwr=nepwr./meanne;


%% Evaluate time constant empirically from the simulation output
tconsts=log(nepwr);       % time elapsed measured in growth times
dtconsts=diff(tconsts);   % difference in time constants between outputs
itslinear=find(nerelpwr<0.1);
itmin=10;                  % allow ~100s to establish fields due to large capacitance and zero start potential
avgdtconst=mean(dtconsts(itmin:max(itslinear)));   %average time constants elapsed per output, only use times after itmin output to allow settling from initial condition
growthtime=dtout/avgdtconst;
 

%% Growth rate from linear estimate Im{omega} = sqrt(nutilde*E/(B*ell))
gammanorm=0.16;                %small nutilde limit from Keskinen, 1988; figure 3
gamma=gammanorm*v0/ell;
lineargrowthtime=1./gamma;
t=datenum(simdate);
t0=t(itmin);
linear_nerelpwr=nerelpwr(itmin)*exp(gamma*(t-t0)*86400);


%% Do some basic plot containing this info (avg'd over space)
figure(1);
plot(t,100*nerelpwr);           % growth from simulation
ax=axis;
hold on;
plot(t,100*linear_nerelpwr);    % pure linear growth
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
figure(2);

its=[1,8,12,24,48,64];
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


