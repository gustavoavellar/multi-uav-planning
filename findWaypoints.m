function waypoints = findWaypoints(X,V)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[visitedWaypoints,order] = max(X,[],1);

j = 1;
i = 1;
while i <= sum(visitedWaypoints)
    waypoints(i,:) = [V(order(j),1) V(order(j),2)];
    
    i = i + 1;
    j = order(j);
end
waypoints = [[0 0];waypoints];

