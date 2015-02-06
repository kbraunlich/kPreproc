

function g_batch_deformAnat(subs,~,home_path)

script_path=cd;


for s=1:numel(subs)
   sub=subs(s);
   anat_dfrm=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/y_s' sprintf('%3.3d',sub) '*.nii']);
   cd( [home_path '/s' sprintf('%3.3d',sub) '/anat']);
   matlabbatch{1}.spm.util.defs.comp{1}.def = {...
      [home_path '/s' sprintf('%3.3d',sub) '/anat/' anat_dfrm.name]};
   matlabbatch{1}.spm.util.defs.ofname = '';
   matlabbatch{1}.spm.util.defs.fnames = {[home_path '/s' sprintf('%3.3d',sub) ...
      '/anat/masked_s' sprintf('%3.3d',sub) '.nii,1']};
   matlabbatch{1}.spm.util.defs.savedir.savepwd = 1;
   matlabbatch{1}.spm.util.defs.interp = 3;
   spm_jobman('run', matlabbatch);
end

cd(script_path)