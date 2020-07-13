close all
clear
clc

imgname = 'test_images/board.jpg';
img = imread(imgname);
dim = size(img);
width = dim(2);height = dim(1);
md = min(width, height);%minimum dimension

% rgb2lab
lab = rgb2lab(img); % default D65
l = double(lab(:,:,1));
a = double(lab(:,:,2));
b = double(lab(:,:,3));

% Saliency map computation
sm = zeros(height, width);
scale = 3; % 尺度个数
minR2 = md / 8;
maxR2 = md / 2;
for s = 1 : scale
    win_size = double(int32((maxR2 - minR2) * (s-1) / (scale - 1) + minR2)); % 在md/8到md/2中等分
    l_bf = imfilter(l, fspecial('average', win_size), 'symmetric', 'conv');
    a_bf = imfilter(a, fspecial('average', win_size), 'symmetric', 'conv');
    b_bf = imfilter(b, fspecial('average', win_size), 'symmetric', 'conv');
    
    cv = (l - l_bf) .^2 + (a - a_bf) .^2 + (b - b_bf) .^2;
    sm = sm + cv;
end

imshow(sm,[]);
%---------------------------------------------------------