%Work on realignment parameters
% To do:
% 1. De-mean the six
% 2. Add first deriatives of the six
% 3. Add squares of these twelve

for partNr = 121:165;
    try
        cd(['M:/projects/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run1']);
        rpFilename = ls('rp*.txt');
        rpOld = load(rpFilename);
        rpNew = detrend(rpOld,'constant'); %De-meaned
        TR = 2.25;
        rpNew(2:end,7:12) = diff(rpNew(:,1:6))/TR;
        rpNew(:,13:24) = rpNew(:,1:12).^2;
%         fid = fopen('realignmentFull.txt','w+');
%         fprintf(fid,'s',rpNew);
%         csvwrite('realignmentFull.txt',
        dlmwrite('realignmentFull.txt',rpNew,'\t');
%         save('realignmentFull.mat','rpNew');
        
        cd(['M:/projects/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/data_preprocessed/run2']);
        rpFilename = ls('rp*.txt');
        rpOld = load(rpFilename);
        rpNew = detrend(rpOld,'constant'); %De-meaned
        TR = 2.25;
        rpNew(2:end,7:12) = diff(rpNew(:,1:6))/TR;
        rpNew(:,13:24) = rpNew(:,1:12).^2;
%         save('realignmentFull.mat','rpNew');
        dlmwrite('realignmentFull.txt',rpNew,'\t');
    catch
        fprintf(['Failed participant ' num2str(partNr) '\n']);
    end
end