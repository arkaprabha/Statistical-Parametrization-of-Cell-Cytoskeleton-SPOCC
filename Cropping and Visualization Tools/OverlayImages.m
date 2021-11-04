%{
Created by by: Arkaprabha Basu

Last Updated Version: 11/03/2021 for GitHub Repository

The purpose of this code is to generate an overlay actin and antibody images from two different .tif images
Scalebar: 16 micron

Actin is shown in magenta
Antibody is shown in green

%}



clear all

%create the actin image matrix
im1 = zeros(512,512);

for i=1:5
    a = double(imread('20hrs_act_10.tif','Index',i)); %input name of actin .tif image
    %a = a(110:380,58:380);
    im1 = im1 + a;
    i
end
im1 = im1./max(max(im1));
im1(11:20,31:124) = max(max(im1));

%create the antibody image matrix
im2 = zeros(512,512);

for i=1:5
    a = double(imread('20hrs_fak_10.tif','Index',i)); %input name of antibody .tif image
    %a = a(110:380,58:380);
    im2 = im2 + a;
    i
end
im2 = im2./max(max(im2));
im2(11:20,31:124) = max(max(im2));

%create a zero matrix with just the scale bar for the blank rgb value
im3 = zeros(512,512);
im3(11:20,31:124) = 1;

%generate the actin image in magenta
magenta(:,:,1) = im1;
magenta(:,:,2) = im3;
magenta(:,:,3) = im1;

figure; imshow(magenta,[])

%generate the antibody image in green
green(:,:,1) = im3;
green(:,:,2) = im2;
green(:,:,3) = im3;

figure; imshow(green,[])

%generate overlay image
overlay(:,:,1) = im1;
overlay(:,:,2) = im2;
overlay(:,:,3) = im1;

figure; imshow(overlay,[])



