function i_batch_smooth(subs,runs,home_path,nFiles,kernelSize)
%%
script_path=cd;

for s=1:numel(subs)
   sub=subs(s);
   tmp=[];
   for r=1:numel(runs)
      run=runs(r);
      run_fldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/norm'];
      list=dir([run_fldr '/wra*nii']);
      for i=1:length({list.name})
         list(i).name=[run_fldr '/' list(i).name ',1'];
      end
      fList=[tmp;{list.name}'];
      tmp=fList;
   end
   
   if numel(fList)~= length(runs)*nFiles
      error('wrong number of input files')
   end
   matlabbatch{1}.spm.spatial.smooth.data = fList;
   %%
   matlabbatch{1}.spm.spatial.smooth.fwhm = repmat(kernelSize,1,3);%[6 6 6];
   matlabbatch{1}.spm.spatial.smooth.dtype = 0;
   matlabbatch{1}.spm.spatial.smooth.im = 0;
   matlabbatch{1}.spm.spatial.smooth.prefix = 's';
   spm_jobman('run', matlabbatch);
   for r=1:numel(runs)
       run=runs(r);
      destDir=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/smooth'];
      mkdir(destDir);
      movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/norm/swra*'],destDir);
   end
end
