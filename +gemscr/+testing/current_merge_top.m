% Try to patch together full grid data using information written out by
% individual workers.  

% manually set
lxs=[165,24,216];
lxs=lxs-1;
lparm=1;
lproc=6;
dimcat=2;

% collect info from each worker
parmall=[];
for iproc=0:lproc-1
    filename=['debug_output',num2str(iproc),'.dat'];
    
    fid=fopen(filename,'r');
    datparm=fread(fid,prod(lxs)*lparm,'real*8');
    parm=reshape(datparm,[lxs(1:3),lparm]);
    
    parmtop=fread(fid,prod([lxs(1),lxs(3),lparm]),'real*8');
    shp=[lxs(1:dimcat-1),1,lxs(dimcat+1:end),lparm];
    parm=cat(dimcat,parm,reshape(parmtop,shp));
    
    parmall=cat(dimcat,parmall,reshape(parm,[size(parm,1),size(parm,2),size(parm,3),lparm]));
    fclose(fid);
end %for