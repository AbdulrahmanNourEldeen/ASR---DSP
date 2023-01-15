function output = userRecord
recObj = audiorecorder(16000,16,1);
recDuration =3;
recordblocking(recObj,recDuration);
output = getaudiodata(recObj);
end

