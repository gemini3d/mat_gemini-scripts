%% Load output magnetic field data from two simulations
basedir='~/Downloads/';
sim=[basedir,'iowa3D_hemis_medres2/'];
simcontrol=[basedir,'iowa3D_hemis_medres2_control/'];


%% Load/store the control data
load([simcontrol,'/magfields.insitu.mat']);
Brt_control=Brt;
Bthetat_control=Bthetat;
Bphit_control=Bphit;


%% Diff from the perturbation simulation
load([sim,'/magfields.insitu.mat']);
Brt=Brt-Brt_control;
Bthetat=Bthetat-Bthetat_control;
Bphit=Bphit-Bphit_control;


%% Create a diff dataset
save([sim,'/magfields.insitu.diff.mat'],'Brt','Bthetat','Bphit','mlat','mlon','simdate_series','mloc');