function [salient] = AC(rgb)
% AC - Area constrast
%
% input:
%   - rgb: H*W*3, rgb 图像
% output:
%   - salient: H*W, [0,1], 显著性图像, 灰度图像
%
% doc:
%   - Salient Region Detection and Segmentation, 2008
%   - 论文主页: https://www.epfl.ch/labs/ivrl/research/saliency/salient-region-detection-and-segmentation/
%

% 最大窗口
[height, width, ~] = size(rgb);
md = min(height, width); % minimum dimension

% 转 lab
lab = rgb2lab(rgb); % default D65
l = double(lab(:,:,1));
a = double(lab(:,:,2));
b = double(lab(:,:,3));

% 计算显著性
salient = zeros(height, width);
scales = [md/2, md/4, md/8];
scales = fix(scales);

for s = scales
    l_bf = imfilter(l, fspecial('average', s), 'symmetric', 'conv');
    a_bf = imfilter(a, fspecial('average', s), 'symmetric', 'conv');
    b_bf = imfilter(b, fspecial('average', s), 'symmetric', 'conv');
    
    cv = (l - l_bf) .^2 + (a - a_bf) .^2 + (b - b_bf) .^2;
    salient = salient + cv;
end

salient = salient / max(salient(:));

end