function d_batch_coreg(subs,runs,home_path,nFiles,zp,save_mats)

script_path=cd;

for s=1:numel(subs)
   sub=subs(s);
   anat=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/s' sprintf('%3.3d',sub) '*.nii']);
   % reference
   matlabbatch{1}.spm.spatial.coreg.estimate.ref = ...
      {[home_path '/s' sprintf('%3.3d',sub) '/anat/' anat.name ',1']};
   % source
   srce=dir([home_path '/s' sprintf('%3.3d',sub) '/r1/mc/meana*' sprintf('%3.3d',sub) '*.nii']);
   matlabbatch{1}.spm.spatial.coreg.estimate.source = ...
      {[home_path '/s' sprintf('%3.3d',sub) '/r1/mc/' srce.name ',1']};
   %%
   tmp=[];
   for r=1:numel(runs)
      run=runs(r);
      % just all the images in one cell:
      % ====================================
      run_fldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'];
      list=dir([run_fldr '/ra*nii']);
      for i=1:length({list.name})
         zipList{i}=list(i).name;
         list(i).name=[run_fldr '/' list(i).name ',1'];
      end
      fList=[tmp;{list.name}'];
      tmp=fList;
      
      
   end
   
   matlabbatch{1}.spm.spatial.coreg.estimate.other=fList;
   
   %%
   matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
   matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
   matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
   matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
   
   spm_jobman('run', matlabbatch);
end
