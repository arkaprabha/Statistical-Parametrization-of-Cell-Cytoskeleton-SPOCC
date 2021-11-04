%{
Created by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GutHub repository

The purpose of ths code is to generate a mask for a custom cropping area from a .tif image

Once the first image pops up, draw a closed shape around the area of
interest. Open shape is automatically closed by a straight line.
 
Continuation of this code in CustomCrop_2.m

Input: original .tif file
Output: mask for a cropped area
%}



clear all

%Setting up filenames
hr = 48;
m = 3;
fname1 = strcat(num2str(hr),'hrs_act_',num2str(m),'.tif');
mean1 = uint16(zeros(512,512));


%Generating custom crop Step_1
for i1 = 1:1
    a = imread([fname1],'Index',i1);
    mean1 = mean1+a;
end
mean1 = mean1./i1;

imshow(mean1,[]); colormap(pink)
h = imfreehand;  %draw around the area of interest

%run CustomCrop_2.m after drawing
