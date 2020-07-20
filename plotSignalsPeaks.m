function plotSignalsPeaks(t,test,locspkstest,pkstest,testlabel,ref,locspksref,pksref,reflabel)

figure, plot(t,ref,locspksref,pksref,'r*'), grid on
hold on
plot(t,test*max(ref)/max(test),'m',locspkstest,pkstest*max(ref)/max(test),'g*')
xlabel('Time (s)'), ylabel('Amplitude (a.u.)')
legend(testlabel,[testlabel '_{pks}'],reflabel,[reflabel '_{pks}']);


end