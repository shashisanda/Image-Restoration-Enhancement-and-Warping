clc
clear all
close all
load image14.mat
x=mat2gray(IMAGE);
figure
imshow(x)
figure
imhist(x)
%% noise removing
j=fspecial('gaussian');
h1=filter2(j,x);
figure
imshow(h1)
title('image after removing gaussian noise')
%% filter design
% N=11; 
% h2=fir1(N-1,0.8,hamming(N)); 
% h3=ftrans2(h2);
% figure
% h4=filter2(h3,x);
% imshow(h4)
% title('using transformation')
%% filter design and removing noise
[f1,f2]=freqspace(64);
[z,y]=meshgrid(f1,f2);
Hd=zeros(size(z));
r=sqrt(z.^2 + y.^2);
d=find(r<0.8);
Hd(d)=ones(size(d));
h2=fwind1(Hd,hamming(11));
h3=filter2(h2,x);
figure
imshow(h3)
title('after removing noise')
%% deblurring
PSF=fspecial('gaussian');
J1=deconvwnr(h3,PSF,0.0009);
figure;
imshow(J1);
title('Deblurring');
%% dewarping
[m,n] = size(IMAGE);
c=((m+1)/2);
d=((n+1)/2);
[X,Y] = meshgrid(-c:1:c,-d:1:d);
[theta,rho] = cart2pol(X,Y);
rho1=(R0*sin(rho/R0));
[X1,Y1]=pol2cart(theta,rho1);
D(:,:,1)=X1-X;
D(:,:,2)=Y1-Y;
B=imwarp(J1,D);
imshow(B)
