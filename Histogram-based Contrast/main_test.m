close all; clear; clc;

% %% 单张测试

% imgname = '../test_images/818.jpg';
% img = imread(imgname);

% [salient, rgb_quan, color_sal_1, color_sum_1] = HC(img, 12, 0.95, 0.4, 1);


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
%     [salient, rgb_quan, color_sal_1, color_sum_1] = HC(img, 12, 0.95, 0.4, 0);
%     salients{i} = salient;
%     im_salient = cat(3, salient,salient,salient);
%     im = im2double(img);
%     imshow(cat(2, im, im_salient))
%     test = 0;
% end


%% quan参数测试
imgname = '../test_images/818.jpg';
img = imread(imgname);
im = im2double(img);

quan = [4, 8, 12, 16, 20, 24, 28, 32, 64, 128];
num = length(quan);
fig = figure('NumberTitle', 'off', 'Name', 'generate gif', 'Position', [0, 0, 640, 560]);
for frm = 1:num
    q = quan(frm);
    [salient, rgb_quan, color_sal_1, color_sum_1] = HC(img, q, 0.95, 0.4, 0);
    % salient3 = cat(3, salient, salient, salient);
    % im_cmp = cat(2, im, rgb_quan, salient3);
    subplot(2,3,1)
    imshow(img)
    subplot(2,3,2)
    imshow(rgb_quan)
    subplot(2,3,3)
    imshow(salient)
    subplot(2,3,[4,5,6])
    bfig2 = bar(color_sal_1);
    for i = 1 : length(color_sal_1)
        color = color_sum_1(i);
        bfig2.FaceColor = 'flat';
        bfig2.CData(i, :) = color;
    end
    axis off
    suptitle(['量化参数为 ', num2str(q)]);
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
    [A, map] = rgb2ind(frame2im(getframe(gcf)),256);
    if frm == 1
        imwrite(A, map, './src/different_quan.gif', 'gif', 'Loopcount',inf, 'DelayTime',0.5);
    else
        imwrite(A, map, './src/different_quan.gif', 'gif', 'WriteMode','append', 'DelayTime',0.5);
    end
end

