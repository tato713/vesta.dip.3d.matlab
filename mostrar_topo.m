function [z] = mostrar_topo(ra)
ra(:,:)=ra(length(ra(:,1)):-1:1,:);
z=(ra-min(min(ra)))/(max(max(ra))-min(min(ra)));
imshow(z);