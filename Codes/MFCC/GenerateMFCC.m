name = "E:\EECE_2023_4thyear_1stterm\DSP\Voice\Records\S4\Male 2\G03S4M21W";
namemfcc = "G03S4M21W_MFCC";
path_to_MFCC_File = "E:\EECE_2023_4thyear_1stterm\DSP\Voice\Records\S4\Male 2\MFCC\";
P =1;
W=1;
mkdir(path_to_MFCC_File);
for i=1:47
    if P<10
        [audio_in,FS]=audioread(name+"P0"+P+"W"+W+"T"+".wav");
    else
        [audio_in,FS]=audioread(name+"P"+P+"W"+W+"T"+".wav");
    end
    MFCC_data = mfcc(audio_in,FS);
    if P<10
        save(path_to_MFCC_File+namemfcc+"P0"+P+"W"+W+"T"+".mat",'MFCC_data');
    else
        save(path_to_MFCC_File+namemfcc+"P"+P+"W"+W+"T"+".mat",'MFCC_data');
    end
    if W ==2
        P = P+1;
        W=1;
    else
        W =W+1;
    end
end