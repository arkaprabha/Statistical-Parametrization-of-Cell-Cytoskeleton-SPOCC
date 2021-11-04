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

function [oimg1, oimg2] = mysaturation( img1, img2 ),

hsv1=rgb2hsv(img1); hsv2=rgb2hsv(img2);
h1=hsv1(:,:,1); h2=hsv2(:,:,2);

%s1=hsv1(:,:,2); s2=hsv2(:,:,2);
%rs1=max( [h1(:)', h2(:)'] )/max(h1(:)) * s1; rs2=max( [h1(:)', h2(:)'] )/max(h2(:)) * s2;
%r1=hsv1;r1(:,:,2)=rs1(:,:);r2=hsv2;r2(:,:,2)=rs2(:,:);

rs1=max( [h1(:)', h2(:)'] )/max(h1(:)) * hsv1; rs2=max( [h1(:)', h2(:)'] )/max(h2(:)) * hsv2;
r1=rs1;r2=rs2;

oimg1=hsv2rgb(r1); oimg2=hsv2rgb(r2);
