%% Add the Project folder and subfolders to Search Path
% restoredefaultpath;
% mydir = pwd;
% idcs  = strfind(mydir,filesep);
% Proj  = mydir(1:idcs(end)-6);
% addpath(genpath(Proj));

% if you want to save or read any files
% Proj is the path to folder contains (Codes, DataBase, Records)
% So start from it then navigate to where you want
% Example:
% dir(Proj + "DataBase\MFCC_Coeff\Test\*\G03S2M22M*T.mat");
% loads all .mat files of S2 childs and so on
clearvars -except Proj
%% Male Tests
Test = ["G03S1M22W" "G03S1M24W" "G03S2M22M" "G03S2M52W" ...
        "G03S3M20M" "G03S4M21W" "G03S4M22W" ...
        "G03S5M35W" "G03S5M56W"];
%% Male Reference
MFCC_ref = dir(Proj + "DataBase\MFCC_Coeff\Ref\*\G03S3M22M*R.mat");
%% load test
MFCC_test = cell(9,1);
for i = 1 : 9
    MFCC_test{i} = dir(Proj + "DataBase\MFCC_Coeff\Test\*\"...
              + Test(i) + "*T.mat");
end
%% DTW between tests and ref
% distance = zeros(47,1);
% for t = 1 : 9
%     for i = 1 : 47
%         MFCC_w1 = load(MFCC_ref(i).name);
%         MFCC_w2 = load(MFCC_test{t}(i).name);
%         distance(i) = dtw(MFCC_w1.MFCC_data',MFCC_w2.MFCC_data');
%     end
% writematrix(distance,Proj + "DataBase\Word_Scores\Male\" + ...
%                             Test(t) + "_DTW.txt");
% end
%% Cross DTW
Distance = zeros(46,2);
for t = 1 : 9
w = 1;
% Test Word 1 with Ref Word 1 then Word 2
for p = 1 : 2 :45    
    MFCC_Ref_w1  = load(MFCC_ref(w).name);
    MFCC_Ref_w2  = load(MFCC_ref(w+1).name);
    MFCC_Test_w1 = load(MFCC_test{t}(w).name);
    %p1w1 test with p1w1 ref
    Distance(p,1) = dtw(MFCC_Test_w1.MFCC_data',MFCC_Ref_w1.MFCC_data');
    %p1w1 test with p1w2 ref
    Distance(p,2) = dtw(MFCC_Test_w1.MFCC_data',MFCC_Ref_w2.MFCC_data');
w = w + 2;
end
% Test Word 2 with Ref Word 2 then Word 1
w = 2;
for p = 2 : 2 :46    
    MFCC_Ref_w2  = load(MFCC_ref(w).name);
    MFCC_Ref_w1  = load(MFCC_ref(w-1).name);
    MFCC_Test_w2 = load(MFCC_test{t}(w).name);
    %p1w1 test with p1w1 ref
    Distance(p,1) = dtw(MFCC_Test_w2.MFCC_data',MFCC_Ref_w2.MFCC_data');
    %p1w1 test with p1w2 ref
    Distance(p,2) = dtw(MFCC_Test_w2.MFCC_data',MFCC_Ref_w1.MFCC_data');
w = w + 2;
end
Word = [];
for j = 1 : 23
for i = 1 : 2
    Word = [Word; "P"+j+"W"+i];
end
end
Same = Distance(:,1);
Opposite = Distance(:,2);
T = table(Word,Same,Opposite);
writetable(T,Proj + "DataBase\Word_Scores\Male\" + Test(t) + "_DTW.xlsx");
end