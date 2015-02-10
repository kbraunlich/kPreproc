% quickly create mean anatomical images for subs, given standard file structure

function kMeanAnat(subs,mriFldr)
%%

if nargin<2
    mriFldr=uigetdir(pwd,'select mriFldr');
end
if nargin<1
    subs=input('enter sub numbs: ');
end
%%
for s=1:numel(subs)
    sub=subs(s);
    imgs(s,:)=filenames([mriFldr sprintf('/s%.3d',sub) '/anat/wmask*.nii'],'char');
    
end
disp(imgs)
k=input('look good? (2=no)');
if k==2
    error('stopped')
end

%%
dat=kLoadNiis(imgs);
mnDat=mean(dat.dat,2);
mnV=reshape(mnDat,dat.im0001.h.dim);

h=dat.im0001.h;
h.fname=[mriFldr '/mean.nii'];

spm_write_vol(h,mnV)
