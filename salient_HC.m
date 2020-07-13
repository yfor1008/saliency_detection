close all
clear
clc

imgname = 'test_images/board.jpg';
img = imread(imgname);

% 转换到[0, 1]
im = double(img) / 255;

% 量化, 每个颜色通道量化后的值, 在rgb空间
quan = 12;
w = [quan*quan, quan, 1];
r = fix(im(:,:, 1) * quan);
g = fix(im(:,:, 2) * quan);
b = fix(im(:,:, 3) * quan);
pallet = r * w(1) + g * w(2) + b * w(3) + 1;

% 统计直方图
ratio = 0.95;
chist = histcounts(pallet,'BinMethod','integers');
color_num = length(chist);
[shist, s_idx] = sort(chist, 'descend'); % 排序, 降序
[~, c_idx] = sort(s_idx); % 对应排序前的位置
colors_r = fix(s_idx' / w(1));
colors_g = fix(mod(s_idx', w(1)) / w(2));
colors_b = mod(s_idx', w(2));
colors = [colors_r, colors_g, colors_b];
drop_num = round(numel(pallet) * (1-ratio));
crnt = 0;
for max_num = color_num:-1:1
    crnt = crnt + shist(max_num);
    if crnt > drop_num
        break;
    end
end
max_num = min(256, max_num); % 最多保留256个色阶


% % 显示保留颜色
% figure, 
% bfig = bar(shist(1:max_num));
% for i = 1 : max_num
%     color = colors(i, :)/12;
%     bfig.FaceColor = 'flat';
%     bfig.CData(i, :) = color;
% end
% % axis off


% 保留前ratio的颜色, 其他颜色用最相近的颜色替代
tnt_max = 2^16;
color_idx = 1 : color_num; % 重新对颜色进行标号, 方便计算
for i = max_num + 1 : color_num
    color_i = colors(i, :);
    color_j = colors(1:max_num, :);
    d_ij = abs(color_i - color_j) .^ 2;
    d_ij = sum(d_ij, 2);
    sim_idx = find(d_ij == min(d_ij));
    color_idx(i) = sim_idx(1); % 第一个or最后一个???
    test = 0;
end

% 计算量化后颜色相同像素的均值
color_sum = zeros(max_num, 1, 3);
color_cnt = zeros(max_num, 1);
for y = 1 : size(im, 1)
    for x = 1 : size(im, 2)
        quan_color = pallet(y, x); % 每个像素对应的量化后的颜色
        idx = c_idx(quan_color); % 对应排序后index
        idx = color_idx(idx); % 对应调整后的index
        % color_sum(idx, :) = color_sum(idx, :) + squeeze(im(y, x, :))';
        color_sum(idx, 1, :) = color_sum(idx, 1, :) + im(y, x, :);
        color_cnt(idx) = color_cnt(idx) + 1;
    end
end
color_sum = color_sum ./ color_cnt;

% rgb2lab
Lab = squeeze(rgb2lab(color_sum));
% L = Lab(:,:,1);
% A = Lab(:,:,2);
% B = Lab(:,:,3);

% 计算颜色显著性
weight = color_cnt / sum(color_cnt);
color_sal = zeros(max_num, 1);
for i = 1 : max_num
    color_i = Lab(i, :);
    d_i = sum((color_i - Lab) .^ 2, 2);
    color_sal(i) = sum(weight .* d_i);
    test = 0;
end




