%*********************************************************************
%** (c) Copyright 2016
%** The author(s): Mitchel Alioscha-Perez (maperezg@etro.vub.ac.be)
%** Vrije Universiteit Brussel,
%** Department of Electronics and Informatics (ETRO),
%** Faculty of Engineering Sciences,
%** VUB-ETRO,
%** 2 Pleinlaan, 1050 Belgium.
%** (VUB - ETRO)
%**
%** All right reserved
%** Permission to use, copy, modify, and distribute within VUB-ETRO
%** this routine/program/software and/or its documentation, or part of any one of them
%** (the program) for research purpose within VUB-ETRO is hereby granted, provided:
%** (1) that the copyright notice appears in all copies,
%** (2) that both the copyright notice and this permission notice appear in the supporting documentation, and
%** (3) that all publications based partially or completely on this program will have the main publications of "the authors" related to this
%** work cited as references.
%** Any other type of handling or use of the program, CAN NOT BE DONE
%** WITHOUT PRIOR WRITTEN APPROVAL from the VUB-ETRO,
%** including but not restricted to the following:
%** (A) any re-distribution of the program to any person outside of the VUB-ETRO
%** (B) any use of the program which is not academic research;
%** (C) any commercial activity involving the use of the program is strictly prohibited.
%** Modifications: 2015, 2016
%** Disclaimer: VUB ETRO make no claim about the
%** suitability of the program for any particular purpose.
%** It is provided "as is" without any form of warranty or support.
%********************************************************************************************

close all;
addpath('../gm');

twosteps=0;

img=imread('n2.tif');
bimg=uint8(double(img)/max(double(img(:)))*255);
bimg=imresize(bimg,0.25);
mfd=false(size(bimg)); mfd(30:end-30,30:end-30)=true(size(bimg)-59);

%timg=bimg; timg(bimg == 0)=1; timg=repmat(timg,[1 1 3]); timg(:,:,2)=uint8(timg(:,:,2)+1)*rand(1); timg(:,:,3)=uint8(timg(:,:,3)+2)*rand(1);
%[masked_image] = separate(double(timg),1);

if (twosteps),
    bimg=imadjust(bimg); abimg=bimg;
    kernel = fspecial('gaussian', 5, 2.5);
    bimg=round(conv2(double(abimg),kernel,'same'));

    mi=separate(double(repmat(bimg, [1 1 3])), 1);

    p1=run_levelset(uint8(mi*255),mfd, 100);
    sg=false(size(p1)); sg(p1 >= 0)=1;

    sgb=imdilate(imerode(sg, strel('disk', 1)), strel('disk',5));
else
    sgb=mfd*0;
end;

if (sum(sgb(:)) == 0), sgb=mfd; end;
p2=run_levelset(bimg,sgb, 100);
sg=false(size(p2)); sg(p2 >= 0)=1;
