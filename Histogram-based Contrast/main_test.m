close all; clear; clc;

%%

imgname = '../test_images/people_sky.jpg';
img = imread(imgname);

salient = HC(img, 12, 0.95, 0.4, 1);
