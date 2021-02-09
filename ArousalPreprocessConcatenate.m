%% Combine and Contatenate files from VNS1
clear;
% 
% cd('\\mammatus2\Widefield\Laura\Data\EphysAnalysisBlanked'); %Default folder
% addpath(genpath('\\mammatus2\Widefield\Laura\Data\EphysAnalysisBlanked'))%adds all folders and subfolders to the path
selpath = uigetdir(path,'Select folder to search for files.'); %Uncomment to select folder to search for data files
cd(selpath);

dir_paths = genpath(selpath); 
C = strsplit(dir_paths, ';');
dirs = []; 
for i = 1:length(C)
    this_dir = string(C{i});
    dirs = [dirs; this_dir];
end

slash_counts = count(dirs,'\');

batch_files_idx = find(slash_counts == 7);

sessions = dirs(batch_files_idx); 

ses= dir('**/*All_variables_struct.mat'); %Find all files called All_variables_struct.mat

%load in all of these files into the structure concat_struct

for i=1:length(ses)
     
    f=fullfile(ses(i).folder,ses(i).name)
    if exist('this_data')
        this_data=load(f)
        concat_struct=[concat_struct,this_data]
    else
        this_data=load(f)
        concat_struct=this_data
    end    
    i
end
% 

% Now access each field within concat_struct and concatenate
concat_struct
avpup=[];
avencoder=[];
avwhisk=[];
avSU=[];
avlfp=[];
time=[];
avstim=[];
filenames={};
number_of_stims=[];

for j=1:length(concat_struct)
    filenames=[filenames,concat_struct(j).All_variables_struct.filename];
    number_of_stims=[number_of_stims,size(concat_struct(j).All_variables_struct.avpup,2)];
    avpup=[avpup,concat_struct(j).All_variables_struct.avpup];
    avencoder=[avencoder,concat_struct(j).All_variables_struct.avencoder];
    avwhisk=[avwhisk,concat_struct(j).All_variables_struct.avwhisk];
    avSU=[avSU,concat_struct(j).All_variables_struct.avSU];
    avlfp=[avlfp,concat_struct(j).All_variables_struct.avlfp];
    time=[time,concat_struct(j).All_variables_struct.time];
    avstim=[avstim,concat_struct(j).All_variables_struct.avstim];
 
end

% Save Concatenated Files to the folder of your choice
prompt ={'Enter filename.'};
t = 'Input';
dims = [1 200];
definput = {'Concatenated_Files_5sec_1000uA_YYMMDD'};
answer = inputdlg(prompt,t,dims,definput);
FileName = answer{1,1};
selpath = uigetdir(path,'Select folder to save concatenated workspace file.');
cd(selpath)
clear f i j ses this_data concat_struct definput dims t prompt 
save(strcat(selpath,'\',FileName));
disp('Data Saved')







% %% Do the same as above for Widefield data
% % prompt = {'Would you like to concatenate Widefield Data (Y/N)'};
% % t = 'Input';
% % dims = [1 25];
% % definput = {'Y'};
% % WFanswer = inputdlg(prompt,t,dims,definput);
% % 
% % if WFanswer{1,1} == 'Y'   
%  clear
%  
% selpath = uigetdir(path,'Select folder to search for files.'); %Uncomment to select folder to search for data files
% cd(selpath);
% ses= dir('**/*All_WF_variables_struct.mat'); %Find all files called All_variables_struct.mat
% 
% 
% %load in all of these files into the structure concat_struct
% for i=1:length(ses)
%     if strfind(ses(i).name,'5sec_100uA')
%         
%     f=fullfile(ses(i).folder,ses(i).name)
%     if exist('this_data')
%         this_data=load(f)
%         concat_struct=[concat_struct,this_data]
%     else
%         this_data=load(f)
%         concat_struct=this_data
%     end
%     end
%     i
% end
% 
% % Now access each field within concat_struct and concatenate
% % concat_struct
% wfavpup=[];
% wfavencoder=[];
% wfavwhisk=[];
% wfavSU=[];
% wfavlfp=[];
% wftime=[];
% filenames={};
% wfnumber_of_stims=[];
% wfavstim=[];
% avWF_WB=[];
% avWF_Motor=[];
% avWF_Somato=[];
% avWF_Visual=[];
% % avWF_MotorL=[];
% % avWF_SomatoL=[];
% % avWF_VisualL=[];
% 
% % 
%     for j=1:length(concat_struct)
%     filenames=[filenames,concat_struct(j).All_WF_variables_struct.filename];
%     wfnumber_of_stims=[wfnumber_of_stims,size(concat_struct(j).All_WF_variables_struct.wfavpup,2)];
%     wfavpup=[wfavpup,concat_struct(j).All_WF_variables_struct.wfavpup];
%     wfavencoder=[wfavencoder,concat_struct(j).All_WF_variables_struct.wfavencoder];
%     wfavwhisk=[wfavwhisk,concat_struct(j).All_WF_variables_struct.wfavwhisk];
%     wfavSU=[wfavSU,concat_struct(j).All_WF_variables_struct.wfavSU];
%     wfavlfp=[wfavlfp,concat_struct(j).All_WF_variables_struct.wfavlfp];
%     wftime=[wftime,concat_struct(j).All_WF_variables_struct.wftime];
%     wfavstim=[wfavstim,concat_struct(j).All_WF_variables_struct.wfavstim];
%     avWF_WB=[avWF_WB,concat_struct(j).All_WF_variables_struct.avWF_WB];
%     avWF_Motor=[avWF_Motor,concat_struct(j).All_WF_variables_struct.avWF_Motor];
%     avWF_Somato=[avWF_Somato,concat_struct(j).All_WF_variables_struct.avWF_Somato];
%     avWF_Visual=[avWF_Visual,concat_struct(j).All_WF_variables_struct.avWF_Visual];
% %     avWF_MotorL=[avWF_MotorL,concat_struct(j).All_WF_variables_struct.avWF_MotorL];
% %     avWF_SomatoL=[avWF_SomatoL,concat_struct(j).All_WF_variables_struct.avWF_SomatoL];
% %     avWF_VisualL=[avWF_VisualL,concat_struct(j).All_WF_variables_struct.avWF_VisualL];
% %     
%     end
%     
% % Save Concatenated Files to the folder of your choice
% prompt ={'Enter filename.'};
% t = 'Input';
% dims = [1 200];
% definput = {'Concatenated_Widefield_Files_5sec_1000uA_YYMMDD'};
% answer = inputdlg(prompt,t,dims,definput);
% filename = answer{1,1};
% selpath = uigetdir(path,'Select folder to save concatenated workspace file.');
% cd(selpath)
% clear f i j ses this_data concat_struct definput dims t prompt 
% save(strcat(selpath,'\',filename));
% disp('Widefield Data Saved')
% % else 
% %     disp('No Widefield data concatenated or saved')
% % end
% 
% 
% %% %% Do the same as above for AUDITORY Widefield data
% clear
%   
% selpath = uigetdir(path,'Select folder to search for files.'); %Uncomment to select folder to search for data files
% cd(selpath);
% ses= dir('**/*Aud_WF_struct.mat'); %Find all files called All_variables_struct.mat
% 
% %load in all of these files into the structure concat_struct
% for i=1:length(ses)
%     if strfind(ses(i).name,'500ms_800uA')
%         
%     f=fullfile(ses(i).folder,ses(i).name)
%     if exist('this_data')
%         this_data=load(f)
%         concat_struct=[concat_struct,this_data]
%     else
%         this_data=load(f)
%         concat_struct=this_data
%     end
%     end
%     i
% end
% 
% % Now access each field within concat_struct and concatenate
% % concat_struct
% 
% wftime=[];
% filenames={};
% wfavstim=[];
% avWF_aud=[];
% wfnumber_of_stims=[];
% 
%     for j=1:length(concat_struct)
%     filenames=[filenames,concat_struct(j).Aud_WF_struct.filename];
%     wfnumber_of_stims=[wfnumber_of_stims,size(concat_struct(j).Aud_WF_struct.avWF_aud,2)];
%     wftime=[wftime,concat_struct(j).Aud_WF_struct.wftime];
%     wfavstim=[wfavstim,concat_struct(j).Aud_WF_struct.wfavstim];
%     avWF_aud=[avWF_aud,concat_struct(j).Aud_WF_struct.avWF_aud];
%       end
%     
% % Save Concatenated Files to the folder of your choice
% prompt ={'Enter filename.'};
% t = 'Input';
% dims = [1 200];
% definput = {'Concatenated_Auditory_Widefield_Files_5sec_1000uA_YYMMDD'};
% answer = inputdlg(prompt,t,dims,definput);
% filename = answer{1,1};
% selpath = uigetdir(path,'Select folder to save concatenated workspace file.');
% cd(selpath)
% clear f i j ses this_data concat_struct definput dims t prompt 
% save(strcat(selpath,'\',filename));
% disp('Audutory Widefield Data Saved')
% % else 
% %     disp('No Widefield data concatenated or saved')
% % end
