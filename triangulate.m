function [ P, error ] = triangulate( K, R, T, p1, p2 )
% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       p2 - Nx2 set of points

M1 = K*[eye(3),[0;0;0]];
M2 = K*[R,T];
n = size(p1,1);
A = zeros(4,4);
P = zeros(4,n);
for i=1:n
    for j=1:4
       A(1,j) = M1(3,j)*p1(i,1) - M1(1,j);
       A(2,j) = M1(3,j)*p1(i,2) - M1(2,j);
       A(3,j) = M2(3,j)*p2(i,1) - M2(1,j);
       A(4,j) = M2(3,j)*p2(i,2) - M2(2,j);
    end
  [~,~,va] = svd(A);
  P(:,i) = va(:,4);
  P(:,i) = P(:,i)./P(4,i);
end




end

