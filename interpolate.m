function [ pts1, pts2 ] = interpolate( im1, im2, pts1, pts2, E )
% This function Assumes that the input images are rectified hence the
% epipolarlines are horizintal and parrallel to each other

disps = pts1(:,1)-pts2(:,1);
winSize = 5;
w = int32(round((winSize-1)/2));

DT = delaunayTriangulation([pts1(:,1),pts1(:,2)]);
dispImage = zeros(size(im1,1),size(im2,2));

for i=2:size(im1,1)-1
    for j=2:size(im1,2)-1
        if(im1(i,j)<150 && im1(i-1,j)<150 && im1(i+1,j)<150)
            continue
        end
        [ti,bc] = pointLocation(DT,[j,i]);
        if isnan(ti)
            continue;
        end
        
        triVals = disps(DT(ti,:));
        dispImage(i,j) = dot(bc',triVals')';
    end
end
dispImage = medfilt2(dispImage, [30 15]);

costPrior = [0.9 0.8 0.6 0.8 0.9];
pts1 = [];
pts2 = [];

for i = 3:size(im1,1)-3
    for j = 3:size(im1,2)-3
        
        if(im1(i,j)<150 && im1(i-1,j)<150 && im1(i+1,j)<150)
            continue
        end
        x1 = int32(j); x2 = int32(j - dispImage(i,j)); 
        y1 = int32(i); y2 = int32(i);
        p1 = im2double(im1(y1-w:y1+w,x1-w:x1+w));
        
        matchCost = zeros(size(costPrior));
        for k = x2-2:1:x2+2
            p2 = im2double(im2(y2-w:y2+w,k-w:k+w));
            matchCost(1, k - x2 + 3) = sum(sum(abs(p1-p2)))+...
                (4/255)*abs(im1(y1,x1)-im2(y2,x2));
        end
        
        matchCost = matchCost .* costPrior;
        [~, ind] = min(matchCost);
        
        pts1 = [pts1; j,i];
        pts2 = [pts2; j-dispImage(i,j)+ind-3, i];
    end
end

end

