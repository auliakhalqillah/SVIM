% cosinewin (cosine tapering) is the function for tapering of windowed time series
% This function is written based on article of Tapering of Windowed Time Series
% by Marco Pilz and Stefano Parolai, (GFZ)-(2012)
%
% INPUT PARAMETER
% a     = value of cosine window (ex: 0.5)
% n     = length of data
%
% OUTPUT PARMETER
% c     = cosine taper coefficient
%
% HOW TO USE IT?
% c = cosinewin(a,n)
%
% If the "d" is data in time series, cosinewin is applied to "d" type
%   y = d.*c
% finally, cosinewin has been implemented in "y" as the tapered data time series
%
% Created by    : Aulia Khalqillah, S.Si (2019)
% Email         : auliakhalqillah.mail@gmail.com
%                 auliakhalqillah@usk.ac.id
% Master student of Physics, Department of Physics
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% Universitas Syiah Kuala, Banda Aceh, Aceh, Indonesia.

function c = cosinewin(a,n)
t = linspace(0,1,n)';
t1 = round(a*(n-1))+1;
t2 = n-t1+1;
c = [(1-cos(pi/a*t(1:t1-1)))/2; ones(t2-t1-1,1); (1-cos(pi/a*(1-t(t2:end-1))))/2];
end
