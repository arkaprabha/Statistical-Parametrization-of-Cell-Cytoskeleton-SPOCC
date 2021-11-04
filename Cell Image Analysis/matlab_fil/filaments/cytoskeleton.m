%*********************************************************************
%** (c) Copyright 2016
%** The author(s): Mitchel Alioscha-Perez (maperezg@etro.vub.ac.be)
%** Vrije Universiteit Brussel,
%** Department of Electronics and Informatics (ETRO),
%** Faculty of Engineering Sciences,
%** VUB-ETRO,
%** 2 Pleinlaan, 1050 Belgium.
%** (VUB - ETRO)
**
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

function [] = cytoskeleton( actinFile, guassian_directed_filter, ms_mean, ms_weight, fl ),
  addpath('../multislineseg/');
  addpath('../mycurvesensor/');

  W = ms_weight; step = 2; 
  tolval=0.90;
  angletol=20;
  binmean=ms_mean;
  
  margin=40;
  ppI=imread(actinFile);
  
                      gauss_margin=guassian_directed_filter*3;
                      mask = false(size(ppI)); mask((gauss_margin+1):(end-gauss_margin-1),(gauss_margin+1):(end-gauss_margin-1))=true;
                      [nbI,gsimg] = im_seg(ppI,mask,W,step,binmean,0);
                      
                      mask = false(size(ppI)); mask((margin+1):(end-margin-1),(margin+1):(end-margin-1))=true;
                      nbI = logical(~(nbI.*mask));
                      
                      bI=nbI;
                      nbI=pruneImage(~bI, tolval, angletol); bI=~nbI;
                      
                      [actinFolder,fileName, extF]=fileparts(actinFile);
                      imwrite(uint8(nbI*255), [actinFolder '\binary_' fileName extF]);
end