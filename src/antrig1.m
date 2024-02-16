function [ratio,time,eventrig,nw] = antrig1(trace,sta,lta,dt,minthres,maxthres,winlength)
% antrig1 is the function to pick/trigger unspike trace of microtemor.
% The code using STA/LTA algorithm was introduced by Allen (1978).
% In generally, the STA/LTA algorithm is used to trigger earthquake eventrig.
% When the ration of STA/LTA exceed to the threshold value, the earthquake
% (P-Wave) is detected.
%
% However, in this function (antrig1) of STA/LTA algorithm is opposite from
% the general STA/LTA algorithm. antrig1 funtion will be detected the eventrig
% when the ratio of STA/LTA in range of threshold between minimum threshold
% and maximum threshold.
%
% INPUT PARAMETERS
% trace         = waveform data
% sta           = Length of Short Term Window (in second, default is 1 s)
% lta           = Length of Long Term Window (in second, default is 30 s)
% dt            = sampling rate (in second, default is 0.01)
% minthres      = minimum threshold value (default is 0.2)
% maxthres      = maximum threshold value (default is 2.0)
% winlength     = Window length (default is 25 s)
%
% OUTPUT PARAMETERS
% ratio         = Ratio of STA/LTA
% time          = time series
% eventrig        = eventrig is detected [ntrig x 2]. ntrig is number of eventrig
% nw            = Number of window is detected
%
% HOW TO USE THIS FUNCTION
% sta = 1;
% lta = 30;
% dt = 0.01;
% minthres = 0.2;
% maxthres = 2.0;
% winlength = 25;
%
% [ratio,time,eventrig,nw] = antrig1(trace,sta,lta,dt,minthres,maxthres,winlength);
%
% This code was build by: Aulia Khalqillah, S.Si (2019)
% Contact: auliakhalqillah.mail@gmail.com or auliakhalqillah@usk.ac.id
% Master student of Physics, Department of Physics
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% Universitas Syiah Kuala, Banda Aceh, Aceh, Indonesia

if nargin < 7
    winlength = 25;
    if nargin < 6
        maxthres = 2.0;
        if nargin < 5
            minthres = 0.2;
            if nargin < 4
                dt = 0.01;
                if nargin < 3
                    lta = 30;
                    if nargin < 2
                        sta = 1;
                    end
                end
            end
        end
    end
end

% SET PARAMETERS
ns = sta/dt;
nl = lta/dt;
N = length(trace);
abstrace = abs(trace);
time = ((1:N)*dt)';

% CALCULATE STA/LTA RATIO
nsta = zeros(1,N);
nlta = zeros(1,N);

% LTA SEGMENT
for i = 1:N
    nlta(i) = mean(abstrace(i:nl));
    nl = nl + 1;
    if (nl > N)
        nl = N;
    end
end

% STA SEGMENT
for i = 1:N
    nsta(i) = mean(abstrace(i:ns));
    ns = ns + 1;
    if (ns > N)
        ns = N;
    end
end

ratio = nsta./nlta;

% ANTI-TRIGGER
ntrig = 1;
mindur = winlength/dt;
k = 1;
eventrig = [0,0];
while (mindur <= N)
    if (ratio(k:mindur) > minthres)
        if (ratio(k:mindur) < maxthres)
            strig = k;
            etrig = mindur;
            eventrig(ntrig,:) = [strig,etrig];
            ntrig = ntrig + 1;
        end
    else
        k = k + (winlength/dt);
        mindur = mindur + (winlength/dt);
    end
    k = k + (winlength/dt);
    mindur = mindur + (winlength/dt);
end

% PRINT THE NUMBER OF WINDOW ANTI-TRIGGER
nw = ntrig - 1;
% windowing = ('Window Tigger : %2g\n');
% disp(sprintf(windowing,nw))
end
