%{
Created by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub repository

This code is a continuation of CustomCrop_1.m

The purpose of this code is to add the same mask (from CustomCrop_1.m and
CustomCrop_2.m) and apply that on the antibody .tif image to generate
cropped antibody .tif image

Input: original antibody .tif image, mask for a cropped area
Output: cropped antibody .tif image
%}
mean3 = uint16(zeros(512,512));
%Setting up file names
fname3 = strcat(num2str(hr),'hrs_fak_',num2str(m),'.tif');
fname4 = strcat('Crop_FAK_',num2str(hr),'hrs_',num2str(m),'.tif');

%Putting same mask on antibody image
for i1 = 1:5
    a = imread([fname3],'Index',i1);
    mean3 = mean3+a;
end
mean3 = mean3./i1;
mean4 = double(mean3);
abfinal = uint16(times(mean4,blurmask));
figure; imshow(abfinal,[])

for i2 = 1:19
    imwrite(abfinal,[fname4], 'WriteMode', 'Append')
end

nn2 = double(imread([fname4],'Index',1));
figure; imshow(nn2,[]); colormap(pink)

