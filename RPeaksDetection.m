function [Rpeak_loc] = RPeaksDetection(t,ecg)

thresh=0.60*max(diff(ecg));
k=[find(diff(ecg)>thresh); length(t)];

ind=(find(diff(k)>100))+1;
ind = unique([1; ind; length(k)]);


warning('off','MATLAB:polyfit:RepeatedPointsOrRescale');
for i=1:length(ind)-1
    j1 = k(ind(i));
    j2 = k(ind(i+1));
    [r_peak,i_peak] = max(ecg(j1:j2));
    j2 = (j1-1)+(i_peak+3);
    j1 = (j1-1)+(i_peak-3);
    pol = polyfit(t(j1:j2),ecg(j1:j2),2);
    [m(i),j(i)] = max((pol(1)*t(j1:j2).^2+pol(2)*t(j1:j2)+pol(3)));
    j(i) = j(i)+(j1-1);
end

Rpeak_loc = j';

end


