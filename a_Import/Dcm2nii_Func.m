% for functional runs, convert dicom to analyze or nifti format & rename

clear all
clear mex
clc

%% ====== SETTINGS ============================================
subs=[4];
runs=[2];
skipped_vols=3;
mri_fldr='/Volumes/Sarapiqui/valueAcmltr/mriData';

frmt= 'nii';    % 'img' or 'nii'
nTRs=420;       % total (before drop)
%% -------------------------------------------------------------
run_names={['004_ep2d_pace_428v'],['005_ep2d_pace_428v'],'006_ep2d_pace_428v'};
spm_get_defaults;

for s=1:numel(subs)
    sub=subs(s);
    % find path to dicom:
    inFldr=([mri_fldr '/s' sprintf('%3.3d',sub) '/raw']);
    l=dir([inFldr '/*']);
    l = l(arrayfun(@(x) x.name(1), l) ~= '.');
    inFldr=[inFldr '/' l.name];
    disp(['inFldr: ' inFldr])
    
    for r=1:numel(runs)
        run=runs(r);
        cd([inFldr '/' run_names{run}]);
        files = spm_select('list', pwd, '\.dcm');
        files=files(skipped_vols+1:nTRs,:); 
        
        if numel(files(:,1))==0; error('no files found');end
        
        hdr = spm_dicom_headers(files);
        out_fldr=[mri_fldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/import'];
        disp(out_fldr);
        
        if ~exist(out_fldr,'dir');mkdir(out_fldr);end
        
        spm_dicom_convert(hdr,'all','flat',frmt); % (hdr,opts,root_dir,format)
        newFiles=dir('f*.nii');
        
        % check
        nFiles=length(newFiles);
        if nFiles~=nTRs-skipped_vols
            error('wrong number of files')
        end
        % move files to new dir
        for i=1:nFiles
            movefile([inFldr '/' run_names{run} '/' newFiles(i).name],[out_fldr '/' newFiles(i).name])
        end
        
        
        % rename files
        % =================================
        cd(out_fldr)
        % imported functional files will have a prefix 'f'
        old_nii_names = dir('f*.nii');
        for n = 1:length(old_nii_names)
            % need to count file name characters to determine the right
            % range
            % new file names will the the form of 'subjID-runx-0001.nii' PROB
            % CHANGE TO "name(26:28)"
            new_nii_name=['_s' sprintf('%3.3d',sub) '_r' num2str(run) '_' old_nii_names(n).name(end-9:end-7) '.nii'];
            
            %move niis
            movefile(old_nii_names(n).name,new_nii_name);
            
        end
        % ---------------------------------
        
        disp(['finished renaming ' num2str(nFiles) ' files']);
        disp(' ');
    end
end