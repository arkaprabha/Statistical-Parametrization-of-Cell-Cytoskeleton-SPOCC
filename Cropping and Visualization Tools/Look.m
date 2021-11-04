%{
Created by by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub Repository

The purpose of this code is to look at individual .tif images in pink
colorbar 
Scalebar: 16 micron

%}





clear all

im = zeros(512,512);

for i=1:5
    a = double(imread('22hrs_act_8.tif','Index',i)); %input name of .tif image
    im = im + a;
    i
end

im = im./i;
%im = im./max(max(im));

im1 = im;
im1(11:20,31:124) = max(max(im1));

figure; imshow(im1,[]); colormap(pink)