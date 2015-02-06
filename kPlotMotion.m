
function kPlotMotion(mcFldr,voxSize,pauseAfterEach)
clf
% looks for [mcPath '/rp*' '.txt'], creates motion plot and saves in mcFldr
% (voxSize is scalar)
b=filenames([mcFldr '/rp*' '.txt'],'char');
% plot motion parameters from spm
% filt = ['^rp_*','.*\.txt$'];
% b = spm_select([Inf],'any','Select realignment parameters',[],pwd,filt);
if size(b,1)<1
     error([mcFldr '/rp*  not found'])
end
for i = 1:size(b,1)
   
   [~, name, ~] = fileparts(b(i,:));
   
   printfig = figure;
   set(printfig, 'Name', ['Motion parameters: ' name ], 'Visible', 'on');
   loadmot = load(deblank(b(i,:)));
   if numel(find(loadmot(:)>voxSize)>0)
       disp('%%%%%%%%%%%%%%%%%%%% MOTION %%%%%%%%%%%%%%%%%%%%%%%%%%')
       disp(name)
       disp('======================================================')
   end
   subplot(2,1,1);
   plot(loadmot(:,1:3));
   grid on;
%    ylim([-3 3]);  % enable to always scale between fixed values
   title(['Motion parameters: shifts (top, in mm) and rotations (bottom, in dg)'], 'interpreter', 'none');
   
   subplot(2,1,2);
   plot(loadmot(:,4:6)*180/pi);
   grid on;
%     ylim([-3 3]);
   title(['Data from ' name], 'interpreter', 'none');
   mydate = date;
   
   motname = [mcFldr filesep 'motion_sub' sprintf('%02.0f', i) '_' mydate '.png'];
   print(printfig, '-dpng', '-noui', '-r100', motname);
   if pauseAfterEach==1
       k=input('ok?');
   end
%    close(printfig)
end;

