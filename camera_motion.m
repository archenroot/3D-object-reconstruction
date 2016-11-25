function [ R, T ] = camera_motion( F, K, R1, T1, pts1, pts2)
E = K'*F*K;%Essential Matrix
M2s = camera2(E);%We get four camera matrices
M1=zeros(3,4);
M1(:,1:3)=R1;
M1(:,4)=T1;
M1=K*M1;

for i=1:4
    M2=M2s(:,:,i);
    Rrel=M2(:,1:3);
    Trel=M2(:,4);
    R=Rrel*R1;
    T=Trel+Rrel*T1;
    M2(:,1:3)=R;
    M2(:,4)=T;
    M2=K*M2;
    [ P, error ] = triangulate( M1, pts1, M2, pts2 );  
    %error
    if(min(P(:,3))>0)
        fprintf('Found the correct M2\n');
        bestM2=M2;
        bestP=P;
    end
end
R=bestM2(:,1:3);
T=bestM2(:,4);

end

