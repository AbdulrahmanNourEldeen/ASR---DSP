DTW_data = readtable('E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Word_Scores\Male\G03S5M56W_DTW.xlsx');
threshold_data = readtable('E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Thresholds\Male_TH.xlsx');
opts = detectImportOptions('E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Result_table\Male_accuracy.xlsx');
opts = setvartype(opts,'string');
final_results = readtable('E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Result_table\Male_accuracy.xlsx',opts);
name = 'E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Result_table\G03S5M56W_Results.xlsx';
P = 1;
W = 1;
Correctness = cell(23,3);
for i = 1:46
    DTW = table2array(DTW_data(i,2));
    threshold = table2array(threshold_data(P,W+1));
    Correctness(P,1) = {'Pair '+ string(P)};
    num = str2double(table2array(final_results(2*P-1+(W-1),4)));
    final_results(2*P-1+(W-1),4) = array2table(num+1);
    if DTW <= threshold
        Correctness(P,W+1) = {'Correct'};
        num = str2double(table2array(final_results(2*P-1+(W-1),8)));
        final_results(2*P-1+(W-1),8) = array2table(num+1);
        if W ==1
           num = str2double(table2array(final_results(2*P-1+(W-1),7)));
           final_results(2*P-1+(W-1),7) = array2table(num+1);
        else
           num = str2double(table2array(final_results(2*P-1+(W-1),6)));
           final_results(2*P-1+(W-1),6) = array2table(num+1);
        end
    else
        Correctness(P,W+1) = {'Wrong'};
        num = str2double(table2array(final_results(2*P-1+(W-1),9)));
        final_results(2*P-1+(W-1),9) = array2table(num+1);
        DTW_2 = table2array(DTW_data(i,3));
        if W ==2
           threshold_2 = table2array(threshold_data(P,W));
        else
           threshold_2 = table2array(threshold_data(P,W+2));
        end
        if DTW_2 <= threshold_2
            if W ==1
              num = str2double(table2array(final_results(2*P-1+(W-1),6)));
              final_results(2*P-1+(W-1),6) = array2table(num+1);
            else
              num = str2double(table2array(final_results(2*P-1+(W-1),7)));
              final_results(2*P-1+(W-1),7) = array2table(num+1);
            end
        else
            num = str2double(table2array(final_results(2*P-1+(W-1),5)));
            final_results(2*P-1+(W-1),5) = array2table(num+1);
        end
    end
    if W == 2
        P = P+1;
        W = 1;
    else
        W = W+1;
    end
end
Correctness = cell2table(Correctness);
Correctness.Properties.VariableNames = ["Pair","Word 1","Word 2"];
total_1 =0;
total_2 =0;
total_3 =0;
for i=1:46
    num = str2double(table2array(final_results(i+(W-1),4)));
    total_1 = total_1 +num;
    num = str2double(table2array(final_results(i+(W-1),8)));
    total_2 = total_2 +num;
    num = str2double(table2array(final_results(i+(W-1),9)));
    total_3 = total_3 +num;
end
final_results(47,4) = array2table(total_1);
final_results(47,8) = array2table(total_2);
final_results(47,9) = array2table(total_3);
final_results(48,8) = array2table(total_2*100/(total_2+total_3));
final_results(48,9) = array2table(total_3*100/(total_2+total_3));
writetable(final_results,'E:\EECE_2023_4thyear_1stterm\DSP\Voice\Database\Result_table\Male_accuracy.xlsx');
writetable(Correctness,name);