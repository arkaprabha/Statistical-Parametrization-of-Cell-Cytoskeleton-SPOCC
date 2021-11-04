%{
Created by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub repository

This code is a continuation of CustomCrop_1.m

The purpose of this code is to blur the edges of the mask generated in
CustomCrop_1.m and generate the cropped .tif image of the area of interes

Input: mask for a cropped area
Output: cropped .tif image (can be used for Cell Image Analysis package)
%}



%Setting up file names
fname2 = strcat('Cell_alpha',num2str(hr),'hrs_act_',num2str(m),'.tif');

%Generating mask and smoothing out the edges
M = ~h.createMask();
mask = 1 - M;
blurmask = imgaussfilt(mask,20);

%Multiplying mean image with blurred mask
mean2 = double(mean1);
final = uint16(times(mean2,blurmask));


%Creating file for processing
for i2 = 1:19
    imwrite(final,[fname2], 'WriteMode', 'Append')
end

nn = double(imread([fname2],'Index',1));
figure; imshow(nn,[]); colormap(pink)