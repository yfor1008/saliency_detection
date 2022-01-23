# AC(Area Contrast) 区域对比度显著性

文章: [Salient Region Detection and Segmentation](http://link.springer.com/10.1007/978-3-540-79547-6_7)

文章主页: [salient-region-detection-and-segmentation](https://www.epfl.ch/labs/ivrl/research/saliency/salient-region-detection-and-segmentation/)

文章中的方法被称为 `AC` 算法, 目前没有查找 `AC` 对应的全称是什么, 这里根据自己的理解, 称之为区域对比度, `Area Contrast(AC)`.

## 显著性定义

像素 $I_k$ 的显著性为像素 $I_k$ 与该像素不同尺度的邻域像素距离和的加权, 用公式表示为:

$$
sal_{s}(I_{k})=\sum{\|I_{k}-I_{i}^{s}\|} \\
sal(I_{k})=\sum sal_{s}(I_{k})
$$
式中, $\|*\|$ 表示欧式距离, $I_{i}^{s}$ 表示尺度为 `s` 时像素 $I_k$ 邻域像素的特征向量均值.

## 具体实现

根据定义, 算法流程可以归纳为:

1. 将rgb图像转换到Lab颜色空间;
2. 使用不同尺度(不同大小滤波器)对于Lab进行均值滤波;
3. 计算不同尺度下像素的显著性;
4. 加权得到最终的显著性;

## 算法优缺点

1. 在颜色空间处理, 对颜色图像效果较好;
2. 计算不同尺度, 算法速度较慢;
