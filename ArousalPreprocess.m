  %% Analysing pupil, walk, and whisk after Stim
%Version Edited to Run multiple widefields at a time Jan 7th 2019
%Version edited to do hemodynamic correction and add in Lindsay wf trigger cut Feb 18th 2019

%% Load in Spike2 file and Rename Variables
clear
close all
cd('\\mammatus2\Widefield\Laura\Data')
[FileName, folder] = uigetfile('*.mat','Select Spike2 .mat file.');  
load(fullfile(folder,FileName))
cd(folder);

%% change stim to square wave
% plot(STIM.values)
% clear STIM
% STIM=OldstmIN;
for y = 1:length(STIM.values)
    if STIM.values(y) > 0.1
        STIM.values(y) = 5;
    else
        STIM.values(y) = 0;
    end
end

%% Make timeseries and correct walk velocity
walk.values=(walk.values-3)*10;
ts_encoder = timeseries     (walk.values,(linspace(0,(walk.length*walk.interval),walk.length))');
ts_stim = timeseries(STIM.values,(linspace(0,(STIM.length*STIM.interval),STIM.length))');
ts_whisk = timeseries(whisk.values,(linspace(0,(whisk.length*whisk.interval),whisk.length))');
ts_lfp = timeseries(lfp_unit.values,(linspace(0,(lfp_unit.length*lfp_unit.interval),lfp_unit.length))');
ts_SU = timeseries(SU.values,(linspace(0,(SU.length*SU.interval),SU.length))');
% ts_lfp =ts_whisk ;
% ts_SU=ts_whisk ;

%% Import Pupil Data - Smoothed or Real Time
prompt = {'Would you like to read in posthoc pupil data? (Y/N)'};
t = 'Input';
dims = [1 25];
definput = {'Y'};
PHPanswer = inputdlg(prompt,t,dims,definput);
if PHPanswer{1,1} == 'Y'
    [FileNamephp, folderphp] = uigetfile('*.mat');  % Opens UI to find file (change to .xlsx for older versions)
    load(fullfile(folderphp,FileNamephp))
    cd(strcat(folderphp))
%     pup_whisk=readtable(strcat(folderphp,FileNamephp),'Sheet','Data'); old way of reading in pupil 
%     PH_pupil=table2array(pup_whisk(:,1));
%     PH_whisk=table2array(pup_whisk(:,2));
    PH_pupil=movmean(this_pupil_filt,5)';
    if length(camera.times)>length(PH_pupil)
        PH_pupil(length(PH_pupil)+length(camera.times)-length(PH_pupil),:)=NaN;
%         PH_whisk(length(PH_whisk)+length(camera.times)-length(PH_whisk),:)=NaN;
    end
    ts_pupil = timeseries(PH_pupil, camera.times); %match up to pupilcam frame clock
%     ts_whisk= timeseries(PH_whisk, camera.times);
elseif PHPanswer{1,1} ~= 'Y'
    ts_pupil = timeseries(Pupil.values,(linspace(0,(Pupil.length*Pupil.interval),Pupil.length))');
    disp('No posthoc pupil fitting. Real-time Pupil used')
end

%remove outliers/blinks from tract
tmp = filloutliers(ts_pupil.data,'previous','movmedian',5);
ts_pupil=timeseries(tmp,ts_pupil.time);

%% plot WFtrigger and stim traces
%checks to make sure that the correct WF trigger and stim trace was
%selected. 
figure;plot(wfcam_tr.values);
figure;plot(ts_stim);

% uncomment if you want to stop here and save 
% save(FileName,'-v7.3');
% disp('File Saved')

%% Resample Files
T = max(ts_encoder.time);
Resamp_r = 8000; %in Hz
Resamp_p = 1/Resamp_r; %in seconds

times_resamp = 0:Resamp_p:T;

tsresam_pupil = resample(ts_pupil,times_resamp);
tsresam_encoder = resample(ts_encoder,times_resamp);
tsresam_stim = resample(ts_stim,times_resamp);
tsresam_whisk = resample(ts_whisk,times_resamp);
tsresam_lfp = resample(ts_lfp,times_resamp);
tsresam_SU = resample(ts_SU,times_resamp);

temp_stim=tsresam_stim.Data;
temp_time=tsresam_stim.Time;

for y = 1:length(temp_stim)
    if temp_stim(y) > 0.1
        temp_stim(y) = 5;
    else
        temp_stim(y) = 0;
    end
end

tsresam_stim =timeseries(temp_stim,temp_time)

%% Normalize pupil to max and exclude blinks and pupil fitting crashes

figure ('Name','Pupil Raw Trace')
plot(ts_pupil.Data)
title('First choose maximum, then choose minimum pupil values.')
[~,y1] =(ginput(1));
[~,y2] = (ginput(1));

tsresam_pupil.Data(tsresam_pupil.Data < y2) = NaN;
tsresam_pupil.Data(tsresam_pupil.Data > y1) = NaN;

% nanx = isnan(tsresam_pupil.Data);
% t    = 1:numel(tsresam_pupil.Data);
% tsresam_pupil.Data(nanx) = interp1(t(~nanx), tsresam_pupil.Data(~nanx), t(nanx));

%it will now prompt you to either manually or automatically determine
%maximum pupil values. You may want to choose to manually input the max
%pupil value if the mouse did not run during this chunk of file and you
%know what the maximum/running pupil value is from the spike2 file.  

prompt = {'Would you like to automatically determine (A) or manually input (M) the max pupil value?'};
t = 'Input';
dims = [1 60];
definput = {'A'};
auto_manual_pupil = inputdlg(prompt,t,dims,definput);

if auto_manual_pupil{1,1} == 'A'

    maxpup = max(tsresam_pupil.Data);
    tsresam_pupil.Data =(tsresam_pupil.Data/maxpup)*100;
    tsresam_pupil.Data=movmean(tsresam_pupil.Data,500);
    figure('Name','Corrected Pupil Trace')
    plot(tsresam_pupil.Data)
    histogram(tsresam_pupil.Data)
    disp('Automatic Max Pupil Determined')
    
elseif auto_manual_pupil{1,1} == 'M'
    prompt = {'Input Max Pupil Value'};
    t = 'Input';
    dims = [1 25];
    definput = {'0.6'};
    maxpup = inputdlg(prompt,t,dims,definput);
    maxpup=str2num(cell2mat(maxpup));
    tsresam_pupil.Data =(tsresam_pupil.Data/maxpup)*100;
    tsresam_pupil.Data=movmean(tsresam_pupil.Data,500);
    figure('Name','Corrected Pupil Trace')
    plot(tsresam_pupil.Data)
    histogram(tsresam_pupil.Data)
    disp('Max Pupil Manually Determined')
end

nanx = isnan(tsresam_pupil.Data);
t    = 1:numel(tsresam_pupil.Data);
tsresam_pupil.Data(nanx) = interp1(t(~nanx), tsresam_pupil.Data(~nanx), t(nanx));


% %% Remove artifact from SU trace
% % comment this out if not doing ephys. 
% [pks,locs] = findpeaks(tsresam_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',1);
% figure ('Name','Stim locations');
% plot(tsresam_stim,tsresam_stim.time(locs),pks,'or')
% title('tsresam_stim peaks')
% 
% %filter data
% data=tsresam_SU.Data;
% 
% pole=2;
% band=[1500 3900];
% x=4; % a number to be multiplied to sd
% frq=8000; %make sure this matches with the resample frequency
% bp=[band(1)/(frq/2) band(2)/(frq/2)];
% 
% SU_filt=zeros(size(data,1),size(data,2));
% [m,p]=butter(pole/2,bp,'bandpass');
% for i=1:size(data,2)
%     SU_filt(:,i)=filter(m,p,data(:,i));
% end
% figure;plot(SU_filt)
% 
% tsresam_SU.Data=SU_filt;
% 
% for i=1:length(locs)
%   tsresam_SU.Data(locs(i,1)-5:locs(i,1)+60)=0;
% end
% 
% figure;plot(tsresam_SU.Data)
% disp('SU artifact removed')
% %% Filter LFP data
% %filter data
% data=tsresam_lfp.Data;
% 
% pole=2;
% band=[0.1 300];
% x=4; % a number to be multiplied to sd
% frq=8000; %make sure this matches with the resample frequency
% bp=[band(1)/(frq/2) band(2)/(frq/2)];
% 
% LFP_filt=zeros(size(data,1),size(data,2));
% [m,p]=butter(pole/2,bp,'bandpass');
% for i=1:size(data,2)
%     LFP_filt(:,i)=filter(m,p,data(:,i));
% end
% figure;plot(LFP_filt)
% 
% tsresam_lfp.Data=LFP_filt;
% 
% for i=1:length(locs)
%   tsresam_lfp.Data(locs(i,1)-5:locs(i,1)+60)=0;
% end
% 
% figure;plot(tsresam_lfp.Data)
% disp('LFP artifact removed')

%% Find STIM onset
[pks,locs] = findpeaks(tsresam_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',Resamp_r*2);
figure ('Name','Stim locations');
plot(tsresam_stim,tsresam_stim.time(locs),pks,'or')
title('tsresam_stim peaks')

%% Determine Time to cut files
pre=Resamp_r*5; %default is 5 seconds
post=Resamp_r*30; %default is 30 seconds

%cut out stims if they aren't in the range
for i= 1:length(locs)
    if locs(i)> (length(tsresam_stim.data)-post)
        locs(i)=[];
        pks(i)=[];
        disp('Late Stim Removed')
    elseif locs(i)< pre
        locs(i)=[];
        pks(i)=[];
        disp('Late Stim Removed')
    end
end

%% ---- Run VNScalcs_short function to get just the chunked files - not separated into states
[avpup,avencoder,avwhisk,avlfp,avSU,avstim,time] = VNScalcs_short(pre,post,pks,locs,tsresam_pupil,tsresam_encoder,tsresam_whisk,tsresam_lfp,tsresam_SU,tsresam_stim,Resamp_r);

%% Save AROUSAL files if happy with them
prompt = {'Would you like to save your files? (Y/N)'};
t = 'Input';
dims = [1 25];
definput = {'Y'};
Saveanswer = inputdlg(prompt,t,dims,definput);

if Saveanswer{1,1} == 'Y'   
%     prompt ={'Enter filename.'};
%     t = 'Input';
%     dims = [1 200];
%     definput = {'0000_YYMMDD_1sec_800uA_190614_ms'};
%     answer = inputdlg(prompt,t,dims,definput);
%     filename = answer{1,1};
    FileName=FileName(1:end-4)
    selpath = uigetdir(path,'Select Mouse folder to save files.');
    cd(strcat(selpath))
%     mkdir('Analysis_NewPHP');  cd(strcat(selpath,'\','Analysis_NewPHP'));  
%     sav_loc = fullfile(selpath,'\','Analysis_NewPHP','\');
    sav_loc = fullfile(selpath);
    
 %Make a structure to save all variables into one structure to save a single file for   
    All_variables_struct.filename=FileName;
    All_variables_struct.avpup=avpup;
    All_variables_struct.avencoder=avencoder;
    All_variables_struct.avwhisk=avwhisk;
    All_variables_struct.avSU=avSU;
    All_variables_struct.avlfp=avlfp;
    All_variables_struct.time=time;
    All_variables_struct.avstim=avstim;

    save(strcat(sav_loc,'\',FileName,'_arousal_All_variables_struct.mat'),'All_variables_struct');
    disp('Data Saved')

elseif Saveanswer{1,1} ~= 'Yes' 
    disp('No Data were saved')
end


%% Save critical variables to run widefield analysis later
prompt = {'Would you like to save critical data to run widefield analysis later? (Y/N)'};
t = 'Input';
dims = [1 25];
definput = {'Y'};
Saveanswer = inputdlg(prompt,t,dims,definput);

if Saveanswer{1,1} == 'Y'   
save(strcat(sav_loc,'\',FileName,'_unprocesseddataforWFanalysis'),'All_variables_struct',...
    'FileName','wfcam_tr','WFframec','tsresam_encoder','tsresam_lfp','tsresam_pupil', ...
    'tsresam_stim','tsresam_SU','tsresam_whisk','pre','post','Resamp_r','times_resamp');

    disp('Data Saved - no hemodynamics information')

elseif Saveanswer{1,1} ~= 'Yes' 
    disp('No Data were saved')
end


% %% Load in WF data
% prompt = {'Did you collect WF data? (Y/N)'};
% t = 'Input';
% dims = [1 25];
% definput = {'Y'};
% WFanswer = inputdlg(prompt,t,dims,definput);
% 
% if WFanswer{1,1} == 'Y'
% prompt ={'Enter number of WF frames collected.','Enter X size.','Enter Y size.','Enter sampling frequency.','Enter number of skipped frames.','Enter fraction to downsample pixels.'};
% t = 'Input';
% dims = [1 50];
% definput = {'6000','640','640','20','0','0.5'};
% answer = inputdlg(prompt,t,dims,definput);
% TotalFrames = str2num(answer{1,1});
% XSize = str2num(answer{2,1});
% YSize = str2num(answer{3,1});
% Fs = str2num(answer{4,1});
% NSkipFrames = str2num(answer{5,1});
% DSFrac = str2num(answer{6,1});
% 
% [FileName, folder] = uigetfile('*.tsm','Select WF .tsm file.');  % Opens UI to find .tsm file
% videoWF = readTSMFile(folder,FileName, XSize,YSize,TotalFrames,NSkipFrames,DSFrac);
% disp('Recording loaded.')
% end
% 
%  %% Clip WFcam trace if there are multiple trials
% % %make this so you don't need to read in the spike2 file again
% 
% %first pass use this
% wfcam_trorig=wfcam_tr;
% 
% % %second pass use this 
% % wfcam_tr=wfcam_trorig;
% 
% % 
% prompt = {'How many WF trials did you collect?'};
% t = 'Input';
% dims = [1 25];
% definput = {'3'};
% WFnum = inputdlg(prompt,t,dims,definput);
% WFnum = str2num(WFnum{1,1});
% if WFnum == 1
%     wfcam_tr.values = wfcam_tr.values;
% elseif WFnum == 2
%     wfcam_trcopy=wfcam_tr.values;
%     prompt = {'Would you like to KEEP the first or second trial?'};
%     t = 'Input';
%     dims = [1 25];
%     definput = {'1'};
%     WFkeep = inputdlg(prompt,t,dims,definput);
%     WFkeep = str2num(WFkeep{1,1});
%         if WFkeep == 1
%             figure('Name','Select point that first trial ends');
%             set(gcf, 'Position',  [300, 300, 1500, 1000])
%             plot(wfcam_tr.values);
%             [x1,~] =(ginput(1)); 
%             clip1=round(x1);  
%             wfcam_tr.values(clip1:end) = 0;
%         elseif WFkeep == 2
%             figure('Name','Select point that second trial begins');
%             set(gcf, 'Position',  [300, 300, 1500, 1000])
%             plot(wfcam_tr.values);
%             [x1,~] =(ginput(1)); 
%             clip1=round(x1);  
%             wfcam_tr.values(1:clip1) = 0;   
%         end
%         
% elseif WFnum > 2
%     wfcam_trcopy=wfcam_tr.values;
%     figure('Name','Select beginning of trace to keep');
%     set(gcf, 'Position',  [300, 300, 1500, 1000])
%     plot(wfcam_tr.values);
%     [x1,~] =(ginput(1)); 
%     clip1=round(x1); 
%     figure('Name','Select end of trace to keep');
%     set(gcf, 'Position',  [300, 300, 1500, 1000])
%     plot(wfcam_tr.values);
%     [x2,~] =(ginput(1)); 
%     clip2=round(x2); 
%     wfcam_tr.values(1:clip1) = 0;
%     wfcam_tr.values(clip2:end) = 0;
% end
% figure ('Name','wfcam_tr clipped');
% plot(wfcam_tr.values)
% 
% %% Hemodynamic Correction
% prompt = {'Would you like to do hemodynamic correction (Y/N)'};
% t = 'Input';
% dims = [1 25];
% definput = {'Y'};
% hemoanswer = inputdlg(prompt,t,dims,definput);
% 
% WFTime = WFframec.times;
% [CamOn, CamOff, CamTime] = FindStimTimes(wfcam_tr,'WindowDiff',10e10,'CamTrig',1);
% [CamWFOnset, CamWFOffsets] = CompareTimes(WFTime, CamTime(CamOn),CamTime(CamOff));
% WFTime = WFTime(CamWFOnset:CamWFOnset+TotalFrames-1);
% 
% %turn traces into square waves
% for y = 1:length(wfcam_B.values)
%     if wfcam_B.values(y) > 1
%         wfcam_B.values(y) = 5;
%     else
%         wfcam_B.values(y) = 0;
%     end
% end
% 
% for y = 1:length(wfcam_G.values)
%     if wfcam_G.values(y) > 1
%         wfcam_G.values(y) = 5;
%     else
%         wfcam_G.values(y) = 0;
%     end
% end
% 
% wfcam_G.values(1:30)=0;
% wfcam_B.values(1:30)=0;
% 
% % find first green trig TIME on after CamOn time t
% wftimebase= linspace(0,(wfcam_tr.length*wfcam_tr.interval),wfcam_tr.length);
% wfstart=wftimebase(CamOn);
% 
% [CamOn_G, CamOff_G, CamTime_G] = FindStimTimes(wfcam_G,'WindowDiff',100);
% [CamOn_B, CamOff_B, CamTime_B] = FindStimTimes(wfcam_B,'WindowDiff',100);
% 
% for i=1:length(CamTime_B)
%     if CamTime_B(i) <wfstart
%     CamTime_B(i)=NaN;
%     end
% end
% 
% cam_b_times=CamTime_B(CamOn_B);
% 
% for i=1:length(CamTime_G)
%     if CamTime_G(i) <wfstart
%     CamTime_G(i)=NaN;
%     end
% end
% 
% cam_g_times=CamTime_G(CamOn_G);
% 
% cam_b_times(isnan(cam_b_times))=[];
% cam_g_times(isnan(cam_g_times))=[];
% 
% Blue=cam_b_times(1)
% Green=cam_g_times(1)
% 
% split=linspace(1,TotalFrames,TotalFrames);
% even=split(2:2:end);
% odd=split(1:2:end);
% 
% if Green-wfstart<(1/Fs)
%     WFcorrTime = cam_g_times(1:TotalFrames/2);
%     videoWF_B(:,:,:) = videoWF(:,:,odd);  
%     videoWF_G(:,:,:) = videoWF(:,:,even);
% elseif  Blue-wfstart<(1/Fs)
%     WFcorrTime = cam_b_times(1:TotalFrames/2);
%      videoWF_G(:,:,:) = videoWF(:,:,odd);  
%      videoWF_B(:,:,:) = videoWF(:,:,even);
% end
% 
% for i = 1:size(videoWF_B,3);
% videoWF_corr(:,:,i)= videoWF_B(:,:,i) ./ videoWF_G(:,:,i);
% end
% 
% dF_corr=Calc_dFF(videoWF_corr,Fs);
% disp("dF's Calculated.")
% 
% % 
% [dF_G,UdF_G] = Calc_dFF(videoWF_G,Fs);
% [dF_B,UdF_B] = Calc_dFF(videoWF_B,Fs);
% disp("dF's Calculated.")
% % 
% % dF_B=dF_B;
% % dF_G=dF_G;
% % 
% % for i = 1:size(dF_B,3);
% %    dF_corr(:,:,i) = dF_B(:,:,i) - dF_G(:,:,i);
% % end
% 
% meanhmodd=nanmean(dF_corr(:,:,:),3);
% figure; 
% wfheatmapodd=heatmap(meanhmodd,'GridVisible','off','Colormap',jet); 
% 
% % plot(WholeBrain_dff_corr), hold on; plot(WholeBrain_dff_corrb), hold on; plot(WholeBrain_dff_corrg), hold off; 
% 
% 
% %% WF HEMODYNAMIC CORRECTED - Calculate dF/F for each pixel:
% % [dF_corr,UdF] = Calc_dFF(videoWF_B,Fs); % Global 10 percentile baseline
% % disp('dF Calculated.')
% %% WF HEMODYNAMIC CORRECTED -Calculate dF/F for whole brain
% [ROITraces,AvgROITrace] = AvgROICC(dF_corr);
% WholeBrain_dff_corr = ROITraces(:,1);
% clear AvgROITrace ROITraces
% %% WF HEMODYNAMIC CORRECTED - Calculate dF/F right motor
% [ROITraces,AvgROITrace] = AvgROICC(dF_corr);
% Motor_dff_corr = ROITraces(:,1);
% clear AvgROITrace ROITraces
% 
% %% WF HEMODYNAMIC CORRECTED - Calculate dF/F for right somatosensory cortex
% [ROITraces,AvgROITrace] = AvgROICC(dF_corr);
% Somato_dff_corr = ROITraces(:,1);
% clear AvgROITrace ROITraces
% 
% %% WF HEMODYNAMIC CORRECTED - Calculate dF/F for right visual cortex
% [ROITraces,AvgROITrace] = AvgROICC(dF_corr);
% Visual_dff_corr = ROITraces(:,1);
% clear AvgROITrace ROITraces
% 
% %% WF HEMODYNAMIC CORRECTED
% WFTime = WFframec.times;
% [CamOn, CamOff, CamTime] = FindStimTimes(wfcam_tr,'WindowDiff',10e10,'CamTrig',1);
% [CamWFOnset, CamWFOffsets] = CompareTimes(WFTime, CamTime(CamOn),CamTime(CamOff));
% WFTime = WFTime(CamWFOnset:CamWFOnset+TotalFrames-1);
% 
% %     ts_WF=timeseries(ROITraces,WFTime);
% %     tsre_WF = resample(ts_WF,times_resamp);
% 
% ts_WB_dff = timeseries(WholeBrain_dff_corr,WFcorrTime);
% ts_Motor_dff = timeseries(Motor_dff_corr,WFcorrTime);
% ts_Somato_dff = timeseries(Somato_dff_corr,WFcorrTime);
% ts_Visual_dff = timeseries(Visual_dff_corr,WFcorrTime);
% 
% tsre_WB_dff = resample(ts_WB_dff,times_resamp);
% tsre_Motor_dff = resample(ts_Motor_dff,times_resamp);
% tsre_Somato_dff = resample(ts_Somato_dff,times_resamp);
% tsre_Visual_dff = resample(ts_Visual_dff,times_resamp);
% 
% 
% % pull out other already resampled variables only when WF camera is on - Uses Elliots CompareTimes.m
% [whiskWFOnset, whiskWFOffsets] = CompareTimes(tsresam_whisk.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_whisk = timeseries(tsresam_whisk.Data(whiskWFOnset:whiskWFOffsets),tsresam_whisk.time(whiskWFOnset:whiskWFOffsets));
% 
% [walkWFOnset, walkWFOffsets] = CompareTimes(tsresam_encoder.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_encoder = timeseries(tsresam_encoder.Data(walkWFOnset:walkWFOffsets),tsresam_encoder.time(walkWFOnset:walkWFOffsets));
% 
% [PupilWFOnset, PHPupilWFOffsets] = CompareTimes(tsresam_pupil.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_Pupil = timeseries(tsresam_pupil.Data(PupilWFOnset:PHPupilWFOffsets),tsresam_pupil.time(PupilWFOnset:PHPupilWFOffsets));
% 
% [EphysWFOnset, EphysWFOffsets] = CompareTimes(tsresam_lfp.time,WFTime(1),WFTime(TotalFrames));
% WFtsre_lfp = timeseries(tsresam_lfp.Data(EphysWFOnset:EphysWFOffsets),tsresam_lfp.time(EphysWFOnset:EphysWFOffsets));
% 
% [SUnitsWFOnset, SUnitsWFOffsets] = CompareTimes(tsresam_SU.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_SU = timeseries(tsresam_SU.Data(SUnitsWFOnset:SUnitsWFOffsets),tsresam_SU.time(SUnitsWFOnset:SUnitsWFOffsets));
% 
% [stimoutWFOnset, stimoutWFOffsets] = CompareTimes(tsresam_stim.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_stim = timeseries(tsresam_stim.Data(stimoutWFOnset:stimoutWFOffsets),tsresam_stim.time(stimoutWFOnset:stimoutWFOffsets));
% 
% [WBoutWFOnset, WBoutWFOffsets] = CompareTimes(tsre_WB_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_WB_dff = timeseries(tsre_WB_dff.Data(WBoutWFOnset:WBoutWFOffsets),tsre_WB_dff.time(WBoutWFOnset:WBoutWFOffsets));
% 
% [MotoroutWFOnset, MotoroutWFOffsets] = CompareTimes(tsre_Motor_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Motor_dff = timeseries(tsre_Motor_dff.Data(MotoroutWFOnset:MotoroutWFOffsets),tsre_Motor_dff.time(MotoroutWFOnset:MotoroutWFOffsets));
% 
% [SomatooutWFOnset, SomatooutWFOffsets] = CompareTimes(tsre_Somato_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Somato_dff = timeseries(tsre_Somato_dff.Data(SomatooutWFOnset:SomatooutWFOffsets),tsre_Somato_dff.time(SomatooutWFOnset:SomatooutWFOffsets));
% 
% [VisualoutWFOnset, VisualoutWFOffsets] = CompareTimes(tsre_Visual_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Visual_dff = timeseries(tsre_Visual_dff.Data(VisualoutWFOnset:VisualoutWFOffsets),tsre_Visual_dff.time(VisualoutWFOnset:VisualoutWFOffsets));
% 
% 
% %Find stims in WF chunk
% [wfpks,wflocs] = findpeaks(WFtsre_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',Resamp_r*2); %Resamp_r*20 means that it wont look for another stim until at least 20 seconds after the start
% figure ('Name','Stim locations');
% plot(WFtsre_stim,WFtsre_stim.time(wflocs),wfpks,'or')
% title('WFtsre_stim peaks')
% 
% %cut out stims if they aren't in the range
% for i= 1:length(wflocs)
%     if wflocs(i)> (length(WFtsre_stim.data)-post)
%         wflocs(i)=[];
%         wfpks(i)=[];
%         disp('Late Stim Removed')
%     elseif wflocs(i)< pre
%         wflocs(i)=[];
%         wfpks(i)=[];
%         disp('Late Stim Removed')
%     end
% end
% 
% 
% %normalize to max to plot together
% maxWFwhisk = max(WFtsre_whisk);
% normWF_whisk =(WFtsre_whisk/maxWFwhisk)*100;
% maxWFwalk = max(WFtsre_encoder);
% normWF_walk =(WFtsre_encoder/maxWFwalk)*100;
% maxWFstim = max(WFtsre_stim);
% normWF_stim =(WFtsre_stim/maxWFstim)*100;
% 
% x = [1:length(WFtsre_stim.Data)];
% figure ('Name','Arousal Measures During WF Imaging.')
% plot(x,normWF_whisk.Data,'r',x,normWF_walk.Data,'b',x,WFtsre_Pupil.Data,'k',x,normWF_stim.Data,'g')
% ylim([-20 100])
% 
% 
% %Function to do just the short version of the VNS calculations
% [wfavpup,wfavencoder,wfavwhisk,wfavlfp,wfavSU,wfavstim,wftime] = VNScalcs_short(pre,post,wfpks,wflocs,WFtsre_Pupil,WFtsre_encoder,WFtsre_whisk,WFtsre_lfp,WFtsre_SU,WFtsre_stim,Resamp_r);
% 
% avWF_WB=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_WB(:,i)=tsre_WB_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% avWF_Motor=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Motor(:,i)=tsre_Motor_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% avWF_Somato=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Somato(:,i)=tsre_Somato_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% 
% avWF_Visual=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Visual(:,i)=tsre_Visual_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% 
% 
% 
% %% NO Hemodynamic correction
% %
% % Calculate dF/F for each pixel:
% [dF,UdF] = Calc_dFF(videoWF,Fs); % Global 10 percentile baseline
% disp('dF Calculated.')
% %% Calculate dF/F for whole brain
% [ROITraces,AvgROITrace] = AvgROICC(dF);
% WholeBrain_dff = ROITraces(:,1);
% clear AvgROITrace ROITraces
% %% Calculate dF/F right motor
% [ROITraces,AvgROITrace] = AvgROICC(dF);
% Motor_dff = ROITraces(:,1);
% %   Somato_dff = ROITraces(:,2);
% %   Visual_dff = ROITraces(:,3);0.9
% %   WholeBrain_dff = ROITraces(:,4);
% clear AvgROITrace ROITraces
% 
% %% Calculate dF/F for right somatosensory cortex
% [ROITraces,AvgROITrace] = AvgROICC(dF);
% Somato_dff = ROITraces(:,1);
% clear AvgROITrace ROITraces
% 
% %% Calculate dF/F for right visual cortex
% [ROITraces,AvgROITrace] = AvgROICC(dF);
% Visual_dff = ROITraces(:,1);
% clear AvgROITrace ROITraces
% 
% %%
% WFTime = WFframec.times;
% [CamOn, CamOff, CamTime] = FindStimTimes(wfcam_tr,'WindowDiff',10e10,'CamTrig',1);
% [CamWFOnset, CamWFOffsets] = CompareTimes(WFTime, CamTime(CamOn),CamTime(CamOff));
% WFTime = WFTime(CamWFOnset:CamWFOnset+TotalFrames-1);
% 
% %     ts_WF=timeseries(ROITraces,WFTime);
% %     tsre_WF = resample(ts_WF,times_resamp);
% 
% ts_WB_dff = timeseries(WholeBrain_dff,WFTime);
% ts_Motor_dff = timeseries(Motor_dff,WFTime);
% ts_Somato_dff = timeseries(Somato_dff,WFTime);
% ts_Visual_dff = timeseries(Visual_dff,WFTime);
% 
% tsre_WB_dff = resample(ts_WB_dff,times_resamp);
% tsre_Motor_dff = resample(ts_Motor_dff,times_resamp);
% tsre_Somato_dff = resample(ts_Somato_dff,times_resamp);
% tsre_Visual_dff = resample(ts_Visual_dff,times_resamp);
% 
% 
% 
% % pull out other already resampled variables only when WF camera is on - Uses Elliots CompareTimes.m
% [whiskWFOnset, whiskWFOffsets] = CompareTimes(tsresam_whisk.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_whisk = timeseries(tsresam_whisk.Data(whiskWFOnset:whiskWFOffsets),tsresam_whisk.time(whiskWFOnset:whiskWFOffsets));
% 
% [walkWFOnset, walkWFOffsets] = CompareTimes(tsresam_encoder.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_encoder = timeseries(tsresam_encoder.Data(walkWFOnset:walkWFOffsets),tsresam_encoder.time(walkWFOnset:walkWFOffsets));
% 
% [PupilWFOnset, PHPupilWFOffsets] = CompareTimes(tsresam_pupil.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_Pupil = timeseries(tsresam_pupil.Data(PupilWFOnset:PHPupilWFOffsets),tsresam_pupil.time(PupilWFOnset:PHPupilWFOffsets));
% 
% [EphysWFOnset, EphysWFOffsets] = CompareTimes(tsresam_lfp.time,WFTime(1),WFTime(TotalFrames));
% WFtsre_lfp = timeseries(tsresam_lfp.Data(EphysWFOnset:EphysWFOffsets),tsresam_lfp.time(EphysWFOnset:EphysWFOffsets));
% 
% [SUnitsWFOnset, SUnitsWFOffsets] = CompareTimes(tsresam_SU.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_SU = timeseries(tsresam_SU.Data(SUnitsWFOnset:SUnitsWFOffsets),tsresam_SU.time(SUnitsWFOnset:SUnitsWFOffsets));
% 
% [stimoutWFOnset, stimoutWFOffsets] = CompareTimes(tsresam_stim.time, WFTime(1),WFTime(TotalFrames));
% WFtsre_stim = timeseries(tsresam_stim.Data(stimoutWFOnset:stimoutWFOffsets),tsresam_stim.time(stimoutWFOnset:stimoutWFOffsets));
% 
% [WBoutWFOnset, WBoutWFOffsets] = CompareTimes(tsre_WB_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_WB_dff = timeseries(tsre_WB_dff.Data(WBoutWFOnset:WBoutWFOffsets),tsre_WB_dff.time(WBoutWFOnset:WBoutWFOffsets));
% 
% [MotoroutWFOnset, MotoroutWFOffsets] = CompareTimes(tsre_Motor_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Motor_dff = timeseries(tsre_Motor_dff.Data(MotoroutWFOnset:MotoroutWFOffsets),tsre_Motor_dff.time(MotoroutWFOnset:MotoroutWFOffsets));
% 
% [SomatooutWFOnset, SomatooutWFOffsets] = CompareTimes(tsre_Somato_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Somato_dff = timeseries(tsre_Somato_dff.Data(SomatooutWFOnset:SomatooutWFOffsets),tsre_Somato_dff.time(SomatooutWFOnset:SomatooutWFOffsets));
% 
% [VisualoutWFOnset, VisualoutWFOffsets] = CompareTimes(tsre_Visual_dff.time, WFTime(1),WFTime(TotalFrames));
% tsre_Visual_dff = timeseries(tsre_Visual_dff.Data(VisualoutWFOnset:VisualoutWFOffsets),tsre_Visual_dff.time(VisualoutWFOnset:VisualoutWFOffsets));
% 
% 
% %Find stims in WF chunk
% [wfpks,wflocs] = findpeaks(WFtsre_stim.data,'MinPeakHeight',0.3,'MinPeakDistance',Resamp_r*8); %Resamp_r*20 means that it wont look for another stim until at least 20 seconds after the start
% figure ('Name','Stim locations');
% plot(WFtsre_stim,WFtsre_stim.time(wflocs),wfpks,'or')
% title('WFtsre_stim peaks')
% 
% %cut out stims if they aren't in the range
% for i= 1:length(wflocs)
%     if wflocs(i)> (length(WFtsre_stim.data)-post)
%         wflocs(i)=[];
%         wfpks(i)=[];
%         disp('Late Stim Removed')
%     elseif wflocs(i)< pre
%         wflocs(i)=[];
%         wfpks(i)=[];
%         disp('Late Stim Removed')
%     end
% end
% 
% 
% 
% %normalize to max to plot together
% maxWFwhisk = max(WFtsre_whisk);
% normWF_whisk =(WFtsre_whisk/maxWFwhisk)*100;
% maxWFwalk = max(WFtsre_encoder);
% normWF_walk =(WFtsre_encoder/maxWFwalk)*100;
% maxWFstim = max(WFtsre_stim);
% normWF_stim =(WFtsre_stim/maxWFstim)*100;
% 
% x = [1:length(WFtsre_stim.Data)];
% figure ('Name','Arousal Measures During WF Imaging.')
% plot(x,normWF_whisk.Data,'r',x,normWF_walk.Data,'b',x,WFtsre_Pupil.Data,'k',x,normWF_stim.Data,'g')
% ylim([-20 100])
% 
% %Function to do just the short version of the VNS calculations
% [wfavpup,wfavencoder,wfavwhisk,wfavlfp,wfavSU,wfavstim,wftime] = VNScalcs_short(pre,post,wfpks,wflocs,WFtsre_Pupil,WFtsre_encoder,WFtsre_whisk,WFtsre_lfp,WFtsre_SU,WFtsre_stim,Resamp_r);
% 
% avWF_WB=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_WB(:,i)=tsre_WB_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% avWF_Motor=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Motor(:,i)=tsre_Motor_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% avWF_Somato=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Somato(:,i)=tsre_Somato_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% 
% avWF_Visual=zeros(pre+post+1,length(wfpks));
% for i = 1:length(wfpks)
%     avWF_Visual(:,i)=tsre_Visual_dff.data(wflocs(i)-pre:wflocs(i)+post); %SU at each stim
% end
% 
% %% Save WIDEFIELD files if happy with them
% prompt = {'Would you like to save your widefield files? (Y/N)'};
% t = 'Input';
% dims = [1 25];
% definput = {'Y'};
% Saveanswer = inputdlg(prompt,t,dims,definput);
% % 
% % if Saveanswer{1,1} == 'Y'   
% %     prompt ={'Enter filename.'};
% %     t = 'Input';
% %     dims = [1 200];
% %     definput = {'0000_YYMMDD_1sec_800uA_190614_ms'};
% %     answer = inputdlg(prompt,t,dims,definput);
% %     filename = answer{1,1};
% %     selpath = uigetdir(path,'Select Mouse folder to save files.');
% %     cd(strcat(selpath))
% %     mkdir('Analysis_NewPHP');  cd(strcat(selpath,'\','Analysis_NewPHP'));  
% %     sav_loc = fullfile(selpath,'\','Analysis_NewPHP','\');
%   
% %Make a structure to save all WIDEFIELD variables into one structure to save a single file for   
% if exist('WFanswer')
%     if WFanswer{1,1} == 'Y'
%         All_WF_variables_struct.filename=filename;
%         All_WF_variables_struct.avpup=wfavpup;
%         All_WF_variables_struct.avencoder=wfavencoder;
%         All_WF_variables_struct.avwhisk=wfavwhisk;
%         All_WF_variables_struct.avSU=wfavSU;
%         All_WF_variables_struct.avlfp=wfavlfp;
%         All_WF_variables_struct.avWF_WB=avWF_WB;
%         All_WF_variables_struct.avWF_Auditory=avWF_Motor;
% %         All_WF_variables_struct.avWF_Somato=avWF_Somato;
% %         All_WF_variables_struct.avWF_Visual=avWF_Visual;
%         All_WF_variables_struct.time=wftime;
%         All_WF_variables_struct.avstim=wfavstim;
%         
%         save(strcat(sav_loc,filename,'_widefield_All_WF_variables_struct.mat'),'All_WF_variables_struct');
%         disp('Widefield Data Saved')
%     end
% end