%% Loading an Image
clc;
clear all;
close all;
%%
load('Image14');
Image1= mat2gray(IMAGE);
figure
imshow(Image1)
title('Input image')
%% Removal of noise
[Image2]=medfilt2(Image1);
figure,imshow(mat2gray(Image2));
title('Removal of noise from image')
%% Deblurring
N=21;
h1=fir1(N-1,0.7,'low',hamming(N));                                         
H=ftrans2(h1);                                                           
figure
freqz2(H);
Image3=mat2gray(deconvblind(Image2,H));
figure
imshow((Image3))
title('Deblurring image')
%%
[m,n] = size(IMAGE);
c=((m+1)/2);
d=((n+1)/2);
[X,Y] = meshgrid(-c:1:c,-d:1:d);
[theta,rho] = cart2pol(X,Y);
rho1=(R0*sin(rho/R0));
[X1,Y1]=pol2cart(theta,rho1);
D(:,:,1)=X1-X;
D(:,:,2)=Y1-Y;
B=imwarp(Image3,D);
figure;
imshow(B)
