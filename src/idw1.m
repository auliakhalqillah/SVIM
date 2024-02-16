function [X,Y,Z,w,d,N] = idw1(XI,YI,V,p,grid)
% 
% idw1 is the Inverse Distance Weight interpolation (IDW) function.
% This function is used to interpolate values based on the sample point.
% The code was build based on paper from Shepard (1968).
% 
% INPUT PARAMPETERS
% XI   = Coordinate on x axis [Nx1]
% YI   = Coordinate on y axis [Nx1]
% V    = A value that want to interpolate [Nx1]
% p    = Exponent parameter of weight (w) or power of distance between two points
%        The default value of p is equal to 2
% grid = Size of grid for interpolation (default is 100)
% 
% OUTPUT PARAMETERS
% X   = Interpolated coordinate on x axis [NxN]
% Y   = Interpolated coordinate on y axis [NxN]
% Z   = Interpolated value [NxN]
% 
% HOW TO USE THIS FUNCTION? [X,Y,Z] = idw1(XI,YI,V,p,grid)
% 
% XI = [20;30;15;25;50;35;10];
% YI = [45;23;19;31;28;39;17];
% V = [2.5;2.2;1.5;3;4.5;2;5];
% [X,Y,Z] = idw1(XI,YI,V);
% contourf(X,Y,Z);
% 
% CONTACT:
% Aulia Khalqillah
% auliakhalqillah.mail@gmail.com or auliakhalqillah@usk.ac.id
% Master student of Physics, Department of Physics
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% Universitas Syiah Kuala, Banda Aceh, Aceh, Indonesia
% 
%  The code was build on 15 January 2019

% Set Default input parameters
if nargin < 5
    grid = 100;
    if nargin < 4
        p = 2;
    end
end

% Set Parameters
[X,Y] = meshgrid(min(XI):(max(XI)-min(XI))/(grid-1):max(XI),min(YI):(max(YI)-min(YI))/(grid-1):max(YI));
N = length(XI);
LG = length(X(:));
Z = zeros(LG,1);

% IDW Process
for i = 1:LG
    d = sqrt(abs((X(i)-XI).^2) + abs((Y(i)-YI).^2));
    d(d==0) = eps;
    d(d>inf) = inf;
    w = 1./d.^p;
    Z(i) = sum(V.*w)/sum(w);  
end
L = sqrt(length(Z));
Z = reshape(Z,L,L);
end