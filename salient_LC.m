close all
clear
clc

imgname = 'test_images/women.jpg';
img = imread(imgname);

% rgb2gray
gray = rgb2gray(img);

% 统计直方图
[hist, ~] = histcounts(gray, 0:256);

% 计算每个颜色与其他颜色的距离和
color_sal = zeros(256, 1);
color_idx = 1:256;
for i = 1 : 256
    dist = abs(i - color_idx) .* hist; % L1?? L2如何
    color_sal(i) = sum(dist);
end

% 计算显著图
sal_map = zeros(size(gray));
for y = 1:size(gray, 1)
    for x = 1:size(gray,2)
        sal_map(y, x) = color_sal(gray(y,x) + 1);
    end
end
min_sal = min(sal_map(:));
max_sal = max(sal_map(:));
range_sal = max_sal - min_sal;
sal_map = (sal_map - min_sal) / range_sal;
% sal_map = sal_map / max_sal;
figure, imshow(sal_map, [])
