%% Demo script 

load 'camera.mat'

imagefiles = dir('test_images/*.tif');      
nfiles = length(imagefiles);    % Number of files found
images = zeros(64,64,1,nfiles);
for ii=1:nfiles
   currentfilename = imagefiles(ii).name;
   currentimage = imread(['test_images/' currentfilename]);
   im = rgb2gray(currentimage);
   %% Get Fundamental 
   
   %% Get Dense Correnspondences 
   
   %% Get Subpixel and dense disparity
   
   %% Get Triangulation
   
   %% BA
   
end