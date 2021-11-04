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

function [deep_img, foc_img, f] = get_deep_tifimg( fname, vs ),

if (nargin < 2), vs=1; end;
foc_img=0; f=0;

info = imfinfo(fname);
num_images = numel(info);
A=imread(fname,1);
I = zeros([size(A,1),size(A,2),1,num_images]);
for k = 1:num_images
    A = double(imread(fname, k));
    I(:,:,1,k)=A(:,:);
    if (nargout > 1),
      A=A-min(A(:)); A=A/max(A(:));
      sx=size(A,1); sy=size(A,2);
      mx=sx/2; my=sy/2; mmx=sx/4; mmy=sy/4;
      r=false(size(A)); r(mmx:(mmx+mx), mmy:(mmy+my))=1;
      tf=fmeasure(A, 'SFIL', r);
      if (f < tf), foc_img=A; f=tf; end;
    end;
end

if (vs),
  I=I-min(I(:)); I=I/max(I(:))*255;
  deep_img = GradientFusion(I);
else
  deep_img=0;
end;
end