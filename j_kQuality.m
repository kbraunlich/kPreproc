% this is just tors canlab_qw_metrics1 wrapped so that it is more convenient
% run for individual runs

function j_kQuality(mriFldr,sub, run)

% settings
%% ===========
qFldr=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/qc'];
if ~exist(qFldr,'dir');mkdir(qFldr);end

doplot = 1;
verbose = 1;
QC = [];
printfile = [];
noheader = 0;
% for i = 1:length(varargin)
%
%     if ischar(varargin{i})
%
%         switch varargin{i}
%             % functional commands
%             case 'noplot', doplot = 0;
%             case 'noverbose', doverbose = 0;
%             case 'noheader', noheader = 1;
%             case 'printfile', printfile = varargin{i+1}; varargin{i+1} = [];
%
%             otherwise, warning(['Unknown input string option:' varargin{i}]);
%         end
%     end
% end
runFldr=[mriFldr '/s' sprintf('%3.3d',sub) '/r' num2str(run) '/smooth'];
f=filenames([runFldr '/sw*.nii'],'char');

if iscell(f), f = strvcat(f{:}); end

idstr = f';
idstr = idstr(:);
if length(idstr) > 100, idstr = idstr(1:100); end

QC = struct('filenames', f(:)', 'idstr', idstr);
%all_outputs = {'filenames'};
all_outputs = {};

%%


mask_name = fmri_mask_image(f); % full mask with all valid voxels

dat=fmri_data(f,mask_name);

% Implicit mask
%% ------------------------------------------
if isa(mask_name, 'image_vector')
    
    fprintf('Calculating implicit mask: ');
    m = mean(dat);
    [dummy, dummy, nvox, is_inmask] = fmri_mask_thresh_canlab(m); %to use dip-based mask: fmri_mask_thresh_canlab(m, [],'dip');
    fprintf('%3.0f voxels in, %3.0f voxels out of mask.\n', nvox, sum(~is_inmask));
    
    out_of_mask_dat = dat.dat(~is_inmask, :);
    
    dat = remove_empty(dat, ~is_inmask, []);
    
    perc_mean_ghost = mean(out_of_mask_dat(:)) ./ mean(dat.dat(:));
    
end

% do this here; we will use in plot
snr = mean(dat.dat') ./ std(dat.dat');

% Plot data
%% ------------------------------------------
% close all
if doplot
    plot(dat);
    
    
    h = findobj('Tag', 'fmri data matrix');
    figure(h);
    subplot(2, 3, 6);
    [h, x] = hist(snr, 100);
    h = h ./ sum(h);
    plot(x, h, 'k', 'LineWidth', 3);
    
    title('SNR distribution (PDF)');
    figNums=findall(0,'type','figure');
    figure(figNums(1)); % bring to front
    set(gcf,'Position',get(0,'ScreenSize'))
    export_fig([qFldr sprintf('/s%3.3d_r%d.png',sub,run)])
    
    saveas(figNums(2),[qFldr '/s' sprintf('%3.3d',sub) '_r' num2str(run) '_mnSd.fig'],'fig')
    
end

%%
% Missing values
% ------------------------------------------

outnames = {'num_images', 'vox_vol', 'missing_vox', 'missing_images', 'missing_values'};
if exist('perc_mean_ghost', 'var'), outnames = [outnames 'perc_mean_ghost']; end

all_outputs = [all_outputs outnames];

dat = remove_empty(dat);

vox_dims = diag(dat.volInfo.mat(1:3, 1:3));
vox_vol = prod(abs(vox_dims));
num_images = size(dat.removed_images, 1);
missing_vox = sum(dat.removed_voxels);
missing_images = sum(dat.removed_images);

missing_values = sum(all(isnan(dat.dat) | dat.dat == 0, 2));

for i = 1:length(outnames)
    
    eval(['myvar = ' outnames{i} ';']);
    QC.(outnames{i}) = myvar;
    
end

% SNR
%% ------------------------------------------
outnames = {'mean_snr', 'mean_snr_per_mm', 'snr_inhomogeneity', 'snr_inhomogeneity95' 'rms_successive_diffs' 'rms_successive_diffs_inhomogeneity'};
all_outputs = [all_outputs outnames];

%snr = mean(dat.dat') ./ std(dat.dat');
mean_snr = mean(snr);
mean_snr_per_mm = mean_snr ./ vox_vol;

snr_inhomogeneity = std(snr);
snr_inhomogeneity95 = prctile(snr, 95) - prctile(snr, 5);

rmssd = ( diff(dat.dat') .^ 2 ./ size(dat.dat, 2) ) .^ .5; % rms at each voxel
rms_successive_diffs = mean(rmssd);

rms_successive_diffs_inhomogeneity = std(rmssd);

for i = 1:length(outnames)
    
    eval(['myvar = ' outnames{i} ';']);
    QC.(outnames{i}) = myvar;
    
end

% Asymmetry calculation
% ------------------------------------------
outnames = {'signal_rms_asymmetry', 'signal_hemispheric_asymmetry', 'snr_rms_asymmetry', 'snr_hemispheric_asymmetry'};
all_outputs = [all_outputs outnames];

dat = replace_empty(dat);
m = mean(dat.dat');
snr = m ./ std(dat.dat');

[signal_rms_asymmetry, signal_hemispheric_asymmetry] = calculate_asymmetry(dat, m);

[snr_rms_asymmetry, snr_hemispheric_asymmetry] = calculate_asymmetry(dat, snr);

for i = 1:length(outnames)
    
    eval(['myvar = ' outnames{i} ';']);
    QC.(outnames{i}) = myvar;
    
end


% Print
% ------------------------------------------
for i = 1:length(all_outputs)
    out(1, i) = mean(QC.(all_outputs{i}));
end

if ~isempty(printfile)
    diary(printfile);
end

if verbose || printfile
    if noheader
        % no header row
        print_matrix(out, [], {QC.idstr});
    else
        print_matrix(out, all_outputs, {QC.idstr})
    end
    
end
save([qFldr '/s' sprintf('%3.3d',sub) '_r' num2str(run) '_qc.mat'],'QC' )

if ~isempty(printfile)
    diary off
end

end % main function


%%

function [rms_asymmetry, hemispheric_asymmetry] = calculate_asymmetry(dat, snr)

xyz = round(voxel2mm(dat.volInfo.xyzlist', dat.volInfo.mat)');
isleft = xyz(:, 1) < 0;
isright = xyz(:, 1) > 0;
xyz(:, 1) = abs(xyz(:, 1));
[u1, indx1] = unique(xyz, 'first', 'rows');
[u2, indx2] = unique(xyz, 'last', 'rows');

if any(any(u1 - u2)), disp('Bug in asymmetry algorithm'); end
wh_unique = indx1 ~= indx2; % these have two distinct voxels with the same mm coordinates after rounding and abs x

lrdat = [snr(indx1(wh_unique)); snr(indx2(wh_unique))];

rms_asymmetry = sqrt( nansum(diff(lrdat) .^ 2) ./ size(lrdat, 2) ) ./ nanmean(lrdat(:));

tmpsnr = snr;
tmpsnr(~isleft) = NaN;
leftsnr = tmpsnr([indx1(wh_unique); indx2(wh_unique)]);
leftsnr = nanmean(leftsnr);

tmpsnr = snr;
tmpsnr(~isright) = NaN;
rightsnr = tmpsnr([indx1(wh_unique); indx2(wh_unique)]);
rightsnr = nanmean(rightsnr);

hemispheric_asymmetry = sqrt((leftsnr - rightsnr)^2 ./ 2) ./ sum([leftsnr rightsnr]);

end

%%

