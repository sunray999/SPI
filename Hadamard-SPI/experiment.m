% experiment of single-pixel imaging with Hadamard basis pattenrs
clear
path(path,genpath(pwd));

data=load('H_256_USAF_11.mat').data;
mean(data)

num=1024;
ratio=0.5;
scale =8;
step=2;
nPixel= 64;%num / scale;

%sampling path
PathMat = zigzag(nPixel);

K = round(nPixel^2*ratio);
% IntensityMat = zeros(nPixel, nPixel,step);
IntensityMat = zeros(nPixel, nPixel);
D1=data(1);
% D2=data(2002);
% a=data(1:2:2*K-1);
% D=sum(a(2:K))/(K-1);


for i = 1:K
     [iRow, jCol] = find(PathMat == i);
     for j = 1:2
        p(:,:,2*(i-1)+j)=getHadamardPattern(nPixel, iRow, jCol, j);
     end   
     
     IntensityMat(iRow,jCol) = ( data(2*i-1)- data(2*i)  )*1e1;
%      IntensityMat(iRow,jCol) = ( data(2*i-1)- D)*2e3;

end

%TV,admm
for i = 1:K
    c(:,:,i)=p(:,:,2*i-1)-p(:,:,2*i);
    b(i)=data(2*i-1)- data(2*i);
end
C=reshape(c,nPixel^2,K);
C=C';

tic;
spec=IntensityMat/(128)/(128);
img= IHT(spec)/(128);
toc;



% %TVAL3
% clear opts
% opts.mu = 2^8;
% opts.beta = 2^5;
% opts.tol = 1E-2;
% opts.maxit = 300;
% opts.TVnorm = 1;
% opts.nonneg = true;
% tic
% [img, out] = TVAL3(C,b',nPixel,nPixel,opts);
% toc
para.sigma = 100/255; 
tic
img = admm(img,C,b',para);
toc

img=mat2gray(img);

subplot(121), imshow(img);%title('Reconstructed Img');
subplot(122),imagesc(mat2gray((log(abs(spec)+1).^(1/6)))); axis image;axis off;
cnr=max(max(img))-min(min(img))/max(max(img))+min(min(img))

% psnr(img,o),ssim(img,o)

% img(img<0)=0;
% x=[1:60];
% a=img(150:209,145);
% b=[0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,0,0,0,0];
% plot(x,a,'-r',x,b,'-black');
% axis([1,60,-0.1,1.1])
% xlabel('x/pixel');ylabel('Intensity(a.u.)');



% a=data(1:1:4000);
% b=data(2:2:4000);
% c=a+b;
% plot(1:4000,a)
% d=c-0.4500;
% plot(1:2000,d)


