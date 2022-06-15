function plot_satellite_tracks(file, plot_format)

narginchk(1,2)

if nargin < 2
  plot_format = {};
end

assert(~verLessThan('matlab', '9.7'), 'Matlab >= R2019b')

load(expanduser(file), 'nesat', 'Tisat', 'Tesat', 'J1sat', 'visat', 'glatsat', 'glonsat')

[lorb,lsats]=size(nesat);
istart=50;                         %cuts out interpolation crap at the beginning of the simulation
isats=1:lsats;                     %choose which satellites to compare

[theta,phi]=gemini3d.geog2geomag(glatsat,glonsat);
% mlatsat=90-theta*180/pi;
% mlonsat=phi*180/pi;


% %COMPUTE A LAGGED TIME IN CASE WE WANT THAT
% satlag=linspace(0,180,12)/86400;   %define a set of lags for successive satellite passes
% datesatlag=zeros(lorb,lsats);
% for isat=1:lsat
%    datesatlag(:,isat)=(datesat(:)-satlag(isat)-datesat(1))*86400;
% end


%% MAKE THE PLOTS
fg1 = figure(1);
clf(fg1)
%set(fg1,'PaperPosition',[0 0 14 8.5]);

t = tiledlayout(5,1, 'parent', fg1, 'TileSpacing', 'none');
%plot(datesatlag(istart:end,isats),nesat(istart:end,isats));
%xlabel('time (s)');
ax=nexttile;
plot(glatsat(istart:end,isats),nesat(istart:end,isats));
xticklabels(ax,{})
ylabel('n_e')

ax=nexttile;
%plot(datesatlag(istart:end,isats),Tisat(istart:end,isats));
%xlabel('time (s)');
plot(glatsat(istart:end,isats),Tisat(istart:end,isats));
xticklabels(ax,{})
ylabel('Ti')

ax=nexttile;
%plot(datesatlag(istart:end,isats),visat(istart:end,isats));
%xlabel('time (s)');
plot(glatsat(istart:end,isats),visat(istart:end,isats));
xticklabels(ax,{})
ylabel('v_i')

ax=nexttile;
%plot(datesatlag(istart:end,isats),J1sat(istart:end,isats));
%xlabel('time (s)');
plot(glatsat(istart:end,isats),J1sat(istart:end,isats))
xticklabels(ax,{})
ylabel('J_{||}')

ax=nexttile;
%plot(datesatlag(istart:end,isats),J1sat(istart:end,isats));
%xlabel('time (s)');
plot(glatsat(istart:end,isats),Tesat(istart:end,isats))
xlabel(t, 'latitude')
ylabel(ax, 'T_e')

if any(strcmp(plot_format, 'eps'))
  exportgraphics(fg1, 'ARCS_sats.eps')
end
if any(strcmp(plot_format, 'png'))
	exportgraphics(fg1, 'ARCS_sats.png', 'Resolution', 300)
end


%% Now try a "color dot" plot
fg2 = figure(2);
clf(fg2)
ax = axes(fg2, 'nextplot', 'add');
for isat=1:numel(isats)
  scatter(ax, glonsat(istart:end, isat), glatsat(istart:end,isat), ...
     40, visat(istart:end,isat), 'filled')
  axis([-160,-135,62.5,72.5])
end %for
title(ax, 'ion velocity at satellite')
xlabel(ax, 'geographic longitude (deg.)')
ylabel(ax, 'geographic latitude (deg.)')
c=colorbar('peer', ax);
ylabel(c,'v_i @ orbital alt.')
%set(gca,'FontSize',16)
colormap(ax, 'bwr')

if any(strcmp(plot_format, 'eps'))
  exportgraphics(fg1, 'ARCS_synthdatmap.eps')
end
if any(strcmp(plot_format, 'png'))
	exportgraphics(fg1, 'ARCS_synthdatmap.png', 'Resolution', 300)
end

end % function
