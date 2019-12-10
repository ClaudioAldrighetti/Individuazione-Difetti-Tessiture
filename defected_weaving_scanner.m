%% Individuazione di un difetto su un'immagine di tessitura
clear all;
close all;
clc;

% Image
img = imread('defect24.jpg');
[row, col, X] = size(img);
hR = round(row/2);
hC = round(col/2);
if(X == 3)
    cImg = rgb2gray(img);
else
    cImg = img;
end

% Patterns
pSize = 10;
hP = round(pSize/2);
patterns = {
    cImg(1:1+pSize, 1:1+pSize)
    cImg(1:1+pSize, hC-hP:hC+hP)
    cImg(1:1+pSize, col-pSize:col)
    cImg(hR-hP:hR+hP, 1:1+pSize)
    cImg(hR-hP:hR+hP, col-pSize:col)
    cImg(row-pSize:row, 1:1+pSize)
    cImg(row-pSize:row, hC-hP:hC+hP)
    cImg(row-pSize:row, col-pSize:col)
};

% Image and patterns plot
%figure;
%imagesc(cImg); axis image; colormap gray; hold on;
%rectangle('position',[1,1,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[hC-hP,1,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[col-pSize,1,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[1,hR-hP,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[col-pSize,hR-hP,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[1,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[hC-hP,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
%rectangle('position',[col-pSize,row-pSize,pSize,pSize],'EdgeColor',[1 0 0]);
%title('Patterns position');

% Test normalized cross-correlation between patterns and gray image
pCrossCorr = cell(1,8);
for i=1:8
    tmpCC = normxcorr2(cell2mat(patterns(i)), cImg);
    tmpCC = tmpCC(pSize-1:end-(pSize-1),pSize-1:end-(pSize-1));
    pCrossCorr(i) = {tmpCC};
end

% Max mean CC value
mCC = 0;
maxCC = mean(mean(abs(cell2mat(pCrossCorr(1)))));
maxIndex = 1;
for i=2:8
    mCC = mean(mean(abs(cell2mat(pCrossCorr(i)))));
    if(mCC > maxCC)
        maxCC = mCC;
        maxIndex = i;
    end
end
maxPCC = cell2mat(pCrossCorr(maxIndex));

% Plot normalized C
%figure, surf(abs(maxPCrossCorr)), shading flat;
figure, imagesc(abs(maxPCC),[0 1]), colorbar;

% Mask
dfct = abs(maxPCC)<0.2;
se = strel('disk',2);
mask = imopen(dfct,se);
maskImg = cImg;
maskImg(mask)=255;
defImg=cat(3,maskImg,cImg,cImg);
figure;
imshowpair(cImg,defImg,'montage');
