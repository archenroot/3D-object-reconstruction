function [ pts1, pts2 ] = subpixel( im1, im2, pts1, pts2, E )
% This Function assumes that the images are rectified and the epiolar lines
% are horizontal
N = size(pts1,1);
winSize = 5;
w = int32(round((winSize-1)/2));

for i=1:N
    costArray = zeros(1,3);
    x1 = int32(pts1(i,1)); x2 = int32(pts2(i,1)); 
    y1 = int32(pts1(i,2)); y2 = int32(pts2(i,2));
    p1 = im2double(im1(y1-w:y1+w,x1-w:x1+w));
       
    for j=x2-1:1:x2+1
        p2 = im2double(im2(y2-w:y2+w,j-w:j+w));
        costArray(1, j - x2 + 2) = sum(sum(abs(p1-p2)))+...
            (4/255)*abs(im1(y1,x1)-im2(y2,x2));
    end
    
    % Checking if the values are convex 
    if costArray(2) > min(costArray(1),costArray(3))
        continue;
    end
    
    denom = max(costArray(1) + costArray(3) - 2*costArray(2), 1);
    pts2(i,1)  = pts2(i+1) + ((costArray(1)-costArray(3))+denom)/(denom*2);
    
end

end

