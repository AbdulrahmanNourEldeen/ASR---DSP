clear

name = "G03S4F50W.wav";

[data, fs] = audioread(name); 
idx = detectSpeech(data,fs);
for i = 1:47
    a = idx(i,1) - fs;
    b = idx(i,2) + fs;
    word{i} = data( a : b);
    w = silence_removal(word{i},0,fs);
    audiowrite(i + ".wav",w,16000);
end

naming(name);