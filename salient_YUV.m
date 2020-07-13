close all
clear
clc

imgname = 'test_images/leaf1.jpg';
img = imread(imgname);

% gaussian filter
img = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

% rgb2hsv
yuv = rgb2ycbcr(img);

% Compute Lab average values
y = double(yuv(:,:,1)); ym = mean(mean(y));
u = double(yuv(:,:,2)); um = mean(mean(u));
v = double(yuv(:,:,3)); vm = mean(mean(v));

% Finally compute the saliency map and display it.
sm_distance = (y-ym).^2 + (u-um).^2 + (v-vm).^2;
um=im2uint8(mat2gray(sm_distance));
imshow(um,[]);