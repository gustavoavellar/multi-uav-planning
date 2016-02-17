function plotStrips(lmin,lmax)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

hold on
plot(lmin(:,1),lmin(:,2),'ko',lmax(:,1),lmax(:,2),...
     'ko','LineWidth',3,'MarkerSize',15)
for i = 1:length(lmin)
    plot([lmin(i,1) lmax(i,1)],[ lmin(i,2) lmax(i,2)],'k--');
end
