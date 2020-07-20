clear all, close all, clc

load('apex_notch_ECG_ERB_data.mat')



%% PRE-PROCESSING

% Apex and notch piezo filtering for heart rate
[bclph,aclph] = butter(4,4/(fs/2));
[bchph,achph] = butter(4,0.5/(fs/2),'high');

apex_h = filtfilt(bclph,aclph,apex);
apex_h = DC_removal(apex_h);
notch_h = DC_removal(notch);


% ERB, apex and notch piezos filtering for respiration rate
[blpr,alpr] = butter(4,0.5/(fs/2));

ERB_r = filtfilt(blpr,alpr,ERB);
ERB_r = DC_removal(ERB_r);
apex_r = filtfilt(blpr,alpr,apex);
apex_r = DC_removal(apex_r);
notch_r = filtfilt(blpr,alpr,notch);
notch_r = DC_removal(notch_r);



%% PEAKS DETECTION

% ECG R-PEAKS
locse = RPeaksDetection(time,ECG);
pkse = ECG(locse);
locse = time(locse);

% APEX_H PEAKS 
[pksc, locsc] =  findpeaks(apex_h,time,'MinPeakDistance',0.33,'Annotate','peaks','MinPeakProminence',0.025);
plotSignalsPeaks(time,apex_h,locsc,pksc,'Apex',ECG,locse,pkse,'ECG');

% NOTCH_H PEAKS
[pksn, locsn] = findpeaks(notch_h,time,'MinPeakDistance',0.45,'Annotate','peaks','MinPeakProminence',0.05);
plotSignalsPeaks(time,notch_h,locsn,pksn,'Notch',ECG,locse,pkse,'ECG');

% ERB PEAKS
[pksr, locsr] = findpeaks(-ERB_r,time,'MinPeakDistance',2,'Annotate','peaks','MinPeakProminence',0.5);

% APEX_R PEAKS
[pkscr, locscr] = findpeaks(-apex_r,time,'MinPeakDistance',2,'Annotate','peaks','MinPeakProminence',0.004);
plotSignalsPeaks(time,apex_r,locscr,-pkscr,'Apex',ERB_r,locsr,-pksr,'ERB');

% NOTCH_R PEAKS 
[pksnr, locsnr] = findpeaks(-notch_r,time,'MinPeakDistance',2,'Annotate','peaks','MinPeakProminence',0.004);
plotSignalsPeaks(time,notch_r,locsnr,-pksnr,'Notch',ERB_r,locsr,-pksr,'ERB');

% EDR peaks
[pksed, locsed] = findpeaks(-EDR,time,'MinPeakDistance',2,'Annotate','peaks','MinPeakProminence',0.004);
plotSignalsPeaks(time,EDR,locsed,-pksed,'EDR',ERB_r,locsr,-pksr,'ERB');



%% INTSTANTANEOUS HEART RATES SERIES

% ECG vs Apex
HRseries_E = 60./diff(locse);
HRseries_A = 60./diff(locsc);

figure
stem(HRseries_E,'.'), grid on, hold on
stem(HRseries_A,'.'), hold off
xlabel('# beat'), ylabel('Heart Rate (bpm)')
title('Instantaneous heart rates series from ECG and apex piezo')
legend('HR_{ECG}','HR_{apex}')


% ECG vs Notch
HRseries_N = 60./diff(locsn);

figure
stem(HRseries_E,'.'), grid on, hold on
stem(HRseries_N,'.'), hold off
xlabel('# beat'), ylabel('Heart Rate (bpm)')
title('Instantaneous heart rates series from ECG and notch piezo')
legend('HR_{ECG}','HR_{notch}')



%% INSTANTANEOUS RESPIRATION RATES SERIES

% ERB vs Apex
RRseries_R = 60./diff(locsr);
RRseries_A = 60./diff(locscr);

figure
stem(RRseries_R,'.'), grid on, hold on
stem(RRseries_A,'.'), hold off
xlabel('# act'), ylabel('Respiration Rate (apm)')
title('Instantaneous respiration rates series from ERB and apex piezo')
legend('RR_{ERB}','RR_{apex}')


% ERB vs Notch
RRseries_N = 60./diff(locsnr);

figure
stem(RRseries_R,'.'), grid on, hold on
stem(RRseries_N,'.'), hold off
xlabel('# act'), ylabel('Respiration Rate (apm)')
title('Instantaneous respiration rates series from ERB and notch piezo')
legend('RR_{ERB}','RR_{notch}')


% ERB vs EDR
RRseries_ED = 60./diff(locsed);

figure
stem(RRseries_R,'.'), grid on, hold on
stem(RRseries_ED,'.'), hold off
xlabel('# act'), ylabel('Respiration Rate (apm)')
title('Instantaneous respiration rates series from ERB and EDR')
legend('RR_{ERB}','RR_{EDR}')
