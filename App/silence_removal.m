% ra = 1 to read audio
% ra = 0 to start processing instantly
function data_r = silence_removal(x,ra,fs)
%%
if ra
    [data, fs] = audioread(x);   % read a sound file
else
    data = x;                    % x is input sound data
end
% normalize data
data = data / abs(max(data));
% do framing
f_d = 0.025;
f_size = round(f_d * fs);
n = length(data);
n_f = floor(n/f_size);  %no. of frames
temp = 0;
for i = 1 : n_f 
   frames(i,:) = data(temp + 1 : temp + f_size);
   temp = temp + f_size;
end

% silence removal based on max amplitude
m_amp = abs(max(frames,[],2)); % find maximum of each frame
id = find(m_amp > 0.03);       % finding ID of frames with max amp > 0.03
fr_ws = frames(id,:);          % frames without silence

% reconstruct signal
data_r = reshape(fr_ws',1,[]);
data_r = data_r/max(abs(data_r));    % for mono
end