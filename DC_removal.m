function [sig_out] = DC_removal(sig_in)
% One-pole one-zero high-pass filter for DC removal

lamda=0.9996;
b = [1 -1];
a = [1 -lamda]; 

sig_out=filtfilt(b,a,sig_in);
end

