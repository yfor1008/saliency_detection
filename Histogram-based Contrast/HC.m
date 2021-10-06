function salient = HC(rgb, quan, ratio, delta, show)
% HC - Histogram-based Contrast
%
% input:
%   - rgb: H*W*3, rgb 图像
%   - quan: int, 每个颜色通道量化值
%   - ratio: float, 保留颜色的比例, [0, 1], 越大保留颜色越多
%   - delta: float, 平滑窗口大小比例, [0, 1], 越大滤波窗口越大
%   - show: bool, 是否显示中间处理过程
% output:
%   - salient: H*W, [0,1], 显著性图像, 灰度图像
%
% doc:
%   - Global contrast based salient region detection, 2011
%

channel = size(rgb);
if channel == 1
    rgb = cat(3, rgb, rgb, rgb);
end

% 转到 [0,1], 方便计算
im = double(rgb) / 255;

% 量化, 在rgb空间
w = [quan*quan, quan, 1];
r = round(im(:,:, 1) * (quan-1));
g = round(im(:,:, 2) * (quan-1));
b = round(im(:,:, 3) * (quan-1));
pallet = r * w(1) + g * w(2) + b * w(3);

% 统计直方图
color_num = quan * quan * quan + quan * quan + quan + 1;
chist = zeros(color_num, 1);
for i = 1 : length(pallet(:))
    chist(pallet(i)+1) = chist(pallet(i)+1) + 1;
end

% 排序, 降序
[shist, s_idx] = sort(chist, 'descend');
[~, c_idx] = sort(s_idx); % 对应排序前的位置

% 按比例丢弃颜色
real_color_num = length(find(shist>0)); % 图像中实际出现的颜色个数
drop_num = round(numel(pallet) * (1-ratio));
crnt = 0;
for max_num = real_color_num:-1:1
    crnt = crnt + shist(max_num);
    if crnt > drop_num
        break;
    end
end
max_num = min(256, max_num); % 最多保留256个色阶

% index 对应的颜色
colors_r = fix((s_idx-1) / w(1));
colors_g = fix(mod(s_idx-1, w(1)) / w(2));
colors_b = mod(s_idx-1, w(2));
colors = [colors_r, colors_g, colors_b];

% 显示保留颜色
if show
    figure('NumberTitle', 'off', 'Name', '量化后保留颜色');
    bfig = bar(shist(1:max_num));
    for i = 1 : max_num
        color = colors(i, :)/(quan-1);
        bfig.FaceColor = 'flat';
        bfig.CData(i, :) = color;
    end
    axis off
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
end

% 丢弃很少出现的颜色, 使用相似颜色替代
color_idx = 1 : color_num; % 重新对颜色进行标号, 方便计算
for i = max_num + 1 : color_num
    color_i = colors(i, :);
    color_j = colors(1:max_num, :);
    similar = abs(color_i - color_j) .^ 2;
    similar = sum(similar, 2);
    sim_idx = find(similar == min(similar));
    color_idx(i) = sim_idx(1); % 第一个or最后一个???
end

% 计算量化后颜色相同像素的均值
color_sum = zeros(max_num, 1, 3);
color_cnt = zeros(max_num, 1);
for y = 1 : size(im, 1)
    for x = 1 : size(im, 2)
        quan_color = pallet(y, x) + 1; % 每个像素对应的量化后的颜色
        idx = c_idx(quan_color); % 对应排序后index
        idx = color_idx(idx); % 颜色重新标号后的index
        color_sum(idx, 1, :) = color_sum(idx, 1, :) + im(y, x, :);
        color_cnt(idx) = color_cnt(idx) + 1;
    end
end
color_sum = color_sum ./ color_cnt;

% 显示平均颜色
if show
    figure('NumberTitle', 'off', 'Name', '保留颜色均值');
    bfig1 = bar(color_cnt);
    for i = 1 : max_num
        color = color_sum(i, :);
        bfig1.FaceColor = 'flat';
        bfig1.CData(i, :) = color;
    end
    axis off
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
end

% rgb2lab
Lab = squeeze(rgb2lab(color_sum));

% 计算颜色显著性
weight = color_cnt / sum(color_cnt);
color_sal = zeros(max_num, 1);
similar = zeros(max_num, max_num);
idx_ij = zeros(max_num, max_num);
for i = 1 : max_num
    color_i = Lab(i, :);
    d_i = sum((color_i - Lab) .^ 2, 2);
    color_sal(i) = sum(weight .* d_i);
    [d_i, i_i] = sort(d_i, 'ascend'); % why? 作者代码中有进行排序, 接近的颜色???
    similar(i, :) = d_i;
    idx_ij(i, :) = i_i;
end

% 显示颜色显著性
if show
    [color_sal_1, sc_idx] = sort(color_sal, 'descend');
    figure('NumberTitle', 'off', 'Name', '颜色显著性');
    bfig2 = bar(color_sal_1);
    for i = 1 : max_num
        color = color_sum(sc_idx(i), :);
        bfig2.FaceColor = 'flat';
        bfig2.CData(i, :) = color;
    end
    axis off
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
end

% 颜色显著性平滑
n = max(round(max_num*delta) ,2); % 最少2个进行平滑
pw = ones(max_num, 1);
new_sal = zeros(max_num, 1);
for i = 1 : max_num
    total_dist = 0;
    total_weight = 0;
    dist = zeros(n, 1);
    val = zeros(n, 1);
    ww = zeros(n, 1);
    for j = 2 : n+1 % 第1为本身
        ith_idx = idx_ij(i, j);
        dist(j) = similar(i, j);
        val(j) = color_sal(ith_idx);
        ww(j) = pw(ith_idx);
        total_dist = total_dist + dist(j);
        total_weight = total_weight + ww(j);
    end
    val_crnt = sum(val .* (total_dist - dist) .* ww);
    new_sal(i)  = val_crnt / (total_dist * total_weight);
end
new_sal = new_sal / max(new_sal); % 对结果有一定的影响

% 显示平滑后颜色显著性
if show
    [new_sal_1, sc_idx] = sort(new_sal, 'descend');
    figure('NumberTitle', 'off', 'Name', '平滑后颜色显著性');
    bfig3 = bar(new_sal_1);
    for i = 1 : max_num
        color = color_sum(sc_idx(i), :);
        bfig3.FaceColor = 'flat';
        bfig3.CData(i, :) = color;
    end
    axis off
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
end

% 生成显著性图像
salient = zeros(size(pallet));
for y = 1 : size(im, 1)
    for x = 1 : size(im, 2)
        quan_color = pallet(y, x); % 每个像素对应的量化后的颜色
        idx = c_idx(quan_color); % 对应排序后index
        idx = color_idx(idx); % 颜色重新标号后的index
        salient(y, x) = new_sal(idx);
    end
end

if show
    figure('NumberTitle', 'off', 'Name', '显著性图像');
    imshow(salient, [])
    set(gcf, 'color', 'white');
    set(gca, 'color', 'white');
    set(gca, 'FontName', 'Helvetica');
    set(gca, 'FontSize', 13);
    set(gca, 'linewidth', 1.3);
end

end