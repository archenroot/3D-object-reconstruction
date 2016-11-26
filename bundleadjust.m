function [ P,vSet ] = bundleadjust( im1,im2,K1,K2,M1,M2,p1,p2,vSet )
%im1 and im2 are the input images
%   K1 and K2 are the intrinsic matrices
% M1 and M2 are the camera matrices
%p1 and p2 are the locations of corres[ondences
%If this is being caalled first time then vSet need not be specified from
%the next time the returned vSet has to be passed as an input
%One thing to note is that since this involves huge computations the output
%size is pretty small, p1 and p2 cannot exceed a certain number(~20000) -->
%maybe a drawback of using bundle adjustment. But if we are creating a
%surface out of the 3D, it should be fine I assume.
%%Plotting the camera Views also along with the 3D points
%load('bundle.mat');
if(size(im1,3)~=1)
    im1=rgb2gray(im1);
end
if(size(im2,3)~=1)
    im2=rgb2gray(im2);
end
pm1=K1\M1;
pm2=K2\M2;
if(nargin==8)
    vSet = viewSet;%Defining it for the first pair
end
[features1, validp1] = extractFeatures(im1, p1);
[features2, validp2] = extractFeatures(im2, p2);
indexPairs = matchFeatures(features1, features2, ...
        'Unique',  true,'MaxRatio', 1);
indexPairs = double(indexPairs);    
mp1 = validp1(indexPairs(:, 1),:);
mp2 = validp2(indexPairs(:, 2),:);
vSet = addView(vSet, 1, 'Points', validp1, 'Orientation', pm1(:,1:3),...
    'Location', pm1(:,4)');

vSet = addView(vSet, 2, 'Points', validp2);
%%IF all the points in pts1 and pts2 are matching then we will have matches
%%running from 1 to size(pts1,1) twice
%matches = repmat((1:size(p1, 1))', [1, 2]);
vSet = addConnection(vSet, 1, 2, 'Matches', indexPairs);%Updating the 
%%connection between the images using the corresponding matches.
vSet = updateView(vSet, 2, 'Orientation', pm2(:,1:3), ...
        'Location', pm2(:,4)');
tracks = findTracks(vSet);
camPoses = poses(vSet);
cameraParams = cameraParameters('IntrinsicMatrix',K1);

%%We will call the inbuilt bundle adjustment module here
[ P, ~ ] = triangulate( M1, mp1, M2, mp2 );
[P, camPoses, ~] = bundleAdjustment(...
    P, tracks, camPoses, cameraParams, 'FixedViewId', 1);
%Updating the camera poses
vSet = updateView(vSet, camPoses);

figure;
helperPlotCameras(camPoses);
%%Plot the 3D points also using pcshow
pcshow(P);


end

