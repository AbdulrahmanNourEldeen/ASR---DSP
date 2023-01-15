function coefficient = G3MFCC(audio_in,FS)
TF = 25 *10^(-3); %frame time
N= FS*TF;
TS = 10 *10^(-3);%fram step necessary for overlapping
NS = FS*TS;
n_frames = floor(size(audio_in,1)/NS);
NFFT = 512;
audio_in = audio_in/max(audio_in);
for i =1:n_frames-2
    frame = audio_in((i-1)*NS+1:(i-1)*NS+N);
    frame = frame.*hamming(N);
    frame_fft = fft(frame,NFFT);
    mel_filter_bank = melbankm(22,NFFT,FS);
    half_FFT = 1+floor(NFFT/2);
    frame_freq_domain =log10(mel_filter_bank*abs(frame_fft(1:half_FFT)).^2);
    frame_freq_domain = max(frame_freq_domain,1e-22);
    frame_cepstrum = dct(frame_freq_domain);
    coefficient(i,:) = frame_cepstrum(1:14);
end
coefficient = coefficient';
for i=1:size(coefficient,1)
    AVG(i,1) = mean(coefficient(i,:));
end
AVG = repmat(AVG,1,size(coefficient,2));
coefficient = (coefficient - AVG)';
end