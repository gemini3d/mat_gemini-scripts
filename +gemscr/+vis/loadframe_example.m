
%% LOAD (ONLY) PRE-FLIGHT EVENT
time = datetime(2017,3,2) + seconds(25496);

direc= '~/simulations/isinglass_clayton1';     %where you've put the data
dat = gemini3d.read.frame(direc, time=time);


% %% LOAD FLIGHT EVENT
% UTsec=28400;
% ymd=[2017,3,2];
% direc=[basedir,'isinglass_clayton3/'];     %where you've put the data
% dat = gemini3d.read.frame(direc, time=time);


% %% LOAD AND PLOT THE PRE-FLIGHT EVENT (unfortunately this only plots so you don't get stuff in the workspace)
% UTsec=25496;
% ymd=[2017,3,2];
% direc=[basedir,'isinglass_clayton1/'];     %where you've put the data
% xg = plotframe(direc,ymd,UTsec);
