function e_batch_seg(subs,mri_fldr,Save_mats)

script_path=cd;

for s=1:numel(subs)
   sub=subs(s);
   anat=dir([mri_fldr '/s' sprintf('%3.3d',sub) '/anat/s' sprintf('%3.3d',sub) '*.nii']);
   matlabbatch{1}.spm.tools.preproc8.channel.vols = {[mri_fldr '/s' sprintf('%3.3d',sub) '/anat/' anat.name ',1']};
   matlabbatch{1}.spm.tools.preproc8.channel.biasreg = 0.0001;
   matlabbatch{1}.spm.tools.preproc8.channel.biasfwhm = 60;
   matlabbatch{1}.spm.tools.preproc8.channel.write = [0 1];
   matlabbatch{1}.spm.tools.preproc8.tissue(1).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,1'};
   matlabbatch{1}.spm.tools.preproc8.tissue(1).ngaus = 2;
   matlabbatch{1}.spm.tools.preproc8.tissue(1).native = [1 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(1).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(2).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,2'};
   matlabbatch{1}.spm.tools.preproc8.tissue(2).ngaus = 2;
   matlabbatch{1}.spm.tools.preproc8.tissue(2).native = [1 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(2).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(3).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,3'};
   matlabbatch{1}.spm.tools.preproc8.tissue(3).ngaus = 2;
   matlabbatch{1}.spm.tools.preproc8.tissue(3).native = [1 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(3).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(4).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,4'};
   matlabbatch{1}.spm.tools.preproc8.tissue(4).ngaus = 3;
   matlabbatch{1}.spm.tools.preproc8.tissue(4).native = [1 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(4).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(5).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,5'};
   matlabbatch{1}.spm.tools.preproc8.tissue(5).ngaus = 4;
   matlabbatch{1}.spm.tools.preproc8.tissue(5).native = [1 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(5).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(6).tpm = {'/Users/kurtb/Documents/Matlab/spm8/toolbox/Seg/TPM.nii,6'};
   matlabbatch{1}.spm.tools.preproc8.tissue(6).ngaus = 2;
   matlabbatch{1}.spm.tools.preproc8.tissue(6).native = [0 0];
   matlabbatch{1}.spm.tools.preproc8.tissue(6).warped = [0 0];
   matlabbatch{1}.spm.tools.preproc8.warp.reg = 4;
   matlabbatch{1}.spm.tools.preproc8.warp.affreg = 'eastern';
   matlabbatch{1}.spm.tools.preproc8.warp.samp = 3;
   matlabbatch{1}.spm.tools.preproc8.warp.write = [0 1];
   
    spm_jobman('run', matlabbatch);
end