% zip all the old "dev" files. (don't zip hidden, don't zip "smooth"
function k_batch_zip(subs,runs,mriFldr)

for s=1:numel(subs)
   sub=subs(s);
   for r=1:numel(runs)
       run=runs(r);
      
      rootfolder=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run)];
      cd(rootfolder)
      
      folders=dir();
      folders = folders([folders.isdir]);
      folders(strncmp({folders.name}, '.', 1)) = [];
      folders(strncmp({folders.name}, 'sm', 2)) = [];
      folders(strncmp({folders.name}, 'motion', 2)) = [];
      folders(strncmp({folders.name}, 'norm', 2)) = [];
      folders(strncmp({folders.name}, 'qc', 2)) = [];
      
      zip('dev',{folders.name})
      for i=1:numel(folders)
         
         rmdir(folders(i).name,'s')
      end
      
   end
   
   % zip raw
   cd([mriFldr '/s' sprintf('%3.3d',sub)]);
   %    !zip  -r raw raw
   zip('raw','raw')
   % %    !rm -R raw
   try
       rmdir('raw','s')
   end
end