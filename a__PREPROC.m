% kPreproc toolbox
% ======================================================
% this is the primary script to access toolbox functions. 
% see the README file for instructions.
%
% kurt braunlich 2012


% study: valueAcmltr
% =====================
% echo time=30
% slice thickness=4
% TR=2
% spaceBetween slices=4
% flip angle=76
% NOTE -- eastern MNI template.
%% --------------

clear all;clear mex;clc
spm('defaults','fmri');
spm_jobman('initcfg');

%% Settings:
% -----------------------------------------
subs=[4];                                
runs=[1:3];                                  

nDropped=3;                                 % nVolumes dropped from beginning of each run
nFiles=428-nDropped;                        % nTotalVolumes-nDropped

TR=2;                                       % (seconds)
nSlices=33;                                 %
TA=TR-(TR/nSlices);                         %
refSlice=19;                                % 

fwhm=6;                                     % smoothing (scalar --assumes iso)

% slice order -----------------
sliceOrder=[1:2:nSlices 2:2:nSlices];       % ascending interleaved
% sliceOrder=[nSlices:-2:1,nSlices-1:-2:1];   % descending interleaved
% sliceOrder=1:1:nSlices;                     % ascending
% sliceOrder=nSlices:-1:1;                    % descending
% -----------------------------

ave_anat=2;                                 % 1= create averaged anat
q=2;                                        % 1= quit at end to allow sleep

home=pwd;
mriFldr='/Volumes/Sarapiqui/valueAcmltr/mriData';
script_fldr='/Volumes/Sarapiqui/valueAcmltr/scripts';
preproc_fldr=[ script_fldr '/kPreproc' ];
addpath(preproc_fldr);

tic

%% manual alignment 
% -----------------------------------------
a_align(subs,mriFldr);
disp('alignment done')

%% STC
% -----------------------------------------
b_batch_stc(subs,runs,mriFldr,nFiles,refSlice,sliceOrder,TR,nSlices,TA)
disp('stc done')
close all

% MC (estimate and reslice)
% -----------------------------------------
c_batch_mc(subs,runs,mriFldr,nFiles,0)
disp('mc done')

%% coregistration
% -----------------------------------------
d_batch_coreg(subs,runs,mriFldr,nFiles,0,0)
disp('coreg done')

%% anatomical segmentation
% -----------------------------------------
e_batch_seg(subs,mriFldr,0)
disp('seg done')

%% skull strip
% -----------------------------------------
f_batch_create_maskedAnat(subs,mriFldr);
disp('skull done')

%% deformation: anatomical
% -----------------------------------------
g_batch_deformAnat(subs,runs,mriFldr);
disp('seg anat done')

%% deformation:  functional 
% -----------------------------------------
h_batch_deformFuncs(subs,runs,mriFldr,nFiles);
disp('deform funcs done')

%% smooth
% -----------------------------------------
i_batch_smooth(subs,runs,mriFldr,nFiles,fwhm);
disp('smooth done')

%% quality assessment
% -----------------------------------------
for sub=subs
    for run=runs
        j_kQuality(mriFldr,sub, run)
    end
end
close all
disp('quality assessment done')

%% compress folders
% -----------------------------------------
k_batch_zip(subs,runs,mriFldr)

%% check registration
% -----------------------------------------
l_batch_checkReg(subs,runs,mriFldr,nFiles)

%% create mean anatomical
% -----------------------------------------
if ave_anat==1
    cd(mriFldr)
    cd ..
    spm_mean_ui
    V=spm_vol('mean.img');
    ima=spm_read_vols(V);
    delete('mean.img','mean.hdr')
    V.fname='mean.nii';
    spm_write_vol(V,ima);
end
%%
toc
if q==1
    quit % allow wimoweh to sleep
end