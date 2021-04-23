clear all 
close all

% This is an example of the code I've made for my One Ring and Donut models
% published on Thingiverse: https://www.thingiverse.com/thing:3715894 and 
% https://www.thingiverse.com/thing:4574721 . You just need to run this
% code with MATLAB or Octave. For Octave you will need the Image package: 
% https://octave.sourceforge.io/image/index.html
% https://octave.org/doc/v4.4.0/Installing-and-Removing-Packages.html
% You also need to have the input image and the surf2stl function in the
% same directory as this code (or in the custom libraries). On Octave
% console type:
% pkg load image
% example_3_toroid 


mc=255;
imag_orig=imread('ring_input_image.png');   % Load the input image

img_fact=0.4;   % If you want to save execution time and output file size, 
                % you can reduce the whole size of the input image with the
                % function imresize.

topo = double(imresize(imag_orig(:,:,1),img_fact))/mc;
    
max_lat = length(topo(:,1));    
max_long= length(topo(1,:));
% The resolution of the model is defined by the input image size (resized)

etavec = linspace(0,2*pi,max_lat);
phivec = linspace(0,2*pi,max_long);
[ph,et] = meshgrid(phivec,etavec);

% All the measures are in mm. STL files are adimensional, but it is widely
% acepted to use the unit as mm for most of the slicers and CAD apps.

Di=19;              % Inner diameter. In a ring is where it goes the finger
thick=3;            % Is the widgh of the cut section
height=7;           % How tall the toroid is in the symetrical axis

% The following measures are derived from the previous ones:

R0=Di/2+thick/2;    % The "main" radius of the toroid.     
R1=thick/2;         % The radius of the cross section that is perpendicular
                    % to the symetrical axis
R2=height/2;        % The radius of the cross section parallel to the axis

deep=0.1*thick;     % The deep of the carving image. It is referenced to 
                    % the "thick" dimension. You can set it directly.

% The image in the following lines is taken as negative, so the higher
% brightness imply a deeper carving. The floor of this is the black color
% and white is the deepest part. If you want to change the carving function
% to "extruding" function, you just need to change "-topo" for "+topo" in
% the following 3 lines:

x = (sin(et).*(R1-topo.*deep)+R0).*cos(ph) ;    
y = -(sin(et).*(R1-topo.*deep)+R0).*sin(ph);
z = -cos(et).*(R2-topo.*deep);



surf2stl('toroid.stl', x, y, z)     % Export the STL

% figure;           % Uncomment these lines to get the 3d model view after
% surf(x,y,z);      % the stl in made. This function doesn't work on Octave
% axis vis3d        % CLI
% axis equal