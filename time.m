function [t t_voo] = time(waypoints,uavSpeed,uavSetupTime,O)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for k = 1:length(waypoints)
    sum1 = 0;
    for i = 2:length(waypoints{k})
        sum1 = sum1 + norm(waypoints{k}(i,:)-waypoints{k}(i-1,:))/(uavSpeed*1000/60);
    end
    t(k) = sum1 + ceil(k/O)*uavSetupTime;
    t_voo(k) = sum1;
end


