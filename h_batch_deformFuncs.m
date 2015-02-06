

function h_batch_deformFuncs(subs,runs,home_path,nFiles)


script_path=cd;

for s=1:numel(subs)
   sub=subs(s);
   for r=1:numel(runs)
        run=runs(r);
      run_fldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'];
      list=dir([run_fldr '/ra*nii']);
      for i=1:length({list.name})
         list(i).name=[run_fldr '/' list(i).name ',1'];
      end
      fList=[{list.name}'];
      
      matlabbatch{r}.spm.util.defs.fnames = fList;
      deformMat=dir([home_path '/s' sprintf('%3.3d',sub) '/anat/y_s' sprintf('%3.3d',sub) '_*.nii'])
      matlabbatch{r}.spm.util.defs.comp{1}.def = ...
         {[home_path '/s' sprintf('%3.3d',sub) '/anat/' deformMat.name]};
      matlabbatch{r}.spm.util.defs.ofname = '';
      matlabbatch{r}.spm.util.defs.savedir.savesrc = 1;
      matlabbatch{r}.spm.util.defs.interp = 1;
      
   end
   
   spm_jobman('run', matlabbatch);
   
   for r=1:numel(runs)
       run=runs(r);
      destDir=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/norm'];
      mkdir(destDir);
      movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc/wra*'],destDir);
      
   end
end