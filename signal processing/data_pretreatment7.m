%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%input :file_name and index of chosen Rx
%output: RSS variation over time at 210 Hz sample rate
%Note: there is something wrong with the first chirp of three Rx
%      so we replace the first chirp using before and after chirp data
%   由于rx2-4的第一个chirp的数据存在问题，因此需把rx2-4的第一个chirp用前后chirp的数据代替。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fft1dmax,ratio] = data_pretreatment (filename,rx_chosen)
load(filename);

temp= squeeze(feature_list7(1:1000,:,:,:)); %choose time sequence
temp = permute(temp,[3,1,2,4]);
lentocope = 7000;
x1 = zeros(1,lentocope,256);
fs = 7/mean(diff(time_list));       % set fs

temp(1) = temp(2);

if rx_chosen ==1  
    for i = 1:lentocope
        k = mod(i,7);
        if k == 0
           k = 7; 
        end
        x1(1,i,:)= temp(rx_chosen,floor((i-1)/7)+1,:,k);
    end
else
    % for other Rx antenna, there seems something wrong with the first chirp
    % so we recompute it using the chirp before and after 
    for i = 1:lentocope
        k = mod(i,7);
        if k == 0
           k = 7; 
        end
        if k~=1
            x1(1,i,:)= temp(rx_chosen,floor((i-1)/7)+1,:,k);
        else
            if i==1
                x1(1,1,:)= temp(rx_chosen,1,:,2);
            else
                temp1 = (temp(rx_chosen,floor((i-1)/7)+1,:,2)+temp(rx_chosen,floor((i-1)/7),:,7))/2;
                x1(1,i,:) = temp1;
            end
        end
    end    
end
x1= double(x1);
meanx1= mean(x1,3);
meanx1=reshape(meanx1,1,lentocope,1);
meanx1=repmat(meanx1,1,1,256);
x1 = x1 - meanx1; % remove the zero-frequency component

Hann_window=hann(256,'periodic');
ScaleHannWin = 1/sum(Hann_window);
Hann_window = repmat(Hann_window,1,lentocope);
x1 = squeeze(x1);
fft1d= fft(x1.*Hann_window',256,2)*1*ScaleHannWin;

fft1dmax = abs(fft1d); % obtain RSS

k1 = 4; k2 = 10; % desired range bin 
[fft1dmax, ratio] = obsevation(fft1dmax, fs,k1,k2);  %ACC-max Beamforming

%%resample data to fixed sample rate of 210 Hz
t7 = zeros(1,lentocope);
nt = length(time_list);
for i = 1:nt-1
    t_left = time_list(i);
    t_right = time_list(i+1);
    tlr = linspace(t_left,t_right,8);
    i_left= 7*(i-1)+1;
    i_right = i_left+6;
    t7(i_left:i_right) = tlr(1:7);
end
t_end = time_list(end);
max_xq = t_end;  
n_xq = round(t_end*210);  %set sample rate to  210Hz
xq = linspace(0,t_end,n_xq);
vq = interp1(t7,fft1dmax,xq);

fft1dmax = vq';
fft1dmax = fft1dmax(1:7000);
end

