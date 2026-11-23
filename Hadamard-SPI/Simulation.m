% Simulating of single-pixel imaging with Hadamard basis pattenrs
close all
clear 

% Parameters
nStep = 2;
num=128;
ratio=0.1;
NOISE_POWER =0; 

% Get input image
%[imgFile pathname] = uigetfile({'*.bmp;*.jpg;*.tif;*.png;*.gif'','...
%    'All Image Files';'*.*','All Files'});
%    
%InputImg = im2double(imread([pathname '\' imgFile]));
InputImg = im2double(imread('./pictures/cameraman.bmp')); 
InputImg = imresize(InputImg,[num,num]); 
% InputImg =rgb2gray(InputImg );
figure,subplot(131);imshow(InputImg);

[mRow, nCol] = size(InputImg);
if mRow ~= nCol
    error('Hadamrad requries square input image.');
else
    nPixel  = mRow;
end

% Get the order matrix
PathMat = zigzag(nPixel);

% Get the path matrix
K = round(nPixel^2*ratio);
IntensityMat = zeros(mRow, nCol,nStep);
NoiseMask = zeros(mRow,nCol);
PreRandNoiseMat = rand(size(IntensityMat)) * NOISE_POWER;
B=zeros(mRow, nCol);
p = zeros(mRow, nCol,K);

for i = 1:K
     [iRow, jCol] = find(PathMat == i);
       NoiseMask(iRow, jCol) = 1;
       B(iRow, jCol)=1;

     for j = 1:2
        Pattern = getHadamardPattern(nPixel, iRow, jCol, j);     
        % p(:,:,2*(i-1)+j)=Pattern;
       IntensityMat(iRow,jCol,j) = sum(sum(Pattern .* InputImg));
       % b1(2*(i-1)+j)=sum(sum(Pattern .* InputImg));
     end

end

% save('HT-32.mat','p');
NoisyMat = IntensityMat + PreRandNoiseMat .* repmat(NoiseMask, [1 1 2]);
% NoisyMat = awgn(IntensityMat,-10).* repmat(NoiseMask, [1 1 2]);

aver=(sum(sum(NoisyMat(:,:,1)))-NoisyMat(1,1,1))/(K-1);
B=B.*aver;


tic;
[img, spec] = getHSPIReconstruction( NoisyMat,B);
toc;


img=mat2gray(img);
subplot(132); imshow(img);
subplot(133);imagesc(mat2gray((log(abs(spec)+1).^(1/3)))); axis image;axis off;

PSNR = psnr(img, InputImg);                                                
SSIM = ssim(img, InputImg);
fprintf('PNSR = %f,SSIM = %f\n', PSNR, SSIM);


% %TV,admm
% for i = 1:K
%     c(:,:,i)=p(:,:,2*i-1)-p(:,:,2*i);
%     b(i)=b1(2*i-1)-b1(2*i);
% %     b(i)=b1(2*i-1);
% 
% end
% % b=2*(b-mean(b));
% b=awgn(b,-20);
% C=reshape(c,num*num,K);
% C=C';
% b=b';
% 
% 
% %%TVAL3
% clear opts
% opts.mu = 2^8;
% opts.beta = 2^5;
% opts.tol = 1E-2;
% opts.maxit = 300;
% opts.TVnorm = 1;
% opts.nonneg = true;
% [U, out] = TVAL3(C,b,num,num,opts);
% 
% % para.sigma = 150/255; U = admm(InputImg,C,b,para);
% % U=mat2gray(U);
% imshow(U)
% 





% img1=zeros(64,64);
% n=3;
% img1((1:n),(1:n))=img((1:n),(1:n));
% nosie= fwht2d(img1)/64;
% spec1=zeros(64,64);
% for i = 1:K
%      [iRow, jCol] = find(PathMat == i);
%       spec1(iRow,jCol)=spec(iRow,jCol)-nosie(iRow,jCol);
% end
% img= IHT(spec1)/64;



