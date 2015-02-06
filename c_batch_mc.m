

function c_batch_mc(subs,runs,home_path,nFiles,zp)


for s=1:numel(subs)
    sub=subs(s);
    
    for r=1:numel(runs)
        run=runs(r);
        end_path=['/s' sprintf('%3.3d',sub) '/r' num2str(run) '/stc'];
        path=[home_path end_path];
        cd([home_path end_path])
        listG=dir('a*.nii');
        if length({listG.name})~=nFiles
            error(['wrong number of files in sub' sprintf('%3.3d',sub) ' run' num2str(run)]);
        end
        
        for i=1:length({listG.name})
            zipList{i}=listG(i).name;
            listG(i).name=[path '/' listG(i).name ',1'];
        end
        
        if zp==1
            zip('stc_og',zipList)
        end
        %%
        matlabbatch{1,1}.spm.spatial.realign.estwrite.data{1,r}={listG.name}';
        
        %%
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        
        matlabbatch{r+1}.cfg_basicio.cfg_mkdir.parent = {[home_path '/s' ...
            sprintf('%3.3d',sub) '/r' num2str(run) '/']};
        matlabbatch{r+1}.cfg_basicio.cfg_mkdir.name = 'mc';
        
    end
    spm_jobman('run', matlabbatch);
    %%
    for r=1:numel(runs)
        run=runs(r);
        if run==1
            movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/stc/mean*'],...
                [home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'])
        end
        movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/stc/ra*'],...
            [home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'])
        
        rpFldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/motion'];
        mkdir(rpFldr);
        
        movefile([home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/stc/rp*'],...
            [home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/motion'])
        
        %% plot
        disp(['plot motion for s' num2str(sub) ' run ' num2str(run)])
        mcFldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/motion'];
        normFldr=[home_path '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/mc'];
        files=filenames([normFldr '/*.nii']);
        file=files(1,:);
        h=spm_vol(char(file));
        voxSize=h.mat(1,1);
        kPlotMotion(mcFldr,voxSize,2);
%         close all
    end
end




