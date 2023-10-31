clear;clc;

rootpath = '';  % Set the project storage root directory
save_pic = 1;   % if you want to save the signal as picture then set 1
rawdata_dir = [rootpath,'raw_data\']; % Set root directory of the data needed to process 
list_root=[rootpath,'input_data\']; % A root directory to save the processed data
if save_pic == 1
    set(0,'DefaultFigureVisible', 'on'); %  Set the image to be saved without display by 'off'
end

% Call the function to process inputdata into vmdgt and save it
rawdata_to_inputdata (rawdata_dir,list_root,save_pic); 
disp('rawdata to inputdata is finished');
