function plotUavPath(waypoints)
%plotUavPath Summary of this function goes here
%   Detailed explanation goes here

if length(waypoints) > 6
    clr = prism(length(waypoints));
else
    clr = [1 0 0;
           0 1 0;
           0 0 1;
           1 1 0;
           1 0 1;
           0 1 1];
end

for k = 1:length(waypoints)
    i = 1;
    for i = 1:length(waypoints{k})
        %pause(0.25);
        plot(waypoints{k}(i,1),waypoints{k}(i,2),'o','Color',clr(k,:),...
             'LineWidth',4,'MarkerSize',8,'MarkerFaceColor',clr(k,:))
        if i > 1
            plot(waypoints{k}(i-1:i,1),waypoints{k}(i-1:i,2),'Color',clr(k,:),...
                 'LineWidth',4);
        end
    end
end

