%% Loading an Image
clc;
clear all;
close all;
%%
load('Image2');
Image1= mat2gray(IMAGE);
figure
imshow(Image1)
title('Input image')
%% Removal of noise
[Image2,noise]=wiener2(Image1,[3 3]);
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
%% Unwarping image
%unwrapedimage =zeros(480,480);
for i=1:380;
    for j=1:380;
        x=j-190.5;
        y=190.5-i;
        rij=sqrt((x)^2+(y)^2);
        teta=atan2(y,x);
        %rij=y/sin(teta);
        r=abs((R0.*asin(rij/R0)));
        xnorm=(r.*cos(teta));
        ynorm=(r.*sin(teta));
        iu =round(283-ynorm);
        ju =round(xnorm+283);
        Image4(iu+64,ju+64)= Image3(i,j);
    end
end
figure
imshow(Image4);
% Image5 = mat2gray(medfilt2(Image4));
Image5 = Image4;
for i=2:length(Image4)-1
    for j=2:length(Image4)-1
        if Image4(i,j)==0
            Image5(i,j)=(Image5(i+1,j)+Image4(i-1,j)+Image4(i,j-1)+Image4(i,j+1)+Image4(i+1,j+1)+Image4(i-1,j-1))/6;
        end
    end
end
Image5 = mat2gray(Image5);
Image6=mat2gray(medfilt2(Image5));
figure
imshow(Image6);
title('Output Image')
Image7 = mat2gray(imresize(Image6,[480 480]));
%     figure,imshow(mat2gray(Image6));
figure;
imshow(Image7)
title('Resized Image');