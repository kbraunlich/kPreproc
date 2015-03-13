% for functional runs, convert dicom to analyze or nifti format & rename

clear all
clear mex
clc

%% ====== SETTINGS ============================================
subs=[3];
runs=[1:3];
skipped_vols=3;
mriFldr='/Volumes/Ernie/dev/nipype/extrapTutorialData/mriData';

frmt= 'nii';    % 'img' or 'nii'
nTRs=550;       % total (before drop)
%% -------------------------------------------------------------
run_names={['004_ep2d_pace_550v'],['005_ep2d_pace_550v'],'006_ep2d_pace_550v'};
spm_get_defaults;

for s=1:numel(subs)
    sub=subs(s);

    
    for r=1:numel(runs)
        run=runs(r);
        inFldr=filenames([mriFldr '/s' sprintf('%3.3d',sub) '/raw/*' run_names{run} '*'],'char');

        files=filenames([inFldr '/*.dcm'],'char')
        files=files(skipped_vols+1:nTRs,:); 
        
        if numel(files(:,1))==0; error('no files found');end
        
        hdrs = spm_dicom_headers(files);
        out_fldr=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/import'];
        disp(out_fldr);
        
        if ~exist(out_fldr,'dir');mkdir(out_fldr);end
        cd(inFldr)
        spm_dicom_convert(hdrs,'all','flat',frmt); % (hdr,opts,root_dir,format)
        newFiles=filenames([inFldr '/f*.nii'],'char');
        % check
        nFiles=length(newFiles(:,1));
        if nFiles~=nTRs-skipped_vols
            error('wrong number of files')
        end
        % move files to new dir
        for i=1:nFiles
            [p,oldname,e]=fileparts(newFiles(i,:));
            new_nii_name=['_s' sprintf('%3.3d',sub) '_r' num2str(run) '_' oldname(end-6:end-3) '.nii'];
            movefile([newFiles(i,:)],[out_fldr '/' new_nii_name])
        end
        
        
        disp(['finished renaming ' num2str(nFiles) ' files']);
        disp(' ');
    end
end
