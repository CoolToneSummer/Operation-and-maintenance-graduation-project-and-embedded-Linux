% 读取雾霾图片对其(R,G,B)三个通道分别处理
I = imread('a.png');
% 将图像R通道
R = I(:, :, 1);
% 使用单独的参数返回各个维度长度
[N1, M1] = size(R);
R0 = double(R);
Rlog = log(R0+1);
% 使用快速傅里叶变换算法返回矩阵的二维傅里叶变换
Rfft2 = fft2(R0);
 
sigma = 250;
% 返回大小为 [N1,M1] 的旋转对称高斯低通滤波器，标准差为 sigma
F = fspecial('gaussian', [N1,M1], sigma);
Efft = fft2(double(F));
% 图转换到频域 滤波器转换到频域 相乘之后换回去
% 不然直接在图上做卷积很难做
DR0 = Rfft2.* Efft;
% 使用快速傅里叶变换算法返回矩阵的二维傅里叶逆变换
DR = ifft2(DR0);
 
DRlog = log(DR +1);
Rr = Rlog - DRlog;
EXPRr = exp(Rr);
MIN = min(min(EXPRr));
MAX = max(max(EXPRr));
% 归一化
EXPRr = (EXPRr - MIN)/(MAX - MIN);
% 限制对比度的自适应直方图均衡化 (CLAHE) 来变换值，从而增强图像的对比度
EXPRr = adapthisteq(EXPRr);
 
G = I(:, :, 2);
 
G0 = double(G);
Glog = log(G0+1);
Gfft2 = fft2(G0);
 
DG0 = Gfft2.* Efft;
DG = ifft2(DG0);
 
DGlog = log(DG +1);
Gg = Glog - DGlog;
EXPGg = exp(Gg);
MIN = min(min(EXPGg));
MAX = max(max(EXPGg));
EXPGg = (EXPGg - MIN)/(MAX - MIN);
EXPGg = adapthisteq(EXPGg);
 
B = I(:, :, 3);
 
B0 = double(B);
Blog = log(B0+1);
Bfft2 = fft2(B0);
 
DB0 = Bfft2.* Efft;
DB = ifft2(DB0);
 
DBlog = log(DB+1);
Bb = Blog - DBlog;
EXPBb = exp(Bb);
MIN = min(min(EXPBb));
MAX = max(max(EXPBb));
EXPBb = (EXPBb - MIN)/(MAX - MIN);
EXPBb = adapthisteq(EXPBb);
 
result = cat(3, EXPRr, EXPGg, EXPBb);
subplot(121), imshow(I);
subplot(122), imshow(result);