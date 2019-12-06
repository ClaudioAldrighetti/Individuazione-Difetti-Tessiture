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

figure;
subplot(1,2,1);
imagesc(img); axis image; hold on;
title('Image in RGB');
subplot(1,2,2);
imagesc(grayImg); axis image; colormap gray; hold on;
title('Gray Image');

% Patterns
pSize = 14;
hP = round(pSize/2);
patterns = [
    grayImg(1:pSize, 1:pSize)       grayImg(1:pSize, hC-hP:hC+hP)       grayImg(1:pSize, col-pSize:col)
    grayImg(hR-hP:hR+hP, 1:pSize)   grayImg(hR-hP:hR+hP, hC-hP:hC+hP)   grayImg(hR-hP:hR+hP, col-pSize:col)
    grayImg(row-pSize:row, 1:pSize) grayImg(row-pSize:row, hC-hP:hC+hP) grayImg(row-pSize:row, col-pSize:col)
];

%%
%rectangle('position',[1,1,14,14],'EdgeColor',[1 0 0]);
%rectangle('position',[2,2,15,15],'EdgeColor',[1 0 0]);
%rectangle('position',[R-13,C-13,14,14],'EdgeColor',[1 0 0]);
%rectangle('position',[R-14,C-14,14,14],'EdgeColor',[1 0 0]);
%rectangle('position',[1,C-13,14,14],'EdgeColor',[1 0 0]);
%rectangle('position',[2,C-13,14,14],'EdgeColor',[1 0 0]);

c1 = normxcorr2(pattern1,A);
c2 = normxcorr2(pattern2,A);
c3 = normxcorr2(pattern3,A);
c4 = normxcorr2(pattern4,A);
c5 = normxcorr2(pattern5,A);
c6 = normxcorr2(pattern6,A);

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
