%% FLAGS
flagplots=true;

%% LOAD AN EXAMPLE SIMULATION
direc='~/SDHCcard/ARCS/'
cfg = gemini3d.read.config(direc);
time = datetime(2017,03,02) + seconds(27300);
dat = gemini3d.loadframe(direc, "time", time);


%% FIND THE RESOLUTION OF THE GRID IN EACH OF THE PRINCIPLE DIRECTIONS
[dl1,dl2,dl3]= gemscr.setup.gridres(xg);


%% EVALUATE CONDUCTANCES
[sigP,sigH,sig0,SIGP,SIGH] = gemscr.postprocess.conductivity_reconstruct(time,dat,cfg, xg);


%% COMPUTE POTENTIAL MAPPING DISTANCES PER FARLEY, 1959
scaling=sqrt(sig0./sigP);
lpar=scaling.*min(dl2,dl3);


%% DIAGNOSTIC PLOTS
if (flagplots)
    figure;
    imagesc(xg.x2(3:end-2)/1e3,xg.x1(3:end-2)/1e3,log10(lpar(:,:,1)/1e3));
    axis xy;
    colorbar;
    xlabel('x_2');

    figure;
    imagesc(xg.x3(3:end-2)/1e3,xg.x1(3:end-2)/1e3,squeeze(log10(lpar(:,1,:)/1e3)));
    axis xy;
    colorbar;
    xlabel('x_3');

    figure;
    lpar_avg=mean(mean(lpar,3),2);
    semilogx(lpar_avg/1e3,xg.x1(3:end-2)/1e3);
    ylabel('x_1');
end %if


%% DEFINE A GRID BASED ON THE FARLEY MAPPING
x1min=min(xg.x1(3:end-2));
x1max=max(xg.x1(3:end-2));
ix1=1;
x1pot=[x1min];
while (x1pot(ix1)<x1max)
    dx1pot=interp1(xg.x1(3:end-2),lpar_avg,x1pot(ix1));
    x1pot(ix1+1)=min(x1pot(ix1)+dx1pot/5,x1max);
    ix1=ix1+1;
end %while


%% DIAGNOSTIC PLOTS
if (flagplots)
    figure;
    plot(x1pot(2:end)/1e3,diff(x1pot)/1e3,'o');
end %if


%% TEST FIDELITY OF DERIVATIES ON PROPOSED GRID
lx1pot=numel(x1plot);
x1trans=x1pot(floor(lx1pot/2));
Phismooth=1/2+1/2*tanh((xg.x1(3:end-2)-x1trans)/10e3);
Phidec=interp1(xg.x1(3:end-2),Phismooth,x1pot);
E1dec=gradient(Phidec,x1pot);


%E1dec(1)=(-Phidec(3)+4*Phidec(2)-3*Phidec(1))/(x1pot(3)-x1pot(1));    %2nd order BDF
