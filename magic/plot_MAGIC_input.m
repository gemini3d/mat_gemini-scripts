% Plot MAGIC data prepped for input into GEMINI
direc="~/simulations/input/mooreOK_taper_neutrals/";
plotdir=strcat(direc,"/plots/");
mkdir(plotdir);

% Neutral grid
r=linspace(0,1800,900);
z=linspace(0,660,330);

% Read neutral files and plot vert. velocity
filelist=dir(direc);
figure(1);
t=0;
for ifile=1:numel(filelist)
    filename=filelist(ifile).name;
    filename=string(filename);
    if (~strcmp(filename,"simsize.h5") & ~strcmp(filename,".") & ...
            ~strcmp(filename,".DS_Store") & ~strcmp(filename,".."))
        vnz=h5read(strcat(direc,filename),"/dvnzall");
        imagesc(r,z,vnz);
        colormap("gray")
        caxis([-50,50])
        axis xy;
        xlabel("r (km)");
        ylabel("z (km)");
        title(sprintf("v_z (m/s) at %d s",t));
        colorbar;
        axis equal;
        axis tight;
        t=t+6;
        
        tstr=num2str(t);
        ndigits=floor(log10(t));
        while(ndigits<5)
            tstr=['0',tstr];
            ndigits=ndigits+1;
        end
        print("-dpng",strcat(plotdir,string(tstr),"s.png"),"-r300")
    else
        disp("...Skipping non-data file...");
    end
end %for