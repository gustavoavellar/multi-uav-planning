close all
clear
% clc

%% Configurations
% UAV
global O
global uavNumber;
global uavSetupTime;
global uavFlightTime;
O = 1; % Operadores
uavNumber = 2;
uavSetupTime = 4;  % média de 8.2 minutos de setup
uavFlightTime = 30;

uavSpeed = 45;
%flightAltitude = 240;
%flightAltitude = 210;
flightAltitude = 180;

% Heurística 0: Não
%            1: Sim
h = 0;

% Camera specs
horizontalResolution = 4608;
verticalResolution = 3456;

% FOV típico de 35 mm
% 18mm h: 100 v: 66;
% 28mm h: 74 v: 49;
% 35mm h: 62 v: 41;
hfieldOfView = 74;
vfieldOfView = 49;
sidelap = .5;                   % image overlap

%% Parameters
imageWidth = flightAltitude*2*tan(pi*(hfieldOfView/2)/180);
imageLength = flightAltitude*2*tan(pi*(vfieldOfView/2)/180);

%% Program
plotMap;
% Selecione os pontos limítrofes da área a ser investigada. A base é o 
% primeiro ponto escolhido e os outros pontos (mínimo de três, no total)
%serão utilizados para definir a fronteira.
[x,y] = ginput;
% Exemplos:
%x = [500 500 1000 1000]'; y = [-250 250 -250 250]';
%x = [490 490 1510 1510]'; y = [500 -500 -500 500]';    % artigo
%x = [490 490 1510]'; y = [500 -500 500]';              % artigo
%x = [490 400 490 1000 1510 1400 1510 1000]'; y = [500 0 -500 -535 -500 0 500 575]'; %artigo
%x = [-2000 -2000 2000]'; y = [-500 -1000 -500]';
%x = 1.0e+03 * [0.370 0.251 2]';y = [-278 217 -200]';
%x = 1.0e+03 * [0.370 0.132 2]';y = [-278 722 -200]';
%x = [170 -101 561 337]';y = [ -297 727 -249 689]';
%x = [-325.3297 909.2549 732.8857 -525.5327]';y = [-406.7732 -201.8035 966.0468 718.1765]';
%x = [-225 165 1100 850]';y = [784 -716 -502 808]';
%x = [250 250 975]';y = [-300 725 725]';

%%
[lmin,lmax,V,laneDist] = findStrips(x,y,sidelap,imageWidth,imageLength);
plotStrips(lmin,lmax);
drawnow;
%%
uav = ones(uavNumber,1);
if uavNumber == 1
    uav(2,1) = 0;
end

[X,v,m] = lip3(V,uav,uavSpeed,uavSetupTime,uavFlightTime,h,O);
if m > 1 && h == 0
    while m > 1
        [ans,uavMaxTimeIndex] = max(v);
        uav(uavMaxTimeIndex) = 0;
        for i = 1: length(v)
            if v(i) == 0
                uav(i) = 0;
            end
        end
        
        waypoints{uavMaxTimeIndex} = findWaypoints(X(:,:,uavMaxTimeIndex),V);
        
        [visitedWaypoints,order] = max(X(:,:,uavMaxTimeIndex),[],1);
        j = 1; newV = [];
        for i = 1:length(V)
            if i == 1
                newV(j,:) = [0 0];
                j = j + 1;
            elseif visitedWaypoints(i) == 0
                newV(j,:) = V(i,:);
                j = j + 1;
            end
        end
        V = newV;
        
        [X,v,m] = lip3(V,uav,uavSpeed,uavSetupTime,uavFlightTime,h,O);
    end
    [ans,uavMaxTimeIndex] = max(v);
    uav(uavMaxTimeIndex) = 0;
    for i = 1: length(v)
        if v(i) == 0
            uav(i) = 0;
        end
    end
    
    waypoints{uavMaxTimeIndex} = findWaypoints(X(:,:,uavMaxTimeIndex),V);
else
    for i = 1:m
        waypoints{i} = findWaypoints(X(:,:,i),V);
    end
end
[t t_voo] = time(waypoints,uavSpeed,uavSetupTime,O)
laneDist

plotUavPath(waypoints);
%distance
beep
%plotForPaper;