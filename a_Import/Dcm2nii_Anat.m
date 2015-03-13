% for functional runs, convert dicom to analyze or nifti format & rename


clear all
clear mex
clc


%% ====== SETTINGS ============================================
subs=[4];
mriFldr='/Volumes/Ernie/dev/nipype/extrapTutorialData/mriData';

frmt= 'nii'; % 'img' or 'nii'
%% -------------------------------------------------------------
spm_get_defaults;


for s=1:numel(subs)
    sub=subs(s)
    
    
    inFldr=filenames([mriFldr '/s' sprintf('%3.3d',sub) '/raw/*mpr_sag*'],'char');
    
    %       cd([fold  '/run' num2str(run)]);
    files=filenames([inFldr '/*.dcm'],'char');
    hdr = spm_dicom_headers(files);
    out_fldr=[mriFldr '/s' sprintf('%3.3d',sub) '/anat'];
    if ~exist(out_fldr,'dir');mkdir(out_fldr);end
    cd(inFldr)
    spm_dicom_convert(hdr,'all','flat',frmt); % (hdr,opts,root_dir,format)
    newFiles=filenames([inFldr '/*.nii'],'char');
    % move files to new dir
    nFiles=length(newFiles(:,1));
    for i=1:nFiles
        [p,old_nii_name,e]=fileparts(newFiles(i,:));
        movefile( newFiles(i,:),[out_fldr '/s' sprintf('%3.3d',sub) '_' old_nii_name(end-6:end-3) '.nii'])
    end
    
    
    
    disp(['finished renaming ' num2str(nFiles)  ' files']);
    disp(' ');
end
