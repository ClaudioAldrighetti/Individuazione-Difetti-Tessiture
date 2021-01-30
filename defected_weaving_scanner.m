%% Individuazione di un difetto su un'immagine di tessitura
clear all;
close all;
clc;

% Macros
CCMIN = 0.2;
MIN_PSIZE = 12;
N_PATS = 4;
TRASL_PAT = 1;

% Image
img = imread('defect27.jpg');
[row, col, X] = size(img);
hR = round(row/2);
hC = round(col/2);
if(X == 3)
    cImg = rgb2gray(img);
else
    cImg = img;
end

% Patterns
pSize = MIN_PSIZE;
hP = round(pSize/2);
tP = TRASL_PAT;
patterns = {
    cImg(1:1+pSize, 1:1+pSize)
    cImg(1+tP:1+pSize+tP, 1+tP:1+pSize+tP)
%    cImg(1:1+pSize, hC-hP:hC+hP)
%    cImg(1+tP:1+pSize+tP, hC-hP:hC+hP)
    cImg(1:1+pSize, col-pSize:col)
    cImg(1+tP:1+pSize+tP, col-pSize-tP:col-tP)
%    cImg(hR-hP:hR+hP, 1:1+pSize)
%    cImg(hR-hP:hR+hP, 1+tP:1+pSize+tP)
%    cImg(hR-hP:hR+hP, col-pSize:col)
%    cImg(hR-hP:hR+hP, col-pSize-tP:col-tP)
%    cImg(row-pSize:row, 1:1+pSize)
%    cImg(row-pSize-tP:row-tP, 1+tP:1+pSize+tP)
%    cImg(row-pSize:row, hC-hP:hC+hP)
%    cImg(row-pSize-tP:row-tP, hC-hP:hC+hP)
%    cImg(row-pSize:row, col-pSize:col)
%    cImg(row-pSize-tP:row-tP, col-pSize-tP:col-tP)
};

% Test normalized cross-correlation between patterns and gray image
pCrossCorr = cell(1,N_PATS);
for i=1:N_PATS
    tmpCC = normxcorr2(cell2mat(patterns(i)), cImg);
    tmpCC = tmpCC(pSize-1:end-(pSize-1),pSize-1:end-(pSize-1));
    pCrossCorr(i) = {tmpCC};
end

% Max mean CC value
%mCC = 0;
%maxCC = mean(mean(abs(cell2mat(pCrossCorr(1)))));
%maxIndex = 1;
%for i=2:8
%    mCC = mean(mean(abs(cell2mat(pCrossCorr(i)))));
%    if(mCC > maxCC)
%        maxCC = mCC;
%        maxIndex = i;
%    end
%end
%maxPCC = cell2mat(pCrossCorr(maxIndex));

% CC mean of patterns CC
crossCorr = 0;
validP = 0;
for i=1:N_PATS
    % Check if pattern has a defect inside
    meanCC = mean(mean(abs(cell2mat(pCrossCorr(i)))));
    if(meanCC > CCMIN)
        % Valid pattern
        crossCorr = crossCorr + cell2mat(pCrossCorr(i));
        validP = validP + 1;
    end
end
crossCorr = crossCorr/validP;

% Plot normalized C
figure, imagesc(abs(crossCorr)), colorbar;

% Mask
mask = crossCorr<0.2;
figure, imagesc(mask);
se = strel('disk',3);
mask2 = imopen(mask,se);
figure, imagesc(mask2);

cImg=cImg(5:end-5,5:end-5);
cMaskImg = cImg;
cMaskImg(mask2)=255;
defImg=cat(3,cMaskImg,cImg,cImg);
figure;
imshowpair(cImg,defImg,'montage')
