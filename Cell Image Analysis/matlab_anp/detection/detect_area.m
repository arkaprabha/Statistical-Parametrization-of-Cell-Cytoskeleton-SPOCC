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

function [] = detect_area( toLoad, toSave, verbose )
%[xc, yc, rI] = detect_centers(...)

  addpath('../gm');
  addpath('../deepimg');
  
  rgbO = (t_deep_tifread(toLoad, 1, 0.25));
  
  if (size(rgbO,3) == 1), rgbO = double(repmat(rgbO, [1 1 3])); end;
  
  [masked_image] = separate(double(rgbO),1);
  sm=masked_image(:,:,1)*255;
  sm=imresize(double(sm),4);
  r=sm(:,:,1); r(1:30,:)=0; r(:,1:30)=0; r(end-30:end,:)=0; r(:,end-30:end)=0; figure; imshow(r);
  rw=bwlabel(logical(r));
  l=histc(rw(:),1:max(rw(:)));
  [~,b]=max(l);
  r(rw~=b)=0;
  sm=r;

  [PathStr,~]=fileparts(toSave);
  if (~exist(PathStr,'dir')), mkdir(PathStr); end;
    
  imwrite(sm,toSave);
  end