clc;
clear all;
close all;

%% Loading an Image`
load('Image14'); %loading the given image i.e, Image14
Image1= mat2gray(IMAGE); %converting the image to grayscale
figure(1)
imshow(Image1) %displaying the image
title('Input image')
% figure;J = imnoise(Image1,'gaussian',0,0.025);
% imshow(J)

%% Removal of noise from image
% h1 = [0 -1 0; -1 5 -1; 0 -1 0];  % High Pass Filter_1
% Image1 = mat2gray(filter2(h1,Image1));% Filtering the Image through High pass filter_1
[Image2,noise]=wiener2(Image1);% Passing Image1 through a adaptive wiener filter
figure(2)
imshow(mat2gray(Image2));
title('Removal of noise from image')
%variance=var(Image1)
% freqz2(noise)


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
% Image4=mat2gray(deconvreg(Image2,H)); %Deblurring image using other deconvolution methods
% figure;
% imshow((Image4))
% title('Deblurring image 2')

%% Unwarping the image
Z=zeros(480,480);
for i=1:380
for j=1:380
        x=j-190.5;
        y=190.5-i;
        %Converting Polar Coordinates (r,teta) to Cartesian Coordinates (x,y)
        rij=sqrt((x)^2+(y)^2); %pythagoras theorem
        teta=atan2(y,x); %Four quadrant inverse tangent
        r=abs((R0.*asin(rij/R0))); %given condition
        x1=(r.*cos(teta)); %r= x1/cos(teta)
        y1=(r.*sin(teta)); %r= y1/sin(teta)
        j1 =round(x1+291);
        i1 =round(291-y1);
        Z(i1+100,j1+100)= Image3(i,j);
    end
end
%%
figure
imshow(Z);
Z = medfilt2(Z); % Passingimage into a Cartesean coordinate system image, makingthe information on the image to be able to be directlyimplemented and understood. Image1 through a median filter
%Image5 = mat2gray(Image5);
figure
imshow(Z);
title('Output Image')
%%
for i=1:380
for j=1:380
        x=j-190.5;
        y=190.5-i;
        %Converting Polar Coordinates (r,theta) to Cartesian Coordinates (x,y)
        rij=sqrt((x)^2+(y)^2); %cartesian points to polar amplitude
        teta=atan2(y,x); %Four quadrant inverse tangent
        r=abs((R0.*asin(rij/R0))); %given condition
        x1=(r.*cos(teta)); %r= x1/cos(teta)
        y1=(r.*sin(teta)); %r= y1/sin(teta)
        j1 =round(x1+291);
        i1 =round(291-y1);
        Z(i1+100,j1+100)= Image3(i,j);
end
end
%%
figure
imshow(Z);