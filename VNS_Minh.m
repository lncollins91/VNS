%% VNS analysis for Minh
%% Step 1: Choose files
% load Spike2 file (.mat)
cd('\\mammatus2\Widefield\Laura\Data')
[FileName, folder] = uigetfile('*.mat','Select Spike2 .mat file.');  
load(fullfile(folder,FileName))
disp('Spike2 file loaded.')
%Choose widefield imaging file (.tsm)
prompt ={'Enter number of frames collected.', 'Enter image width (x).','Enter image height (y).','Enter frame acquisition frequency (Hz).','Enter fraction to downsample.'};
    t = 'Input';
    dims = [1 200];
    definput = {'15000','640','640','50','0.25'};
    answer = inputdlg(prompt,t,dims,definput);
    TotalFrames = answer{1,1};
    XSize =answer{2,1};
    YSize = answer{3,1};
    Fs = answer{4,1};
    NSkipFrames = 0; %change if you would like to start process at a certain frame number
    DSFrac = answer{5,1};
[FileName, folder] = uigetfile('*.tsm','Select WF .tsm file.');  % Opens UI to find .tsm file
% name your file
prompt ={'Enter filename.'};
    t = 'Input';
    dims = [1 200];
    definput = {'0985_190401_500usPW_500ms_400uA_1st_190410'};
    answer = inputdlg(prompt,t,dims,definput);
    savename = answer{1,1};
answer
disp('Working...')
videoWF = readTSMFile(folder,FileName, XSize,YSize,TotalFrames,NSkipFrames,DSFrac);
[dF,UdF] = Calc_dFF(videoWF,Fs); % Global 10 percentile baseline
disp('Recording loaded and dF/F calculated.')

%% Step 2: Correct Spike2 traces and create resampled timeseries
disp('Please wait.')
[tsresam_encoder,tsresam_stim,tsresam_whisk,tsresam_lfp,tsresam_SU,tsresam_pupil,wfcam_tr,Resamp_r,Resamp_p,T]=CorrectSpike2(STIM,walk,whisk,SU,lfp_unit,Pupil,wfcam_tr);
disp('Resampled timeseries created.')
%% Step 3: Clip traces around stimulation onset
[pks,locs] = findpeaks(tsresam_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',Resamp_r*20); %CHANGED 20 to 10 for auditory - change back
figure ('Name','Stim locations');
plot(tsresam_stim,tsresam_stim.time(locs),pks,'or')
title('tsresam_stim peaks')
pre=Resamp_r*5; %5 seconds
post=Resamp_r*30; %30 seconds
% cut out stims outside of range
for i= 1:length(locs)
    if locs(i)> (length(tsresam_stim.data)-post)
        locs(i)=[];
        pks(i)=[];
    elseif locs(i)< pre
         locs(i)=[];
        pks(i)=[];
    end
end
[avpup,avencoder,avwhisk,avlfp,avSU,avstim,time] = VNScalcs_short(pre,post,pks,locs,tsresam_pupil,tsresam_encoder,tsresam_whisk,tsresam_lfp,tsresam_SU,tsresam_stim,Resamp_r);
disp('Spike2 traces clipped.')

%% Step 4: Draw ROIs for whole brain and RIGHT hemisphere
%SUPER IMPORTANT: trace ROIs in correct order
disp('Draw 4 right ROIs.')
[ROITraces,AvgROITrace] = AvgROICC(dF);
WholeBrain_dff = ROITraces(:,1);
Motor_dff = ROITraces(:,2);
Somato_dff = ROITraces(:,3);
Visual_dff = ROITraces(:,4);
clear AvgROITrace ROITraces
close all
disp('Right ROIs selected.')
%% Step 5: Draw ROIs for LEFT hemisphere
%SUPER IMPORTANT: trace ROIs in correct order
disp('Draw 3 left ROIs.')
[ROITraces,AvgROITrace] = AvgROICC(dF);
Motor_dff_L = ROITraces(:,1);
Somato_dff_L = ROITraces(:,2);
Visual_dff_L = ROITraces(:,3);
clear AvgROITrace ROITraces
close all
disp('Left ROIs selected.')
%% Step : Make timeseries of widefield data 
times_resamp = 0:Resamp_p:T;
WFTime = WFframec.times;
[CamOn, CamOff, CamTime] = FindStimTimes(wfcam_tr,'WindowDiff',10e10,'CamTrig',1);
[CamWFOnset, CamWFOffsets] = CompareTimes(WFTime, CamTime(CamOn),CamTime(CamOff));
WFTime = WFTime(CamWFOnset:CamWFOnset+TotalFrames-1);
ts_WB_dff = timeseries(WholeBrain_dff,WFTime);
ts_Motor_dff = timeseries(Motor_dff,WFTime);
ts_Somato_dff = timeseries(Somato_dff,WFTime);
ts_Visual_dff = timeseries(Visual_dff,WFTime);
ts_Motor_dff_L = timeseries(Motor_dff_L,WFTime);
ts_Somato_dff_L = timeseries(Somato_dff_L,WFTime);
ts_Visual_dff_L = timeseries(Visual_dff_L,WFTime);
tsre_WB_dff = resample(ts_WB_dff,times_resamp);
tsre_Motor_dff = resample(ts_Motor_dff,times_resamp);
tsre_Somato_dff = resample(ts_Somato_dff,times_resamp);
tsre_Visual_dff = resample(ts_Visual_dff,times_resamp);
tsre_Motor_dff_L = resample(ts_Motor_dff_L,times_resamp);
tsre_Somato_dff_L = resample(ts_Somato_dff_L,times_resamp);
tsre_Visual_dff_L = resample(ts_Visual_dff_L,times_resamp);
[whiskWFOnset, whiskWFOffsets] = CompareTimes(tsresam_whisk.time, WFTime(1),WFTime(TotalFrames));
WFtsre_whisk = timeseries(tsresam_whisk.Data(whiskWFOnset:whiskWFOffsets),tsresam_whisk.time(whiskWFOnset:whiskWFOffsets));
[walkWFOnset, walkWFOffsets] = CompareTimes(tsresam_encoder.time, WFTime(1),WFTime(TotalFrames));
WFtsre_encoder = timeseries(tsresam_encoder.Data(walkWFOnset:walkWFOffsets),tsresam_encoder.time(walkWFOnset:walkWFOffsets));
[PupilWFOnset, PHPupilWFOffsets] = CompareTimes(tsresam_pupil.time, WFTime(1),WFTime(TotalFrames));
WFtsre_Pupil = timeseries(tsresam_pupil.Data(PupilWFOnset:PHPupilWFOffsets),tsresam_pupil.time(PupilWFOnset:PHPupilWFOffsets));
[EphysWFOnset, EphysWFOffsets] = CompareTimes(tsresam_lfp.time,WFTime(1),WFTime(TotalFrames));
WFtsre_lfp = timeseries(tsresam_lfp.Data(EphysWFOnset:EphysWFOffsets),tsresam_lfp.time(EphysWFOnset:EphysWFOffsets));
[SUnitsWFOnset, SUnitsWFOffsets] = CompareTimes(tsresam_SU.time, WFTime(1),WFTime(TotalFrames));
WFtsre_SU = timeseries(tsresam_SU.Data(SUnitsWFOnset:SUnitsWFOffsets),tsresam_SU.time(SUnitsWFOnset:SUnitsWFOffsets));
[stimoutWFOnset, stimoutWFOffsets] = CompareTimes(tsresam_stim.time, WFTime(1),WFTime(TotalFrames));
WFtsre_stim = timeseries(tsresam_stim.Data(stimoutWFOnset:stimoutWFOffsets),tsresam_stim.time(stimoutWFOnset:stimoutWFOffsets));
[WBoutWFOnset, WBoutWFOffsets] = CompareTimes(tsre_WB_dff.time, WFTime(1),WFTime(TotalFrames));
tsre_WB_dff = timeseries(tsre_WB_dff.Data(WBoutWFOnset:WBoutWFOffsets),tsre_WB_dff.time(WBoutWFOnset:WBoutWFOffsets));
[MotoroutWFOnset, MotoroutWFOffsets] = CompareTimes(tsre_Motor_dff.time, WFTime(1),WFTime(TotalFrames));
tsre_Motor_dff = timeseries(tsre_Motor_dff.Data(MotoroutWFOnset:MotoroutWFOffsets),tsre_Motor_dff.time(MotoroutWFOnset:MotoroutWFOffsets));
[SomatooutWFOnset, SomatooutWFOffsets] = CompareTimes(tsre_Somato_dff.time, WFTime(1),WFTime(TotalFrames));
tsre_Somato_dff = timeseries(tsre_Somato_dff.Data(SomatooutWFOnset:SomatooutWFOffsets),tsre_Somato_dff.time(SomatooutWFOnset:SomatooutWFOffsets));
[VisualoutWFOnset, VisualoutWFOffsets] = CompareTimes(tsre_Visual_dff.time, WFTime(1),WFTime(TotalFrames));
tsre_Visual_dff = timeseries(tsre_Visual_dff.Data(VisualoutWFOnset:VisualoutWFOffsets),tsre_Visual_dff.time(VisualoutWFOnset:VisualoutWFOffsets));
[MotorLoutWFOnset, MotorLoutWFOffsets] = CompareTimes(tsre_Motor_dff_L.time, WFTime(1),WFTime(TotalFrames));
tsre_Motor_dff_L = timeseries(tsre_Motor_dff_L.Data(MotorLoutWFOnset:MotorLoutWFOffsets),tsre_Motor_dff_L.time(MotorLoutWFOnset:MotorLoutWFOffsets));
[SomatoLoutWFOnset, SomatoLoutWFOffsets] = CompareTimes(tsre_Somato_dff_L.time, WFTime(1),WFTime(TotalFrames));
tsre_Somato_dff_L = timeseries(tsre_Somato_dff_L.Data(SomatoLoutWFOnset:SomatoLoutWFOffsets),tsre_Somato_dff_L.time(SomatoLoutWFOnset:SomatoLoutWFOffsets));
[VisualLoutWFOnset, VisualLoutWFOffsets] = CompareTimes(tsre_Visual_dff_L.time, WFTime(1),WFTime(TotalFrames));
tsre_Visual_dff_L = timeseries(tsre_Visual_dff_L.Data(VisualLoutWFOnset:VisualLoutWFOffsets),tsre_Visual_dff_L.time(VisualLoutWFOnset:VisualLoutWFOffsets));
close all
disp('WF timeseries created.')
%% Step 8: Clip WF traces around time of VNS
[wfpks,wflocs] = findpeaks(WFtsre_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',Resamp_r*20); %Resamp_r*20 means that it wont look for another stim until at least 20 seconds after the start
maxWFwhisk = max(WFtsre_whisk);
normWF_whisk =(WFtsre_whisk/maxWFwhisk)*100;
maxWFwalk = max(WFtsre_encoder);
normWF_walk =(WFtsre_encoder/maxWFwalk)*100;
maxWFstim = max(WFtsre_stim);
normWF_stim =(WFtsre_stim/maxWFstim)*100;
x = [1:length(WFtsre_stim.Data)];
%%
for i= 1:length(wfpks)
    if wflocs(i)> (length(WFtsre_stim.data)-post)
        wflocs(i)=[];
        wfpks(i)=[];
        disp('Late stim removed.')
    elseif wflocs(i)< pre
         wflocs(i)=[];
        wfpks(i)=[];
        disp('Early stim removed.')
    else 
        disp('Stim kept.')
    end
    
end

%% START HERE IF "Index exceeds array bounds" ERROR OCCURS
[wfavpup,wfavencoder,wfavwhisk,wfavlfp,wfavSU,wfavstim,wftime] = VNScalcs_short(pre,post,wfpks,wflocs,WFtsre_Pupil,WFtsre_encoder,WFtsre_whisk,WFtsre_lfp,WFtsre_SU,WFtsre_stim,Resamp_r);
%%
avWF_WB=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_WB(:,i)=tsre_WB_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_Motor=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_Motor(:,i)=tsre_Motor_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_Somato=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_Somato(:,i)=tsre_Somato_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_Visual=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_Visual(:,i)=tsre_Visual_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_MotorL=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_MotorL(:,i)=tsre_Motor_dff_L.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_SomatoL=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_SomatoL(:,i)=tsre_Somato_dff_L.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
avWF_VisualL=zeros(pre+post+1,length(wfpks));
for i = 1:length(wfpks)
    avWF_VisualL(:,i)=tsre_Visual_dff_L.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
end
disp('WF traces clipped.')
%% Step 9: Save files
    selpath = uigetdir(path,'Select Mouse folder to save files.');
    cd(strcat(selpath))
    mkdir('Analysis');  cd(strcat(selpath,'\','Analysis'));  
    sav_loc = fullfile(selpath,'\','Analysis','\');
     All_WF_variables_struct.filename=savename;
     All_WF_variables_struct.wfavpup=wfavpup;
     All_WF_variables_struct.wfavencoder=wfavencoder;
     All_WF_variables_struct.wfavwhisk=wfavwhisk;
     All_WF_variables_struct.wfavSU=wfavSU;
     All_WF_variables_struct.wfavlfp=wfavlfp;
     All_WF_variables_struct.avWF_WB=avWF_WB;
     All_WF_variables_struct.avWF_Motor=avWF_Motor;
     All_WF_variables_struct.avWF_Somato=avWF_Somato;
     All_WF_variables_struct.avWF_Visual=avWF_Visual;
     All_WF_variables_struct.wftime=wftime;
     All_WF_variables_struct.wfavstim=wfavstim;
     All_WF_variables_struct.avWF_MotorL=avWF_MotorL;
     All_WF_variables_struct.avWF_SomatoL=avWF_SomatoL;
     All_WF_variables_struct.avWF_VisualL=avWF_VisualL;
    save(strcat(sav_loc,savename,'_All_WF_variables_struct.mat'),'All_WF_variables_struct');
    disp('Widefield Data Saved')