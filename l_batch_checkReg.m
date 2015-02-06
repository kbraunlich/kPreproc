function l_batch_checkReg(subs,runs,mriFldr,nFiles)

for s=1:numel(subs)
    sub=subs(s);
    imAnat=[mriFldr '/s' sprintf('%3.3d',sub) '/anat/wmasked_s' sprintf('%3.3d',sub) '.nii'];
    imCh2=which('ch2bet.nii');
    
    while 1
        %%
        for r=1:numel(runs)
            run=runs(r);
            rPull=randi(nFiles);
            fldr=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/smooth'];
            tmp=filenames([fldr '/sw*.nii'],'char');
            %             funcIms{run}=tmp(rPull,:);
            if r==1
                funcIms=char(tmp(rPull,:));
            else
                funcIms=char(funcIms,tmp(rPull,:));
            end
        end
        spm_check_registration(imCh2,imAnat,funcIms)
%                 suptitle(['sub' num2str(sub)])

        %%
        
        
        k=input(['Look at another set of random functionals from s' sprintf('%3.3d',sub)  '? (0=yes 1=no )']);
        
        if k==1
            break
        end
    end
end