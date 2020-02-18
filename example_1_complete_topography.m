clear all 
close all

% This is an example of some of the codes I've written for modeling using
% topographical maps. This is the easiest example, I didn't use
% interpolation methods, the data is placed "directly" on the model. If you
% run this script with the surf2stl.m and gebco_08_rev_elev_21600x10800.png
% file in the same directory you will have the Earth model in .stl with the
% topography exaggerated 50 times. If loaded in mm, the model will be 
% scaled one in one million, around 13 m. The topographic map is taken from 
% https://visibleearth.nasa.gov/view.php?id=73934



earth=imread('gebco_08_rev_elev_21600x10800.png');  % Load the file as an 
                                                    % image.

topo(:,:)=double(earth(length(earth(:,1,1)):-1:1,:,1)); 
% The map is converted to double, if not, their values will remain as 
% int8, so integers. The lines' indexs are taken upside down to make the 
% southern the lowest index value. By default, images are readed from up to 
% down. 

clear earth

topo = imresize(topo,0.05);     % Resize the map to make it easy to process
                                % You can set the interpolation method see
                                % help
 
res_latitude = length(topo(:,1));   
res_longitude= length(topo(1,:));
% The map dimensions are latitude x longitude.

h_dem=6.4;      % The height of the topography, as taken from the source.

radius=6378.1;  % The equatorial radius in km, the polar flatening will be 
                % added later.

exagg=50;       % Exaggeration of the topography.

topo=h_dem*exagg.*(topo)/255+radius-h_dem/2*exagg;
% This step transform the topo values from the image heights (from 0 to 
% 255) to the radius values: radius+topography.

thetavec = linspace(-pi/2,pi/2,res_latitude);
phivec = linspace(-pi,pi,res_longitude);
% This two lines define two vectors of the dimensions in which the
% topography is graphed. "thetavec" defines thelatitudes and goes from 
% -pi/2 (-90°, south pole) to pi/2 (90°, north pole); "phivec" defines the
% longitudes, from -pi to pi. The function "linspace" creates a vector
% between two values with the defined resolution, included the extremes.

[ph,th] = meshgrid(phivec,thetavec);
% "meshgrid" creates two matrix using the dimensions of both of vectors.
% "ph" is the matriz of longitudes ans "th" is that of latitudes.

[x,y,z]=sph2cart(ph,th,topo);
% Transform every point in spheric coordinates using the topography as
% radius, to cartesian (x, y and z). This step is important because
% "surf2stl" uses meshs in catesian coordinates.

z=z*6356.8/6378.1;      % This scale the z axis to make the polar 
                        % flattening. The exaggeration can be aplied here
                        % too.

surf2stl('earth.stl', x, y, z)

figure;
surf(x,y,z);        % Shows the 3d view of the model.
axis vis3d
axis equal