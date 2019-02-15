%Getting beta maps from work pc to laptop => Dartmouth
%Plan: making two zip files and uploading them to WeTransfer

for partNr = 121:165
    try
        cd(['M:/projects/3014018.02/3014018.02_jervbaa_' num2str(partNr) '_001/22_SingleTrialModel']);
        copyfile('beta_*',['C:/Users/jervbaa/Desktop/BetaMaps/' num2str(partNr) '/']);
    catch
        fprintf(['Failed participant ' num2str(partNr) '\n']);
    end
end