function [y,fc] = kosmooth(data,b)
% kosmooth is smoothing function based on Konno-Ohmachi Smoothing (1998)
% This function can be used for smoothing a spectrum
% 
% INPUT PARAMETERS 
% data          = data vector [1xN]
% b             = the smoothing coefficient (default is 40)
% 
% OUTPUT PARAMETER
% y             = smoothed vector [1XN]
% fc            = center frequency (in Hz)
% 
% HOW TO USE THIS FUCNTION?
% [y,fc] = kosmooth(data,b)
% 
% Created by: Aulia Khalqillah, S.Si (2019)
% Contact: auliakhalqillah.mail@gmail.com or auliakhalqillah@usk.ac.id
% Master student of Physics, Department of Physics
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% Universitas Syiah Kuala, Banda Aceh, Aceh, Indonesia.
% 

% SET DEFAULT PARAMETERS
if nargin < 2
    b = 40;
end

ff = (0:length(data)-1);
f_shifted = ff./(1+1e-4);

L = length(data);
w = zeros(1,L);
y = zeros(1,L);
fc = zeros(1,L);
for i = 1:L
    fc(i) = ff(i);
    z = (f_shifted./fc(i)).^b;
    w = (sin(log10(z))./log10(z)).^4;
    w(isnan(w)) = 0;
    y(i) = dot(w,data)/sum(w);
    y(isnan(y)) = 0;
end
end