function GDIgrowth_inertia(direc, namedargs)
arguments
  direc (1,1) string
  namedargs.drift_velocity (1,1) double = 0.5e3 % [meters / sec]
  namedargs.magcap (1,1) double = 0 % magnetospheric capacitance
end
cwd = fileparts(mfilename('fullpath'));
run(fullfile(cwd, '../../setup.m'))

xg = gemini3d.read.grid(direc);
cfg = gemini3d.read.config(direc);
%% Pick a reference point to extract a line of density
x2=xg.x2(3:end-2);
x3=xg.x3(3:end-2);
ix1=find(xg.x1>300e3, 1);    %F-region location in terms of grid index
x2ref=-85e3;
%% Loop over data and pull in the density for main part of gradient
Nt = numel(cfg.times);
neline = nan(Nt, numel(x3));

for i = 1:Nt
  data = gemini3d.read.frame(direc, "time", cfg.times(i), "vars", ["ne", "Te", "Ti", "v1"]);
  t_elapsed = seconds(cfg.times(i) - cfg.times(1));
  x2now = x2ref + t_elapsed * namedargs.drift_velocity;    %moving
  ix2 = find(x2 > x2now, 1);

  neline(i,:) = data.ne(ix1,ix2,:);

  if i == 1
    % on the first time step compute the conductance and inertial capacitance for the simulation
    [sigP,sigH,sig0,SIGP,SIGH,incap,INCAP] = gemscr.postprocess.conductivity_reconstruct(cfg.times(i), data, cfg, xg);

    % mean relaxation parameter over entire grid, first time step
    nutilde = mean(SIGP(:)./(INCAP(:)+ namedargs.magcap));
    % FIXME:  hardcoded magnetospheric capacitance, should be read from input file
  end %if
end % for

%% Compute amplitude of fluctuations (BG subtract)
dneline = zeros(size(neline));
meanne = zeros(Nt,1);
for i = 1:Nt
  meanne(i) = mean(neline(i,:));
  dneline(i,:) = neline(i,:) - meanne(i);
end
%% Fluctuation average and relative change
% The GDI growth rate
nepwr = std(dneline, 0, 2);   %compute a standard deviation along the x2-direction on the grid (tangent to gradient)
nerelpwr = nepwr ./ meanne;

%% Evaluate time constant empirically from the simulation output
tconsts=log(nepwr);       % time elapsed measured in growth times
dtconsts=diff(tconsts);   % difference in time constants between outputs
itslinear = find(nerelpwr < 0.1, 1, 'last');
itmin=5;                  % first few frames involve settling and decay of applied noise
avgdtconst=mean(dtconsts(itmin:itslinear));   %average time constants elapsed per output, only use times after itmin output to allow settling from initial condition
growthtime = cfg.dtout/avgdtconst;


%% Growth rate from linear estimate Im{omega} = sqrt(nutilde*E/(B*ell))

% inertial limit, 0.5 km/s drift, gradient scale ~ 10km, hardcoded specific user defined choices here... OR FIXME:  read in config.nml file and figure it out...
%gamma=sqrt(nutilde*0.5e3/10e3);    % yikes not very accurate compared to full growth rate expression...
gamma=-nutilde/2+1/2*sqrt(nutilde^2+4*nutilde*0.5e3/10e3);

fig1 = make_figure1(cfg.times, itmin, gamma, growthtime, nerelpwr);

fig2 = make_figure2(xg, x3, dneline);

fig3 = make_figure3(cfg.times, itmin, nepwr, gamma, growthtime);

end % function


function fig = make_figure1(times, it_min, gamma, growth_time, ne_rel_pwr)
lineargrowthtime = 1/gamma;
linear_nerelpwr = ne_rel_pwr(it_min) * exp(gamma*seconds(times - times(it_min)));
%% Do some basic plot containing this info (avg'd over space)
fig = figure;
ax = axes(fig);
hold on;
plot(times,100*ne_rel_pwr);    % growth from simulation
plot(times,100*linear_nerelpwr);    %pure linear growth
hold off;

legend(ax, {'simulation','linear growth'})
xlabel(ax, 'UT');
ylabel(ax, '% variation from background (avg.)');
title(ax, sprintf('Theoretical \\tau:  %d; model \\tau:  %d',lineargrowthtime,growth_time));

end % function


function fig = make_figure2(xg, x3, dneline)

%% Break down the growth according to wavenumber
dx = xg.x3(2)-xg.x3(1);            %grid spacing
M = 2*numel(x3)-1;                     %number of spatial samples in acf
k = 2*pi* (-(M-1)/2:(M-1)/2) / M /dx;  %wavenumber axis for fft
Nt = size(dneline, 1);
Snn = zeros(Nt, numel(k));
for i = 1:Nt
  acfne = xcorr(dneline(i,:));           %autocorrelation function (spatial) of density variations at this time
  Snn(i,:) = fftshift(fft(acfne));         %power spectral density, no window
end
Snn_mag = abs(Snn);
Snn_mag(:, numel(x3))=NaN;

%% Plot wavenumber dependent growth
fig = figure;

its = 2*[2,4,6,8,10,12];
t = tiledlayout(fig, 1, 2);
ax = nexttile();
plot(ax, x3, dneline(its,:));
xlabel(ax, 'horizontal distance (m)');
ylabel(ax, '\Delta n_e');
for i=1:numel(its)
  leg{i} = sprintf('%d s', its(i)*10); %#ok<AGROW>
end
legend(ax, leg);

ax = nexttile(t);
semilogy(ax, k, Snn_mag(its,:));
xlabel(ax, 'wavenumber (1/m)');
ylabel(ax, '\Delta n_e power spectral density');

end % function


function fig = make_figure3(times, it_min, ne_pwr, gamma, growth_time)
%% Log plot absolute growth of irregularities
lineargrowthtime = 1/gamma;
fig = figure();

ax = axes(fig);
ref_val = ne_pwr(it_min);
linear_neabspwr = ref_val*exp(gamma*seconds(times - times(it_min)));

semilogy(ax, times(it_min:end), ne_pwr(it_min:end),'LineWidth',1.5);

xlabel(ax, 'UT')
ylabel(ax, 'Fluctuation amplitude (m^{-3})')

hold on;
semilogy(ax, times(it_min:end), linear_neabspwr(it_min:end),'o','LineWidth',1.5)
hold off;

leglinear=sprintf('linear growth; \\tau = %4.2f s', lineargrowthtime);
legsim=   sprintf('simulation growth; \\tau = %4.2f s', growth_time);
legend(legsim,leglinear,'Location','SouthEast')

end % function
