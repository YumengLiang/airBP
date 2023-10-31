%%% ACC-max Beamforming
function[temp_fftmax,temp]= obsevation(fft1dmax,fs,k1,k2)
for rangeBin = k1:k2  
    % calculate the correlation
    [fftmax, ratio] = corr_fun(fft1dmax(:,rangeBin),fs);
    % find the best signal by checking the ratio
    if rangeBin==k1
        temp = ratio;
        temp_fftmax = fftmax;
    elseif temp < ratio
        temp = ratio;
        temp_fftmax = fftmax;
    end   
end

end
