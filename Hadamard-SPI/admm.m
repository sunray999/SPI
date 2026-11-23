function [out] = admm(obj,phi,y,para,psf)

im_vector = obj(:);
M=size(obj,1);

% 初始化变量
X = zeros(size(im_vector));
U = zeros(size(im_vector));
V = zeros(size(im_vector));

rho = 1;

% 计算逆矩阵
inv_matrix = (phi' * phi + rho * eye(size(phi, 2)));
phy=phi' * y;
invp=inv_matrix^-1;

tvweight = 0.07;    % weight for TV denoising
tviter   = 5;       % number of iteration for TV denoising

% 迭代更新
for i = 1:50
    
    X_tilda = V - U;
    rhs= phy + rho * X_tilda;
    X = invp*rhs;
    
    X_U = X + U;   
    X_U = proj(X_U);
    X_U = reshape(X_U, [M, M]);


%     V = TV_denoising(X_U,tvweight,tviter);
    V = ffdnet_imdenoise(X_U,[],para);
    %V=hessian(V,300,128,100,1);
    V = V(:);
    U = U + (X - V);
    
end

out = reshape(V, [M, M]);
% out=mat2gray(out);
end

