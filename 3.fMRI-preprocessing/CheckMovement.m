clear all;clc;
load('../subNums.mat');

threshold = 3.5/2;

% Old subs
for sub = oldsubs
    fprintf('Subject %i\n',sub);
    for run = 1:2
        filename = ls(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/rp*',sub,run));
        rp = dlmread(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename));
        rp_diff = diff(rp);
        for volume = 1:length(rp_diff)
            movDir = rp_diff(volume,1:3) > threshold;
            if sum(movDir) > 0
                fprintf('Sub %i, run %i, volume %i-%i, movement in dir %s\n',sub,run,volume,volume+1,num2str(movDir));
            end
        end
    end
end

% New subs
for sub = newsubs
    fprintf('Subject %i\n',sub);
    for run = 1:2
        filename = ls(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/rp*',sub,run));
        rp = dlmread(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename));
        rp_diff = diff(rp);
        for volume = 1:length(rp_diff)
            movDir = rp_diff(volume,1:3) > threshold;
            if sum(movDir) > 0
                fprintf('Sub %i, run %i, volume %i-%i, movement in dir %s\n',sub,run,volume,volume+1,num2str(movDir));
            end
        end
    end
end

% Plot rps of specific subject/run
sub = 138;
run = 1;
filename = ls(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/rp*',sub,run));
rp = dlmread(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename));
figure;plot(rp);title(sprintf('Sub %i, run %i',sub,run));

% Plot rps of list of subs
for sub = newsubs
    for run = 1:2
        filename = ls(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/rp*',sub,run));
        rp = dlmread(sprintf('P:/3014018.02/3014018.02_jervbaa_%03d_001/data_preprocessed/run%i/%s',sub,run,filename));
        figure;plot(rp);title(sprintf('Sub %i, run %i',sub,run));
    end
end