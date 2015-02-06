% manual alignment
function a_align(subs,mri_fldr)

for s=1:numel(subs)
   sub=subs(s);
   anat_fldr=[mri_fldr '/s' sprintf('%3.3d',sub) '/anat'];
   imAnat=dir([anat_fldr '/s*' sprintf('%3.3d',sub) '*.nii']);
   anat_path=[anat_fldr '/' imAnat.name];
   matlabbatch{1}.spm.util.disp.data = {[anat_path ',1']};

    spm_jobman('run', matlabbatch);
    k=input(['Press ENTER when done setting parameters and selecting all imgs for sub ' sprintf('%3.3d',sub)]);
end