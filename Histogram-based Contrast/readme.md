# HC(Histogram-based Contrast) 基于直方图对比度的显著性

来源于: 2011, Global contrast based salient region detection, [ChengSaliencyCVPR2011.pdf (mmcheng.net)](https://mmcheng.net/mftp/SalObj/ChengSaliencyCVPR2011.pdf)

详见作者主页: [Global contrast based salient region detection – 程明明个人主页 (mmcheng.net)](https://mmcheng.net/salobj/)

## 显著性定义

图像中像素的显著性值可以它和图像中其它像素的对比度来定义, 具体公式为:
$$
S(I_k) = S(c_l) = \sum_{j=1}^{n}{f_iD(c_l, c_j)}
$$
其中, $c_l$ 为像素 $I_k$ 的颜色, n为图像中所有颜色的总数, $f_j$ 为 $c_j$ 在图像I中出现的概率, $D(c_l, c_j)$ 为颜色在Lab空间的距离.

使用上述公式就可以计算每个像素的显著性, 从而可以得到图像中目标的显著性. 

但上述公式存在一个问题: 对于RGB颜色空间, 8bit数据的颜色总数为 $255^3=16581375$, 这样会使得公式计算量大.

## 具体实现

### 优化加速

为了解决计算量大的问题, 作者对颜色进行了量化来减少计算量, 如将颜色量化到12个不同的值(在RGB颜色空间量化), 这样颜色总数为 $12^3=1728$. 同时丢弃部分频率较小的颜色, 用相近的颜色代替(在Lab颜色空间计算距离).

最后, 对量化后的图像直方图进行操作, 避免对整幅图像进行处理, 从而提高效率.

### 颜色空间平滑

量化后虽然提高了效率, 但会带来负面影响, 应为相似的颜色会被量化为不同值, 这样相似的颜色会得到不同的显著性值. 为解决这个问题, 作者使用了颜色空间平滑, 对计算出来的显著性值进行平滑: 每个颜色的显著性值被替换为相似颜色的显著性值的加权平均, 具体公式为:
$$
S^{'}(c)=\frac{1}{(m-1)T}\sum^{m}_{i=1}(T-D(c,c_i))S(c_i)
$$
其中, $T=\sum^{m}_{i=1}D(c,c_i)$ 为颜色 c 和它最相似的 m 个颜色的距离之和.

### 实现效果

处理过程及效果如下所示:

![HC_flowchat](readme.assets/HC_flowchat.png)

从上可以看到, 基本实现了文章中的效果, 但与文章给出的效果还是有些出入的.

## 关键参数



