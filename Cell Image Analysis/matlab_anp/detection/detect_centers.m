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

function [] = detect_centers( toLoad, toSave, verbose )
%[xc, yc, rI] = detect_centers(...)

  addpath('../gm');
  
  rgbO = imadjust(imread(toLoad));
  rgbO=imresize(rgbO,0.25);
  
  if (size(rgbO,3) == 1), rgbO = double(repmat(rgbO, [1 1 3])); end;
  
  [masked_image] = separate(double(rgbO),1);
  sm=double(rgb2gray(uint8(masked_image*255)));
  sm=imresize(sm,4);
  se = strel('disk',10); % For the considered magnification
  sm = imclose(imopen(sm,se),se);

  [PathStr,~]=fileparts(toSave);
  if (~exist(PathStr,'dir')), mkdir(PathStr); end;
    
  imwrite(sm,toSave);
  if (verbose), figure(2); imshow(sm); end;
  
  %imf=fspecial('gaussian', 15, 1.5); %imf=fspecial('gaussian', 5, 0.1');
  %rgbI=uint8(conv2(double(rgbO(:,:)),imf));

  %gt=graythresh(rgbI);
  %sm=zeros(size(rgbI), 'uint8'); sm(rgbI >= gt)=255;
  %sI = logical(sm); 
  
  %se = strel('disk',10); % For the considered magnification
  %rI = imclose(imopen(sI,se),se);
  %imwrite(rI, toSave); 
      
  %r=regionprops(rI, 'centroid');
  %xc=zeros(numel(r),1); yc=zeros(numel(r),1);
  %for i=1:numel(r), xc(i)=r(i).Centroid(1); yc(i)=r(i).Centroid(2); end;  
end