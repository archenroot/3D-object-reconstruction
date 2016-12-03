function fts = feature_extraction(I)
% given an image, returns features
    I = rgb2gray(I);
    points = detectSURFFeatures(I);
    [fts, valid_points] = extractFeatures(I, points);
%     figure; imshow(I); hold on;
%     plot(valid_points,'showOrientation',true);
end