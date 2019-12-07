%% Individuazione di un difetto su un'immagine di tessitura
clear all;
close all;
clc;

% Image
img = imread('defect1.jpg');
grayImg = rgb2gray(img);
[row,col]=size(grayImg);
hR = round(row/2);
hC = round(col/2);

% Patterns
pSize = 14;
hP = round(pSize/2);
patterns = {
    grayImg(1:1+pSize, 1:1+pSize)       grayImg(1:1+pSize, hC-hP:hC+hP)     grayImg(1:1+pSize, col-pSize:col)
    grayImg(hR-hP:hR+hP, 1:1+pSize)     grayImg(hR-hP:hR+hP, hC-hP:hC+hP)   grayImg(hR-hP:hR+hP, col-pSize:col)
    grayImg(row-pSize:row, 1:1+pSize)   grayImg(row-pSize:row, hC-hP:hC+hP) grayImg(row-pSize:row, col-pSize:col)
};

% Image and patterns plot
figure;
subplot(1,2,1);
imagesc(img); axis image; hold on;
title('Image in RGB');
subplot(1,2,2);
imagesc(grayImg); axis image; colormap gray; hold on;
rectangle('position',[1,1,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[hC-hP,1,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[col-pSize,1,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[1,hR-hP,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[hC-hP,hR-hP,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[col-pSize,hR-hP,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[1,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[hC-hP,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
rectangle('position',[col-pSize,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
title('Gray Image');

% Test normalized cross-correlation between patterns and gray image
pCrossCorr = cell(0,9);
for i=1:9
    pattern = cell2mat(patterns(i));
    pCrossCorr(i) = {normxcorr2(pattern, grayImg)};
end

%% TODO
c = (c1+c2+c3+c4+c5+c6)/6;
c = c(12:end-12,12:end-12);
figure, surf(abs(c)), shading flat
figure, imagesc(abs(c)), colorbar
c=abs(c);

mask = c<0.2;
figure, imagesc(mask)
se = strel('disk',3);
mask2 = imopen(mask,se);
figure, imagesc(mask2);

A=A(5:end-6,5:end-6);
A1 = A;
A1(mask2)=255;
Af=cat(3,A1,A,A);
 figure;
imshowpair(A,Af,'montage')
