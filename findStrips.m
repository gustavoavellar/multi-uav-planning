function [lmin,lmax,V,laneDist] = findStrips(x,y,sidelap,imageWidth,imageLength)
%
%

% Calcula o fecho convexo da região a ser invertigada
k = convhull(x,y);

% Plota a região e o fecho convexo.
%plot(x(k),y(k),'k-')
plot([x; x(1)],[y; y(1)],'k+:')

% A partir deste ponto, os únicos pontos que interessam são aqueles que
% definem o fecho convexo.
x = x(k);
y = y(k);

% Rotaciona a região de interesse buscando para buscar o ângulo de
% varredura que utiliza o menor número de linhas.
areaWidth = max(x)-min(x);
thetamin = 0;
for i = 1:1:360
    theta = i*2*pi/360;
    R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    aux = R*[x y]';
    if (max(aux(1,:))-min(aux(1,:))) < areaWidth
        areaWidth = max(aux(1,:))-min(aux(1,:));
        thetamin = theta;
    end
end 
thetamin
% Rotaciona a região para o ângulo escolhido na etapa anterior, para
% facilitar os cálculos subsequentes.
R = [cos(thetamin) -sin(thetamin); sin(thetamin) cos(thetamin)];
aux = R*[x y]';
x = aux(1,:)';
y = aux(2,:)';

areaWidth = max(x)-min(x);
areaLength = max(y)-min(y);
numberOfLanes = ceil(areaWidth/(imageWidth*(1-sidelap)));
laneDist = areaWidth/(numberOfLanes);
for i = 1:numberOfLanes
    xi = min(x)+ ...
         laneDist*i-laneDist/2;
    delta = areaLength/imageLength;
    k = 0;
    miny = min(y) + k*delta;
    while ~inpolygon(xi,miny,x,y)
        miny = min(y) + k*delta;
        k = k + 1;
    end
    
    k = 0;
    maxy = max(y) - k*delta;
    while ~inpolygon(xi,maxy,x,y)
        maxy = max(y) - k*delta;
        k = k + 1;
    end
    
    lanemin(i,:) = [ xi miny ];
    lanemax(i,:) = [ xi maxy ];
end

lmin = (R'*lanemin')';
lmax = (R'*lanemax')';

% construção dos vértices
V = zeros(numberOfLanes*2+1,2);
for i = 1:numberOfLanes*2+1
    if i == 1
        V(i,:) = [0 0];
    elseif mod(i,2) == 0
        V(i,:) = lmin(i/2,:);
    else
        V(i,:) = lmax((i-1)/2,:);
    end
end
