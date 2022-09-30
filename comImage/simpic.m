%————————————————————————
% 读取图片数据（相当于一个矩阵）
% 转换成灰度图片（256级）
% 缩放到64×64尺寸（剔除图片细节）
% 计算二维离散余弦变换（变换后还是64×64矩阵）
% 截取矩阵左上角16×16部分（因为图主要成分都在左上角）
% 计算该16×16矩阵的均值
% 遍历矩阵，大于等于均值的元素赋值为1，否则赋值为0，生成一个8×8的hash指纹图，hash指纹图就代表一串64位二进制的hash值
% 比较两张图的hash值，计算汉明距离，得到相似度（汉明距离=0代表完全相似，距离越大越不相似）
%——————————————————————————————
clc;clear;
close all;
img1=imread('5.jpg');
img2=imread('6.jpg');

% 读取图片数据（相当于一个矩阵）
%figure('NumberTitle','off','Name','原始图像');
% subplot(1,2,1);imshow(img1);
% subplot(1,2,2);imshow(img2);


% 转换成灰度图片（256级）
figure('NumberTitle','off','Name','256级灰度图像');
img11=rgb2gray(img1);
img21=rgb2gray(img2);


subplot(1,2,1);imshow(img11);
subplot(1,2,2);imshow(img21);




% 缩放到32×32尺寸（剔除图片细节）
figure('NumberTitle','off','Name','缩放64*64图像');
img12=imresize(img11,[64,64]);
img22=imresize(img21,[64,64]);
%裁剪
mean111=sum(img12(:))/64/64;  %计算均值
mean112=sum(img22(:))/64/64;
ratio_x1 = 1/4;
ratio_x2 = 2/3;
ratio_y1 = 1/4;
ratio_y2 = 3/4;
%抠图
for i=1:64
    for j=1:64
        if (i<64*ratio_x1)
            img12(i,j)=mean111;
            img22(i,j)=mean112;
        elseif (i<64*ratio_x2&&j<64*ratio_y1)||(i<64*ratio_x2&&j>64*ratio_y2)
            img12(i,j)=mean111;
            img22(i,j)=mean112;
        end
    end
end
subplot(1,2,1);imshow(img12);
subplot(1,2,2);imshow(img22);

% 计算二维离散余弦变换（变换后还是32×32矩阵）
imgdct1=dct2(img12);    %计算二维dct
imgdct2=dct2(img22);
% 截取矩阵左上角8×8部分（因为图主要成分都在左上角）
imgdct11=imgdct1(1:16,1:16);  %截取左上角16*16
imgdct21=imgdct2(1:16,1:16);
% 计算该8×8矩阵的均值
mean1=sum(imgdct11(:))/256;  %计算均值
mean2=sum(imgdct21(:))/256;
imghash1=zeros(16,16);
imghash2=zeros(16,16);
% 遍历矩阵，大于等于均值的元素赋值为1，否则赋值为0，生成一个8×8的hash指纹图
for i=1:16   %遍历生成hash指纹
    for j=1:16
        if(imgdct11(i,j)>=mean1)
            imghash1(i,j)=1;end
        if(imgdct21(i,j)>=mean2)
            imghash2(i,j)=1;end
    end
end
cyjz=xor(imghash1,imghash2);    %求异或
% 比较两张图的hash值，计算汉明距离，得到相似度（汉明距离=0代表完全相似，距离越大越不相似）
hanming=sum(cyjz(:));   %求汉明距离
similarity=(256-hanming)/256;
figure('NumberTitle','off','Name','phash指纹图');
subplot(1,2,1);imshow(imghash1);
subplot(1,2,2);imshow(imghash2);
title(['与前者相似度为',num2str(100*similarity),'%']);