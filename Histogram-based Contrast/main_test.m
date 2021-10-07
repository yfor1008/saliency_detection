close all; clear; clc;

%% 单张测试

imgname = '../test_images/818.jpg';
img = imread(imgname);

salient = HC(img, 12, 0.95, 0.4, 1);


% %% 多张测试
% 
% img_path = '../test_images/';
% imgs = dir([img_path, '*.jpg']);
% img_num = length(imgs);
% 
% salients = cell(img_num, 1);
% 
% for i = 1:img_num
%     img = imread([img_path, imgs(i).name]);
%     salient = HC(img, 12, 0.95, 0.4, 0);
%     salients{i} = salient;
%     im_salient = cat(3, salient,salient,salient);
%     im = im2double(img);
%     imshow(cat(2, im, im_salient))
%     test = 0;
% end

