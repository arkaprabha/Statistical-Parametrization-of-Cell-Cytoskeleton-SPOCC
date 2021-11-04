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

function [segmentedimg, gsimg] = im_seg(img,mask,W,step,binmean,standarization)
% img: original color image
% mask: mask of FOV
% W: window size which is chosen as double of typical vessel width
% step: step size for increasing the line length
if (nargin < 5), standarization=0; end;

img = im2double(img);
mask = im2bw(mask);

img = img(:,:);
img = fakepad(img,mask);

features = standardize(img,mask,standarization);
Ls = 1:step:W;
for L = (Ls')',
   R = get_lineresponse(img,W,L,[0:15:165]); 
   R = standardize(R,mask,standarization);
   features = features+R;
   %disp(['L = ',num2str(L),' finished!']);       
end     
gsimg = features/(1+numel(Ls));
%gsimg(gsimg < 0)=0; 
gsimg=gsimg-min(gsimg(:)); gsimg=gsimg/max(gsimg(:));

%t=graythresh(gsimg()); 
t=graythresh(gsimg(mask)); 

tgsimg=gsimg; tgsimg(gsimg < t*0.5)=0;

% ***** version 1 *******
%segmentedimg = ~adaptivethreshold(tgsimg, W, 0.0005, 1);

% ***** version 2 ******
%segmentedimg = adaptivethresh(tgsimg, W, -binmean, 'gaussian', 'relative');
segmentedimg = adaptivethresh(tgsimg, round(W/2), +binmean, 'median', 'relative');

% ***** version 3 *******
%segmentedimg = 1-bradley(1-tgsimg, round(W/2)*[6 6], binmean, 0);


%t = 0.56;
%segmentedimg = im2bw(gsimg,t);

end