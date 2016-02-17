function plotMap()

figure(1)
% Selecione o mapa desejado
A = imread('hangar.jpg');
base = [897.5000  491.5000];
N = -20.72613271;
W = -43.81682358;
S = -20.74471033;
E = -43.77901375;

%imshow('ufmg.jpg');
%base = 1.0e+03 * [1.8379    2.6473];
%N = -20.72613271;
%W = -43.81682358;
%S = -20.74471033;
%E = -43.77901375;

mapWidth = abs(deg2km(E-W)*1000);
mapHeight = abs(deg2km(N-S)*1000);
Rx = base(1)/size(A,2);
Ry = base(2)/size(A,1);

RA = imref2d(size(A), [-Rx*mapWidth (1-Rx)*mapWidth],...
                      [-Ry*mapHeight (1-Ry)*mapHeight]);
imshow(A,RA,'InitialMagnification',50);

%axis([-1000 1000 -1000 1000]);
grid on; hold on;
%axis equal
