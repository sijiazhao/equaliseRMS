% Copyright (c) 2019, Sijia Zhao.  All rights reserved.
clear; close all;

path_in =  './Sounds/';
files = dir([path_in '*.wav']);
path_out = './Output/'; if exist(path_out) == 7; rmdir(path_out,'s'); end %#ok<EXIST>
mkdir(path_out);

x_rms=[];
xnew_rms=[];
for s = 1:numel(files)
    filename = [path_in files(s).name];
    [signal,~] = audioread(filename);
    x_rms(s) = rms(signal);
end

target_rms = min(x_rms); 

for s = 1:length(files)
    filename = [path_in files(s).name];
    [signal,fs] = audioread(filename);
    
    signal = signal*target_rms/rms(signal);
    
    %check that there is no clipping
    if (max(abs(signal))>1)
        error ( ['... Clipping!!!! Reduce target RMS and check sound ' files(s).name] )
    end
    
    filename = [path_out,'RMSeq_' files(s).name];
    audiowrite(filename, signal, fs);
end

for s = 1:numel(files)
    filename = [path_out,'RMSeq_' files(s).name];
    [signal,~] = audioread(filename);
    xnew_rms(s) = rms(signal);
end

% figure(1);clf;
% for s = 1:numel(files)
%     filename = [path_out,files(s).name];
%     [signal,fs] = audioread(filename);
%     subplot(numel(files),1,s);
%     timeaxis = [1:length(signal)]/fs;
%     plot(timeaxis,signal);
%     title(strrep(files(s).name,'_',' '));
% end
