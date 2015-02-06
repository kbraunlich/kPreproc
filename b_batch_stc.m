function b_batch_stc(subs,runs,home_path,nFiles,refSlice,sliceOrder,TR,nSlices,TA)
%%


% spm_jobman('initcfg')
for s=1:numel(subs)
    sub=subs(s);
    for r=1:numel(runs)
        run=runs(r);
        
        end_path=['/s' sprintf('%3.3d',sub) '/r' num2str(run) '/import'];
        path=[home_path end_path];
        cd([home_path end_path])
        list=dir('_s*.nii');
        list=list(1:nFiles);
        if length({list.name})~=nFiles
            error(['wrong number of files in sub' sprintf('%3.3d',sub) ' run' num2str(run)]);
        end
        for i=1:length({list.name})
            list(i).name=[path '/' list(i).name ',1'];
        end
        matlabbatch{1,1}.spm.temporal.st.scans{1,r}={list.name}';
        
       
       
    end
    matlabbatch{1}.spm.temporal.st.nslices = nSlices;
    matlabbatch{1}.spm.temporal.st.tr = TR;
    matlabbatch{1}.spm.temporal.st.ta = TA;
    matlabbatch{1}.spm.temporal.st.so = sliceOrder;
    matlabbatch{1}.spm.temporal.st.refslice = refSlice;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    
    spm_jobman('run', matlabbatch);
    
    %% movefiles
    for r=1:numel(runs)
        run=runs(r);
        stcFldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/stc'];
        mkdir(stcFldr);
        
        movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/import/a*'],...
            [stcFldr])
    end
end

