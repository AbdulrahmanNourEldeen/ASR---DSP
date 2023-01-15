%% Add the Project folder and subfolders to Search Path
restoredefaultpath;
mydir = pwd;
idcs  = strfind(mydir,filesep);
Proj  = mydir(1:idcs(end)-6);
addpath(genpath(Proj));

% if you want to save or read any files
% Proj is the path to folder contains (Codes, DataBase, Records)
% So start from it then navigate to where you want
% Example:
% dir(Proj + "DataBase\MFCC_Coeff\Test\*\G03S2M22M*T.mat");
% loads all .mat files of S2 childs and so on
clearvars -except Proj
%% Child Tests
Test = ["G03S1C09W" "G03S1C11W" "G03S2C07W" "G03S2C08W" ...
        "G03S3C06M" "G03S3C10M" "G03S4C09W" ...
        "G03S5C07W" "G03S5C08W"];
%% Child Reference
MFCC_ref = dir(Proj + "DataBase\MFCC_Coeff\Ref\*\G03S4C11W*R.mat");
%% load test
MFCC_test = cell(9,1);
for i = 1 : 9
    MFCC_test{i} = dir(Proj + "DataBase\MFCC_Coeff\Test\*\"...
              + Test(i) + "*T.mat");
end
%% Pair 1
pair = zeros(9,4);  % p1w1 with p1w1, p1w1 with p1w2
                    % p1w2 with p1w2, p1w2 with p1w1
Thresholds = zeros(23,2);
w = 1;
for p = 1 : 23
    
    MFCC_Ref_w1  = load(MFCC_ref(w).name);
    MFCC_Ref_w2  = load(MFCC_ref(w+1).name);
    
for t = 1 : 9
    
    MFCC_Test_w1 = load(MFCC_test{t}(w).name);
    MFCC_Test_w2 = load(MFCC_test{t}(w+1).name);
    %p1w1 test with p1w1 ref
    pair(t,1) = dtw(MFCC_Test_w1.MFCC_data',MFCC_Ref_w1.MFCC_data');
    %p1w1 test with p1w2 ref
    pair(t,2) = dtw(MFCC_Test_w1.MFCC_data',MFCC_Ref_w2.MFCC_data');
    %p1w2 test with p1w2 ref
    pair(t,3) = dtw(MFCC_Test_w2.MFCC_data',MFCC_Ref_w2.MFCC_data');
    %p1w2 test with p1w1 ref
    pair(t,4) = dtw(MFCC_Test_w2.MFCC_data',MFCC_Ref_w1.MFCC_data');

end
    
    % Pair 1 word 1 Threshold
    mid = median(pair(:,1:2),2);
    if any(mid > 1000)
        i = find(mid > 1000);
        Thresholds(p,1) = mean([mid(1:i-1); mid(i+1:end)]);
    else
        Thresholds(p,1) = mean(mid);
    end
    % Pair 1 word 2 Threshold
    mid = median(pair(:,3:4),2);
    if any(mid > 1000)
        i = find(mid > 1000);
        Thresholds(p,2) = mean([mid(1:i-1); mid(i+1:end)]);
    else
        Thresholds(p,2) = mean(mid);
    end
    w = w + 2;
end
Pair = strings(23,1);
for i = 1 : 23
    Pair(i) = "Pair " + i;
end
Word1 = Thresholds(:,1);
Word2 = Thresholds(:,2);
T = table(Pair,Word1,Word2);
writetable(T,Proj + "DataBase\Thresholds\Child_TH.xlsx");