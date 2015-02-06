f=filenames('*.nii','char');
ims=kLoadNiis(f);

h=ims.im0001.h ;

meanIm=mean(ims.dat,2);
meanV=reshape(meanIm,h.dim);
%%
for i=421:428
    
    h.fname=['_s004_r2_' num2str(i) '.nii'];
    
    spm_write_vol(h,meanV)
end
    