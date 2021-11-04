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

function [ xc,yc,rI ] = detect_centers( rgbI )

  [masked_image] = separate(double(rgbI),1); sm=double(rgb2gray(uint8(masked_image*255)));
  %save('sm', 'sm');
  %load sm;
  
  figure;imshow(sm);
  
  sI = logical(sm);
  
  se = strel('disk',10); % For the considered magnification
  rI = imclose(imopen(sI,se),se);
  
  if (false),
      I=double(rgb2gray(rgbI))/255;
      rb=regionprops(rI, 'centroid','boundingbox');  
      rI=false(size(sI));  
      for i=1:numel(rb),
        xu=floor(rb(i).BoundingBox(1)); yu=floor(rb(i).BoundingBox(2));
        xd=xu+ceil(rb(i).BoundingBox(3)); yd=yu+ceil(rb(i).BoundingBox(4));
        if (xu < 1), xu=1; end; if (yu < 1), yu=1; end;
        if (xd > size(I,2)), xd=size(I,2); end;
        if (yd > size(I,1)), yd=size(I,1); end;

        clear om; om=I(yu:yd,xu:xd); g=graythresh(om);
        om(om < g)=0; om(om >= g) = 1; om=imopen(imclose(om,se),se);
        rI(yu:yd,xu:xd)=logical(om(:,:));
      end;
  end;
      
  r=regionprops(rI, 'centroid');
  xc=zeros(numel(r),1); yc=zeros(numel(r),1);
  for i=1:numel(r), xc(i)=r(i).Centroid(1); yc(i)=r(i).Centroid(2); end;  
end