close all
clear
clc

imgname = 'test_images/leaf1.jpg';
img = imread(imgname);

% gaussian filter
img = imfilter(img, fspecial('gaussian', 3, 3), 'symmetric', 'conv');

% mean
r = double(img(:,:,1)); mr = mean2(r);
g = double(img(:,:,2)); mg = mean2(g);
b = double(img(:,:,3)); mb = mean2(b);

% Finally compute the saliency map and display it.
sm_distance = (r-mr).^2 + (g-mg).^2 + (b-mb).^2;
sm=im2uint8(mat2gray(sm_distance));
imshow(sm,[]);