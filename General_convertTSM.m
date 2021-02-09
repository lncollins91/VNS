% Processing for .tsm files to create a .avi movie and an individual .tiff file for
% each frame. 
% Laura Boddington Dec 2018 (Combo of Elliot's scripts)
%
% Requires Elliot's readTSMFile function 
% 
% 
%% Inputs
TotalFrames = 40000; %total frame number
XSize = 640; 
YSize = 640;
Fs = 30; %sampling rate

NSkipFrames = 0; %number of frames to skip (if any)
DSFrac = 0.25; %fraction for downsampling pixels

%% Read .TSM
[FileName, folder] = uigetfile('*.tsm','Select WF .tsm file.');  % Opens UI to find .tsm file
cd(folder) %changes directory to this folder
videoWF = readTSMFile(folder,FileName, XSize,YSize,TotalFrames,NSkipFrames,DSFrac); %reads .tsm file using Elliot's function
disp('Read .tsm file')

%% Convert .tsm to .avi
frame_matrix=videoWF_corr; %makes a copy of videoWF

% Remove the lowest 1% of every pixel
baseline = prctile(frame_matrix,1,3);
video_matrix = (frame_matrix - repmat(baseline,[1,1, size(frame_matrix,3)]));
video_matrix = double(video_matrix);

% Change the dynamic range of the image to have the lowest and highest 2% as
%the upper and lower thresholds.
lowthresh = prctile(video_matrix(:),2);
upperthresh = prctile(video_matrix(:),98)*2; %Why multiply by 2?
video_matrix = mat2gray((video_matrix), [lowthresh upperthresh]);

% Save movie
v = VideoWriter(strcat(FileName(1:length(FileName)-4),'.avi'),'Grayscale AVI');
open(v)
writeVideo(v,video_matrix(:,:,:));
close(v)
disp('AVI Saved')

%% Convert .avi to .tiff 
%this will take 10-20 minutes to process
obj = VideoReader(strcat(folder,'\',FileName(1:length(FileName)-4),'.avi'));
vid = read(obj);
frames = obj.NumberOfFrames;
for x = 1 : frames
    imwrite(vid(:,:,:,x),strcat('frame-',num2str(x),'.tif'));
end

disp('Tiff Files Saved')
