close all; clear; clc;

%

imgname = '../test_images/818.jpg';
img = imread(imgname);

salient = AC(img);
salient3 = cat(3, salient, salient, salient);
im_cmp = cat(2, img, uint8(salient3*255));
imshow(im_cmp)


