close all
clear 

for r=1:1:1
% Parameters
nStep = 2;
num=128;
ratio=0.01*r;

% Get input image
%[imgFile pathname] = uigetfile({'*.bmp;*.jpg;*.tif;*.png;*.gif'','...
%    'All Image Files';'*.*','All Files'});
%    
%InputImg = im2double(imread([pathname '\' imgFile]));
InputImg = im2double(imread('./pictures/USAF.png')); 
InputImg = imresize(InputImg,[num,num]); 
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
IntensityMat = zeros(mRow, nCol);%,nStep);
B=zeros(mRow, nCol);
% Pattern = zeros(num,num,K);
 
for i = 1:K
     [iRow, jCol] = find(PathMat == i);
    
    % Show fringe patterns and Capture
%      for iStep = 1:nStep
        Pattern = getHadamardPattern(nPixel, iRow, jCol);% -(-1)^iStep);       
        IntensityMat(iRow,jCol) = sum(sum(Pattern .* InputImg));
        B(iRow,jCol)=IntensityMat(1,1);
%      end
end

% save('HT.mat','Pattern');

tic;
[img, spec] = getHSPIReconstruction( IntensityMat,B);
toc;

subplot(132); imshow(img);
subplot(133);imagesc(mat2gray((log(abs(spec)+1).^(1/6)))); axis image;axis off;


% PSNR = psnr(img, InputImg);                                                
% SSIM = ssim(img, InputImg);
% fprintf('PNSR = %f,SSIM = %f\n', PSNR, SSIM);
PSNR(r) = psnr(img, InputImg);
SSIM(r) = ssim(img, InputImg);

end

