function [pc] = patchcolors(N)
% Creating a color for each patch based on N
% Created by: Aulia Khalqillah
% eamil: auliakhalqillah.mail@gmail.com or auliakhalqillah@usk.ac.id
% Tsunami and Disaster Mitigation Research Center (TDMRC)
% Universitas Syiah Kuala, Banda Aceh, Indonesia
    pc = (fliplr((1:N)/N))';
end