% Try to patch together full grid data using information written out by
% individual workers.  

% manually set
lxs=[98,32,144];
lparm=1;
lproc=4;
dimcat=2;

% collect info from each worker
parmall=[];
for iproc=0:lproc-1
    filename=['~/Projects/GEMINI/build/debug_output',num2str(iproc),'.dat'];
    fid=fopen(filename,'r');
    datparm=fread(fid,prod(lxs)*lparm,'real*8');
    parm=reshape(datparm,[lxs(1:3),lparm]);
    parmall=cat(dimcat,parmall,reshape(parm,[lxs(1:3),lparm]));
    fclose(fid);
end %for

% look at a slice and take diffs to emphasize tearing...
parmplot=squeeze(parmall(15,:,:));
diffparm=diff(parmplot,1,1);
figure, imagesc(diffparm)