close all
clear
clc

imgname = 'test_images/leaf1.jpg';
img = imread(imgname);

% gaussian filter
img = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

% rgb2lab
lab = rgb2lab(img); % default D65

% Compute Lab average values
l = double(lab(:,:,1)); lm = mean(mean(l));
a = double(lab(:,:,2)); am = mean(mean(a));
b = double(lab(:,:,3)); bm = mean(mean(b));

% Finally compute the saliency map and display it.
sm_distance = (l-lm).^2 + (a-am).^2 + (b-bm).^2;
sm=im2uint8(mat2gray(sm_distance));
imshow(sm,[]);