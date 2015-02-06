% for functional runs, convert dicom to analyze or nifti format & rename


clear all
clear mex
clc


%% ====== SETTINGS ============================================
subs=[4];
mri_fldr='/Volumes/Sarapiqui/valueAcmltr/mriData';

frmt= 'nii'; % 'img' or 'nii'
%% -------------------------------------------------------------
spm_get_defaults;


for s=1:numel(subs)
    sub=subs(s)
    
    
    inFldr=([mri_fldr '/s' sprintf('%3.3d',sub) '/raw']);
    l=dir([inFldr '/*']);
   
    l = l(arrayfun(@(x) x.name(1), l) ~= '.');
    inFldr=[inFldr '/' l.name];
    
    l2=dir([inFldr '/*mpr_sag*']);
    inFldr=[inFldr  '/' l2.name]
    
    cd([inFldr]);
    %       cd([fold  '/run' num2str(run)]);
    files = spm_select('list', pwd, '\.dcm');
    
    hdr = spm_dicom_headers(files);
    out_fldr=[mri_fldr '/s' sprintf('%3.3d',sub) '/anat'];
    if ~exist(out_fldr,'dir');mkdir(out_fldr);end
    
    spm_dicom_convert(hdr,'all','flat',frmt); % (hdr,opts,root_dir,format)
    newFiles=dir('*.nii');
    % move files to new dir
    nFiles=length(newFiles);
    for i=1:nFiles
        movefile([inFldr '/' newFiles(i).name],[out_fldr '/' newFiles(i).name])
    end
    
    
    % rename files
    % =================================
    cd(out_fldr)
    % imported functional files will have a prefix 'f'
    old_nii_names = dir('*.nii');
    for n = 1:length(old_nii_names)
        % need to count file name characters to determine the right
        % range
        % new file names will the the form of 'subjID-runx-0001.nii' PROB
        % CHANGE TO "name(26:28)"
        new_nii_name=['s' sprintf('%3.3d',sub) '_' old_nii_names(n).name(end-9:end-7)];
        
        new_nii_name = [new_nii_name '.nii'];
        %move niis
        movefile(old_nii_names(n).name,new_nii_name);
        
    end
    % ---------------------------------
    
    disp(['finished renaming ' num2str(nFiles)  ' files']);
    disp(' ');
end
