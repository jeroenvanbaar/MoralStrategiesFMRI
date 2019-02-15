function CheckMovementParatemeters(SUBJECT_NUMBER,SESSION_NUMBER)
% CheckMovementParameters(subject_number, session_number) creates simple
% plots of the 6 movement parameters created during realignment
%
% Plots are saved under the data_quality_checks folder


% get subject's folders:
s = GetSubjectProperties(SUBJECT_NUMBER,SESSION_NUMBER);
dirOutput = s.folderDataQualityChecks;
dirData = s.dataPreprocessedPath;

% get list of all rp_*.txt files of subject
unixCommand = sprintf('find %s -name ''rp_*.txt''',dirData);
[~, commandOut] = unix(unixCommand);
commandOut = strsplit(strtrim(commandOut),'\n'); % commandOut is one long char-vector, with \n in there, so we split it up

logFilename=sprintf('%s/CheckMovement_report_subject%i.txt',dirOutput,SUBJECT_NUMBER);
logFile = fopen(logFilename,'w');

for iFile = 1:length(commandOut)
    currentFilename = commandOut{iFile};
    
    [x,y,z,pitch,roll,yaw] = textread(currentFilename,'%f %f %f %f %f %f', 'delimiter', ' ');
    
    lnth = length(x);
    minx = min(x); miny = min(y); minz = min(z); minp = min(pitch); minr = min(roll); minya = min(yaw);
    maxx = max(x); maxy = max(y); maxz = max(z); maxp = max(pitch); maxr = max(roll); maxya = max(yaw);
    
    %% to get the largest overall difference on any scale
    largest_range = max([maxx-minx,maxy-miny,maxz-minz,maxp-minp,maxr-minr,maxya-minya]);
    
    %to get the largest difference between consecutive volumes
    jumpx = max(abs(x(1:(lnth-1))-x(2:lnth)));% before minus after!
    jumpy = max(abs(y(1:(lnth-1))-y(2:lnth)));
    jumpz = max(abs(z(1:(lnth-1))-z(2:lnth)));
    jumpp = max(abs(pitch(1:(lnth-1))-pitch(2:lnth)));
    jumpr = max(abs(roll(1:(lnth-1))-roll(2:lnth)));
    jumpya = max(abs(yaw(1:(lnth-1))-yaw(2:lnth)));
    
    %% to plot everything:
    f1=figure('Position',[1 1 1000 800]);
    
    % translation
    subplot(2,2,1),
    plot([x,y,z]);
    title(sprintf('translation in x-y-z [mm]'));
    
    % diff(translation)
    subplot(2,2,2),
    plot([diff(x),diff(y),diff(z)]);
    title(sprintf('changes in x-y-z [mm]\nLargest Jump: %f',max([jumpx,jumpy,jumpz])));
    legend('x','y','z','location','Best')
    
    % rotation
    subplot(2,2,3),
    plot(pitch,'Color','cyan')
    hold on
    plot(roll,'Color','magenta')
    plot(yaw,'Color','yellow');
    title(sprintf('rotation [deg]'));
    xlabel('time [scans]');
    
    % diff(rotation)
    subplot(2,2,4),
    plot(diff(pitch),'Color','cyan')
    hold on
    plot(diff(roll),'Color','magenta')
    plot(diff(yaw),'Color','yellow');
    legend('pitch','roll','yaw','location','Best')
    title(sprintf('changes in rotation [deg]\nLargest Jump:%f',max([jumpp,jumpr,jumpya])));
    xlabel('time [scans]');
    
    % super-title
    suplabel(sprintf('Subject %i - Run %i',SUBJECT_NUMBER,iFile),'t');
    
    filenamePlot1 = sprintf('%s/MovementParameters_run%i.png',dirOutput,iFile);
    export_fig(filenamePlot1);
    
    close(f1);
    
    % and log some values to txt file
    fprintf(logFile,'Subject %i - Run %i:\n',SUBJECT_NUMBER,iFile);
    fprintf(logFile,'max([x,y,z]) = [%.2f, %.2f, %.2f]\n',max(x),max(y),max(z));
    fprintf(logFile,'max([pitch,roll,yaw]) = [%.2f, %.2f, %.2f]\n',max(pitch),max(roll),max(yaw));
    fprintf(logFile,'max(diff([x,y,z])) = [%.2f, %.2f, %.2f]\n',max(diff(x)),max(diff(y)),max(diff(z)));
    fprintf(logFile,'max(diff([pitch,roll,yaw])) = [%.2f, %.2f, %.2f]\n',max(diff(pitch)),max(diff(roll)),max(diff(yaw)));
    fprintf(logFile,'ranges([x,y,z,pitch,roll, yaw]) = [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n',maxx-minx,maxy-miny,maxz-minz,maxp-minp,maxr-minr,maxya-minya);
    
    %
    % There is no way to eliminate a unrestrained subject from moving in
    % the scanner. The amount of movement you are seeing is extremely
    % small. In the lab I work in, we use the following criteria: Total
    % movement -- 5mm, Total Rotation -- 5 degrees. Bad timepoints -- .75mm
    % movement or 1.5 degrees rotation (TR-TR difference in parameters). If
    % there are more than 15% bad points, then the run is bad. If the mean
    % motion (TR-TR difference) is greater than 0.2, then the run is bad.
    % Depending on the subject population, you might need to relax the last
    % value slightly.
    % Source: Donald McLaren
    % https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1305&L=spm&P=R67584&1=spm&9=A&I=-3&J=on&d=No+Match%3BMatch%3BMatches&z=4
    THRESHOLD_MOVEMENT_TR = 0.75;
    THRESHOLD_MOVEMENT_MEAN = 2;
    THRESHOLD_MOVEMENT_TOTAL = 5;
    THRESHOLD_ROTATION_TR = 1.5;
    THRESHOLD_ROTATION_TOTAL = 1.5;
    
    total_movements = sqrt( diff(x).^2 + diff(y).^2 + diff(z).^2  );
    total_rotations = sqrt( diff(pitch).^2 + diff(roll).^2 + diff(yaw).^2 );
    % movement checks
    if max(total_movements) > THRESHOLD_MOVEMENT_TR
        ind = find(total_movements >THRESHOLD_MOVEMENT_TR);
        for i=ind'
            fprintf(logFile,'Warning: excessive movement from one TR to next (from volume nr %i to next one): %f\n', i, total_movements(i));
        end
    end
    if mean(total_movements) > THRESHOLD_MOVEMENT_MEAN
        fprintf(logFile,'Warning: excessive mean movement from one TR to next: %f\n', mean(total_movements));
    end
    if sum(total_movements) > THRESHOLD_MOVEMENT_TOTAL
        fprintf(logFile,'Warning: excessive movement over whole run: %f\n',sum(total_movements));
    end
    % rotation checks
    if max(total_rotations) > THRESHOLD_ROTATION_TR
        ind = find(total_rotations >THRESHOLD_ROTATION_TR);
        for i=ind'
            fprintf(logFile,'Warning: excessive rotations from one TR to next (from volume nr %i to next one): %f\n', i, total_rotations(i));
        end
    end
    if sum(total_rotations) > THRESHOLD_ROTATION_TOTAL
        fprintf(logFile,'Warning: excessive rotations over whole run: %f\n',sum(total_rotations));
    end
    
end


fclose(logFile);