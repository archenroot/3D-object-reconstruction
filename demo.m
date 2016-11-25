%% Demo script 

load 'camera.mat'

imagefiles = dir('test_images/*.tif');      
nfiles = length(imagefiles);    % Number of files found
images = zeros(64,64,1,nfiles);
for ii=1:nfiles-1
   currentfilename = imagefiles(ii).name;
   currentimage = imread(['test_images/' currentfilename]);
   im1 = rgb2gray(currentimage);
   currentfilename = imagefiles(ii+1).name;
   currentimage = imread(['test_images/' currentfilename]);
   im2 = rgb2gray(currentimage);
   
   %% Get Fundamental 
   
   %% Get Dense Correnspondences 
   
   %% Get Subpixel and dense disparity
   
   %% Get Triangulation
   
   %% BA
   
end