function f_batch_create_maskedAnat(subs,home_path)

script_path=cd;
for s=1:numel(subs)
   sub=subs(s);
   file1=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/ms' sprintf('%3.3d',sub) '*.nii']);
   file2=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/c1s' sprintf('%3.3d',sub) '*.nii']);
   file3=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/c2s' sprintf('%3.3d',sub) '*.nii']);
   file4=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/c3s' sprintf('%3.3d',sub) '*.nii']);
   
   matlabbatch{1}.spm.util.imcalc.input = {
      [home_path '/s' sprintf('%3.3d',sub) '/anat/' file1.name ',1']
      [home_path '/s' sprintf('%3.3d',sub) '/anat/' file2.name ',1']
      [home_path '/s' sprintf('%3.3d',sub) '/anat/' file3.name ',1']
      [home_path '/s' sprintf('%3.3d',sub) '/anat/' file4.name ',1']
      };
   
   matlabbatch{1}.spm.util.imcalc.output = ['masked_s' sprintf('%3.3d',sub) '.nii'];
   matlabbatch{1}.spm.util.imcalc.outdir = {[home_path '/s' sprintf('%3.3d',sub) '/anat/']};
   matlabbatch{1}.spm.util.imcalc.expression = 'i1.*(i2+i3+i4)';
   matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
   matlabbatch{1}.spm.util.imcalc.options.mask = 0;
   matlabbatch{1}.spm.util.imcalc.options.interp = 1;
   matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

   spm_jobman('run', matlabbatch);
end