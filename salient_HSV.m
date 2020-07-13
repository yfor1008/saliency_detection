close all
clear
clc

imgname = 'test_images/003.jpg';
img = imread(imgname);

% gaussian filter
img = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

% rgb2hsv
hsv = rgb2hsv(img);

% Compute Lab average values
h = double(hsv(:,:,1)); hm = mean(mean(h));
s = double(hsv(:,:,2)); sm = mean(mean(s));
v = double(hsv(:,:,3)); vm = mean(mean(v));

% Finally compute the saliency map and display it.
sm_distance = (h-hm).^2 + (s-sm).^2 + (v-vm).^2;
sm=im2uint8(mat2gray(sm_distance));
imshow(sm,[]);