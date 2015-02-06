% make folder directory structure to run the preproc scripts automatically.
% function makeDirs(subs,runs, mriFldr)
% %% setttings
% %su bs=[3];
% % runs=1:3;
% % mriFldr='/Volumes/Sarapiqui/valueAcmltr/mriData';

subs=input('enter sub numbers: ');
runs=input('enter run numbers: ');
mriFldr=uigetdir(pwd,'select the mriFldr')
%%
for s=subs
          sub_path=[mriFldr '/s' sprintf('%3.3d',s) ];

	mkdir([sub_path '/raw']);
   for r=runs
%       home_path=[];
      % anat
      mkdir([sub_path '/anat']);
      % runs
      mkdir([sub_path '/r' num2str(r) '/import']);
      
   end
end