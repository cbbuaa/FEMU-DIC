function [Variable] = sortNode(Elements,Nodes_result_mess,...
    Nodes_mesh,Variable,isplot)
% The element read from mesh.nas
% isplot, should we plot the result: 1 or 0

if nargin<5
    isplot = 0;
end

for i = 1:length(Nodes_result_mess)
    dist = sqrt(sum((Nodes_mesh(i,:)-Nodes_result_mess).^2,2));
    [dist_min,indx_temp] = min(dist);
    indx_new(i,1) = indx_temp;
    dist_all(i,1) = dist_min;
end
Variable = Variable(indx_new,:);

if isplot
    for i = 1:size(Variable,2)
        figure,
        trisurf(Elements,Nodes_mesh(:,1),Nodes_mesh(:,2),Variable(:,i))
        axis tight,
        axis equal,
        shading interp
        box off,
        grid off,
        colormap('jet')
        colorbar
        axis off,
        view([0,90]);
        set(gca,'fontsize',22)
        set(gcf,'color','w'),
    end
end
