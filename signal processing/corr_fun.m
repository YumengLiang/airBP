function[o_fft1dmax,ratio]= corr_fun(fft1dmax,fs)
%% The ACF correlation coefficient was calculated
o_fft1dmax=fft1dmax;
[b,a]=butter(4,[0.4,8]*2/fs); % 使用巴特沃斯滤波及smooth滤波对信号进行平滑
fft1dmax=filter(b,a,fft1dmax);
fft1dmax = fft1dmax(1001:end);
temp = smooth(fft1dmax,256);
fft1dmax = fft1dmax-temp;
fft1dmax = mapminmax(fft1dmax,-1,1);
fft1dmax = fft1dmax';
jiange_up = round(fs*60/50);
jiange_low = round(fs*60/160);
[ACF,~,~] = autocorr(fft1dmax,round(jiange_up)) ; % ACF为相关强度
[ratio,~] = max(ACF(jiange_low:jiange_up));
end