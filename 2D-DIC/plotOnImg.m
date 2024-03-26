function [] = plotOnImg(Params, ImDef,comptPoints, Disp, strain, varible)

subplot(1,2,2);
imagesc(repmat(uint8(ImDef),1,1,3));
% [x, y] = ndgrid(Params.calPtX(1):Params.calPtX(end),Params.calPtY(1):Params.calPtY(end));
% Params.Lx_Pixel = size(x,1);
% Params.Ly_Pixel = size(x,2);


x      = reshape(comptPoints(:,1)+Disp(:,1),Params.Lx,Params.Ly);
y      = reshape(comptPoints(:,2)+Disp(:,2),Params.Lx,Params.Ly);



cLevel = 32;
h1 = subplot(1,2,2);
hold on,
switch varible
    case 'u'
        [C,h1] = contourf(y,x,reshape(Disp(:,1),Params.Lx,Params.Ly),cLevel);
        colorRange = [min(Disp(:,1)),max(Disp(:,1))];
    case 'v'
        [C,h1] = contourf(y,x,reshape(Disp(:,2),Params.Lx,Params.Ly),cLevel);
        colorRange = [min(Disp(:,2)),max(Disp(:,2))];
    case 'exx'
        [C,h1] = contourf(y,x,reshape(strain(:,1),Params.Lx,Params.Ly),cLevel);
        colorRange = [min(strain(:,1)),max(strain(:,1))];
    case 'eyy'
        [C,h1] = contourf(y,x,reshape(strain(:,2),Params.Lx,Params.Ly),cLevel);
    colorRange = [min(strain(:,2)),max(strain(:,2))];
    case 'exy'
        [C,h1] = contourf(y,x,reshape(strain(:,3),Params.Lx,Params.Ly),cLevel);
    colorRange = [min(strain(:,3)),max(strain(:,3))];
end

colormap('jet')
caxis(colorRange);
c = colorbar('east');
% c.Position = [0.8 0.2 0.01 0.6];
c.Color = [1,0,0];
c.Box = 'off';
set(h1,'LineColor','none');
axis('equal');axis('tight'); 
set(gca,'YDir','reverse'); 
axis off
drawnow,