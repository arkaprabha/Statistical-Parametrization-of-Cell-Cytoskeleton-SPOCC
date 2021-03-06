%% Fusion of Multi-exposure and Multi-focus images
%
% Version 1.0
% S. Paul(1), I. Sevcenco(2), P. Agathoklis(2)
% (1) Department of Eletronics and Telecommunication Engineerin,
%     Jadavpur University, Kolkata, India
% (2) Department of Electrical and Computer Engineering
%     University of Victoria, Victoria, B.C., Canada
%
% DESCRIPTION of the Code:
%     This is a demo file for executing the fusion of an arbitrary number
%     of grayscale and color images.
%
%     The code can be used to fuse multi-exposure or multi-focus images.
%     The resulting image will have an increased amount of information
%     than the source images.
%
% NOTE: The images to be fused have to be all of the same type
%     (i.e., all in grayscale or all in RGB representation; all
%     multi exposure or all multi focus).
%
% GUIDELINES for running the Code:
%     The input images should be named as ImageName_ImageNumber and should
%     be kept in the same folder as the codes for image fusion.
%
%     For example: An input image stack named 'office' containing 5 images
%     should be named 'office_1', 'office_2', .., 'office_5'
%     The 'office' image stack is part of the MATLAB distribution.
%
%     Specifications to be mentioned in the code:
%         NameImg : A generic name for the set of input images to be fused
%         NumberOfImages : Number of images in the input images stack
%         Format : Format of the input images.
%
% Written by : Sujoy Paul, Jadavpur University, 2014
%         At : University of Victoria, Canada
% Modified by: Ioana Sevcenco, University of Victoria, Canada
% Last updated: December 10, 2014
%
% REFERENCES:
%
% [1] S. Paul, I.S. Sevcenco, P. Agathoklis, "Multi-exposure and
% Multi-focus image fusion in gradient domain" (submitted for publication)
%
% [2] I.S. Sevcenco, P.J. Hampton, P. Agathoklis, "A wavelet based method
% for image reconstruction from gradient data with applications",
% Multidimensional Systems and Signal Processing, November 2013

clear; close all;
%% Specifications of the set of input images
NameImg = 'office';                    % Name of the input image set
NumberOfImages = 5;                    % Number of images in the input set
Format = '.jpg';                       % The format or type of the input images

%% Preallocate stack where the images in the input set will be stored
tmp = imread(strcat(NameImg,'_1',Format)); [s(1),s(2),s(3)]=size(tmp); clear tmp;
I = zeros([s,NumberOfImages]); clear s
%% Read the input images
for i = 1:NumberOfImages
    I(:,:,:,i) = imread(strcat(NameImg,'_',num2str(i),Format));
end
%% Call the function to fuse the input images
G = GradientFusion(I);                 %Main function of image fusion
%% Display the fused image
%%
figure,
for i = 1:NumberOfImages,
    subplot(2,NumberOfImages,i),
    imshow(uint8(I(:,:,:,i)));title(['Input image ', num2str(i)]);
    subplot(2,NumberOfImages,NumberOfImages+i),
    if size(I,3)==1
        imhist(uint8(I(:,:,:,i)));
    else
        imhist(rgb2gray(uint8(I(:,:,:,i))));
    end
end

text(-1000,7500,'Histograms of grayscale vesions of input images')

figure,
subplot(211);
imshow(G),title('Fused image')
subplot(212);
if size(I,3)==1
    imhist(uint8(G));
    title('Histogram of output image')

else
    imhist(rgb2gray(uint8(G)));
    title('Histogram of grayscale version of output image')
end