%*********************************************************************
%** (c) Copyright 2015
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
%** Modifications: 2013, 2014, 2015
%** Disclaimer: VUB ETRO make no claim about the
%** suitability of the program for any particular purpose.
%** It is provided "as is" without any form of warranty or support.
%********************************************************************************************

function [ btim ] = apply_displacement( magX, magY, tx, ty, im_rgb1ch )
              cx=magX+1; cy=magX+1;
              
              sy=size(im_rgb1ch,1); sx=size(im_rgb1ch,2);
              lx=tx-magX; rx=tx+magX; if (lx < 1), lx=1; end; if (rx > sx), rx=sx; end; lx=round(lx); rx=round(rx);
              ly=ty-magY; ry=ty+magY; if (ly < 1), ly=1; end; if (ry > sy), ry=sy; end; ly=round(ly); ry=round(ry);

              %btim=zeros(magX*2+1, magY*2+1, 'uint8');
              btim=repmat(im_rgb1ch(1,1), [magX*2+1, magY*2+1]);
              btim( (cy-(ty-ly)):(cy+(ry-ty)), (cx-(tx-lx)):(cx+(rx-tx)) )=im_rgb1ch(ly:ry, lx:rx);
end
