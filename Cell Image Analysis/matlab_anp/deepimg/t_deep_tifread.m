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

function [deep_img, foc_img, f] = get_deep_tifimg( fname, vs, resize ),

if (nargin < 2), vs=1; end;
if (nargin < 3), resize=1; end;

foc_img=0; f=0;

info = imfinfo(fname);
num_images = numel(info);
A=imread(fname,1); A=imresize(A,resize);
I1 = zeros([size(A,1),size(A,2),1,num_images]);
I2 = zeros([size(A,2),size(A,1),1,num_images]);
I3 = I1;
I4 = I2;
for k = 1:num_images
    A = imread(fname, k);
    if (size(A,3) > 1), t=A(:,:,1); A=t; end;
    A=double(imresize(A,resize));
    I1(:,:,1,k)=A(:,:);
    I2(:,:,1,k)=rot90(A(:,:));
    I3(:,:,1,k)=rot90(rot90(A(:,:)));
    I4(:,:,1,k)=rot90(rot90(rot90(A(:,:))));
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
  I1=I1-min(I1(:)); I1=I1/max(I1(:))*255;
  I2=I2-min(I2(:)); I2=I2/max(I2(:))*255;
  I3=I3-min(I3(:)); I3=I3/max(I3(:))*255;
  I4=I4-min(I4(:)); I4=I4/max(I4(:))*255;
  R1=GradientFusion(I1);
  R2=rot90(rot90(rot90(GradientFusion(I2))));
  R3=rot90(rot90(GradientFusion(I3)));
  R4=rot90(GradientFusion(I4));
  deep_img = uint8((double(R1)+double(R2)+double(R3)+double(R4))/4.0);
else
  deep_img=0;
end;
end