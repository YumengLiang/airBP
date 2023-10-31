%% rawdata to inputdata
function rawdata_to_inputdata (maindir,savedir,save_pic)
% maindir: The input data path 
% savedir: The save path
% savedir: save picture or not

subdirpath = fullfile( maindir, '*.mat' );
dat = dir( subdirpath );               % Subfolder for files with the suffix dat. 

% Loop over each .mat file
for j = 1  : length( dat )
    filename = dat( j ).name;    % get filename
    testId = split(filename,'.mat');
    testId = testId{1};
    fprintf("%s\n",filename);       
    % connect the root with filename to let us can directly find them
    savepath = fullfile(savedir, filename); % input_data
    datpath = fullfile( maindir, filename); % raw_data

    % we have 4 antenna , pick the best signal from each of them
    for i = 1:4
        [fftmax, ratio] = data_pretreatment7(datpath,i);
        if i==1
            temp = ratio;
            y = fftmax;
        elseif temp < ratio
            temp = ratio;
            y = fftmax;
        end
    end
    
    % Signal interception and filtering
    output = y(1:6300);
    [imf,residual] = vmd(output,'NumIMF',9);
    output = sum(imf(:,end-2:end-1),2);

    % show processed data
    if save_pic
        figure();set(gcf,'unit','normalized','position',[0.1,0.2,0.8,0.6]);
        plot(output);hold on;
        picname = [num2str(testId),'.jpg'];
        picname = ['./figure/',picname];% change the root where you want to save
        saveas(gcf, picname);
    end

    % save the signal in RSS format
    save(savepath, "output"); 
    close all
end
end
