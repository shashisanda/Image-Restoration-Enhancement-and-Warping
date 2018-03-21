%% clearing and closing
clc;
clear all;
close all;

%% Loading an Image
load('Image14'); %loading the given image i.e, Image12
Image1= mat2gray(IMAGE); %converting the image to grayscale
figure(1)
imshow(Image1) %displaying the image
title('Input image')

%% Removal of noise from image
[Image2]=medfilt2(Image1); % Passing Image1 through a median filter
figure(2)
imshow(mat2gray(Image2));
title('Removal of noise from image')

%% Deblurring the image
N=21;
h1=fir1(N-1,0.7,'low',hamming(N));  %transformation method                                       
H=ftrans2(h1); %2d FIR filter using frequency transformation                                                           
figure
freqz2(H); %2-D frequency response
Image3=mat2gray(deconvblind(Image2,H)); %Deblurring image using blind deconvolution
figure;
imshow((Image3))
title('Deblurring image')

%% Unwarping the image
for i=1:380
for j=1:380
        x=j-190.5;
        y=190.5-i;
        %Converting Polar Coordinates (r,?) to Cartesian Coordinates (x,y)
        rij=sqrt((x)^2+(y)^2); %pythagoras theorem
        teta=atan2(y,x); %Four quadrant inverse tangent
        r=abs((R0.*asin(rij/R0))); %given condition
        x1=(r.*cos(teta)); %r= x1/cos(teta)
        y1=(r.*sin(teta)); %r= y1/sin(teta)
        j1 =round(x1+283);
        i1 =round(283-y1);
        Image4(i1+64,j1+64)= Image3(i,j);
    end
end
figure
imshow(Image4);
Image5 = Image4;
Image5 = medfilt2(Image5); % Passing Image1 through a median filter
%Image5 = mat2gray(Image5);
Image6=mat2gray(medfilt2(Image5));
figure
imshow(Image6);
title('Output Image')

%% resizing the image to 480x480 
Image7 = mat2gray(imresize(Image6,[380 380]));
figure;
Image7 = medfilt2(Image7);
imshow(Image7)
title('Resized Image');