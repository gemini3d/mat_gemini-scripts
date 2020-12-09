
%% Load a KHI simulation
direc='~/simulations/KHI_nutildemin_whitenoise/';
xg = gemini3d.read.grid(fullfile(direc,'inputs'));
cfg = gemini3d.read.config(direc);


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
    data= gemini3d.read.frame(gemini3d.find.frame(direc,ymd,UTsec));

    ix2=floor(lx2/2);    % measure perturbations at the middle x2 point of the domain.
    neline(it,:)=squeeze(data.ne(ix1,ix2,:));
    Phitop(:,:,it)=data.Phitop;

    if (it==1 & ~exist('sigP','var'))     % on the first time step compute the conductance and inertial capacitance for the simulation
        ne=data.ne; Ti=data.Ti; Te=data.Te; v1=data.v1;
        [sigP,sigH,sig0,SIGP,SIGH,incap,INCAP]=conductivity_reconstruct(xg,ymd,UTsec,activ,ne,Ti,Te,v1);

        % mean relaxation parameter over entire grid, first time step
        maxcap=max(incap(:));
        INCAP=INCAP*15/980e3/maxcap;          % scaled capacitance
        nutilde=mean(SIGP(:)./(INCAP(:)));    % FIXME:  need to manually add in the magnetospheric capacitance, should be read from input file
    end %if

    t=t+dtout;
    it=it+1;
    [ymd,UTsec]=dateinc(dtout,ymd,UTsec);
end %while


%% Parameters for the KHI run
v0=500;         %drift value
ell=3.1513e3;         % shear scale length from input script for KHI run
kellmax=0.44;    % k*ell for max growth rate per Figure 3 of Keskinen, 1988
kmax=kellmax/ell;
lambda=2*pi/kmax;   % wavelength of fastest growing KHI mode (can be compared against the nonlinear simulation)


%% Compute amplitude of fluctuations (BG subtract)
lt=size(neline,1);
dneline=zeros(size(neline));
meanne=zeros(lt,1);
for it=1:lt
    meanne(it)=mean(neline(it,:));
    dneline(it,:)=neline(it,:)-meanne(it);
end %for

itmin=14;                 % allow ~140s to establish fields due to large capacitance and zero start potential
t=datenum(simdate);
t0=t(itmin);
gammanorm=0.16;                %small nutilde limit from Keskinen, 1988; figure 3
gamma=gammanorm*v0/ell;
lineargrowthtime=1./gamma;

% %% Fluctuation average and relative change
% nepwr=std(dneline,0,2);   %compute a standard deviation along the x2-direction on the grid (tangent to gradient)
% nerelpwr=nepwr./meanne;
%
%
% %% Evaluate time constant empirically from the simulation output (this uses standard dev which is not really appropriate for KHI)
% % This is a bit tricky because some sort of dynamic at the beginning of the
% % simulation causes settling and decay of noise, which makes the growth
% % take longer to start than one would expect; nonetheless once it commences
% % the growth rate appears to agree fine with linear theory
% tconsts=log(nepwr);       % time elapsed measured in growth times
% dtconsts=diff(tconsts);   % difference in time constants between outputs
% %itslinear=find(nerelpwr<0.05);
% itslinear=itmin:itmin+10;
% avgdtconst=mean(dtconsts(itmin:min(max(itslinear),numel(dtconsts))));
% growthtime=dtout/avgdtconst;


% %% Growth rate from linear estimate in Keskinen et al, 1988
% gammanorm=0.16;                %small nutilde limit from Keskinen, 1988; figure 3
% gamma=gammanorm*v0/ell;
% lineargrowthtime=1./gamma;
% t0=t(itmin);
% linear_nerelpwr=nerelpwr(itmin)*exp(gamma*(t-t0)*86400);
%
%
% %% Do some basic plot containing this info (avg'd over space)
% figure(1);
% plot(t(itmin:end),100*nerelpwr(itmin:end));           % growth from simulation
% ax=axis;
% hold on;
% plot(t,100*linear_nerelpwr);    % pure linear growth
% hold off;
% axis(ax);
% datetick;
% legend({'simulation','linear growth'})
% xlabel('UT');
% ylabel('% variation from background (avg.)');
% title(sprintf('Theoretical \\tau:  %d; model \\tau:  %d',lineargrowthtime,growthtime));


%% Break down the growth according to wavenumber
dx=xg.x3(2)-xg.x3(1);            %grid spacing
M=numel(x3);
%M=2*numel(x3)-1;                     %number of spatial samples in acf
k=2*pi*[-(M-1)/2:(M-1)/2]/M/dx;  %wavenumber axis for fft
Snn=zeros(lt,numel(k));
for it=1:lt
    acfne=dneline(it,:);
    %acfne=xcorr(dneline(it,:));           %autocorrelation function (spatial) of density variations at this time
    Snn(it,:)=fftshift(fft(acfne));         %power spectral density, no window
end %for
Snnmag=abs(Snn);
Snnmag(:,lx3)=NaN;


%% Define wavenumbers of possible interest...
[val,ik]=min(abs(k-kmax));
[val,ik2]=min(abs(k-2*kmax));
[val,ik3]=min(abs(k-3*kmax));
[val,ik4]=min(abs(k-4*kmax));
[val,ik_2]=min(abs(k-1/2*kmax));
[val,ik_3]=min(abs(k-1/3*kmax));
[val,ik_4]=min(abs(k-1/4*kmax));
iks=[ik,ik2,ik3,ik4,ik_2,ik_3,ik_4];


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
ax=axis;

hold on;
for ik=1:numel(iks)
    plot([k(iks(ik)),k(iks(ik))],ax(3:4),'--');
end %for
hold off;


%% Look at "fundamental" mode and first few "harmonics"
hf3 = figure(3);
FS=22;

semilogy(t(itmin:end),Snnmag(itmin:end,iks(1)),'LineWidth',1.5);
set(gca,'FontSize',FS);
axis tight;
ax=axis;
datetick;


%% Compute and add to the plot the linear growth rate for fundamental mode
hold on;
refval=Snnmag(itmin,iks(1));     %reference fluctuation power for the fundamental mode
linear_neabspwr=refval*exp(gamma*(t-t0)*86400);
semilogy(t(itmin:end),linear_neabspwr(itmin:end),'o','LineWidth',1.5);
hold off;
axis(ax);
%legend('k_0','2 k_0','3 k_0','4 k_0','1/2 k_0','1/3 k_0','1/4 k_0','linear theory','Location','SouthEast');
leglinear=sprintf('linear growth');
legsim=   sprintf('simulation growth');
legend(legsim,leglinear,'Location','SouthEast');

%print([direc,'/plots/growth_compare.eps'],'-depsc');
exportgraphics(hf3, fullfile(direc, 'plots/growth_compare.eps'))

% %% Do a similar calculation to look at potential to see startup effects...
% dPhiline=zeros(lx3,lt);
% for it=1:lt
%   PhiBG=mean(Phitop(floor(end/2),:,it));
%   dPhiline(:,it)=Phitop(floor(end/2),:,it)-PhiBG;
% end %for
% dPhiline=dPhiline';
%
%
% %% Check the center cut perturbations to see relative phasing
% figure;
% subplot(211)
% imagesc(t,x3,dneline')
% axis xy;
% datetick;
%
% subplot(212)
% imagesc(t,x3,dPhiline')
% axis xy;
% datetick;
%
% figure;
% necut=dneline(:,end/2);
% Phicut=dPhiline(:,end/2);
% plotyy(t,necut,t,Phicut);
