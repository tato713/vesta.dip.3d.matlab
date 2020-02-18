function [z] = show_topo(ra)

% This function turns upside-down the lines of the map, allowing to see the
% map properly with the north up and south down. The function also
% parametrize the radius from its minimal to its maximal value, expanding
% the wanted range.

ra(:,:)=ra(length(ra(:,1)):-1:1,:);
z=(ra-min(min(ra)))/(max(max(ra))-min(min(ra)));
imshow(z);