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

function [data] = cytoskeleton_latest( actinFile, guassian_directed_filter, ms_mean, ms_weight, fl, data ),
  addpath('../multislineseg/');
  addpath('../mycurvesensor/');
  

  W = ms_weight; step = 2; 
  tolval=0.95;
  angletol=80;
  binmean=ms_mean;
  
  margin=40;
  ppI=imread(actinFile);
  
                      gauss_margin=guassian_directed_filter*3;
                      mask = false(size(ppI)); mask((gauss_margin+1):(end-gauss_margin-1),(gauss_margin+1):(end-gauss_margin-1))=true;
                      [nbI,gsimg] = im_seg_latest(ppI,mask,W,step,binmean,0);
                      
                      mask = false(size(ppI)); mask((margin+1):(end-margin-1),(margin+1):(end-margin-1))=true;
                      nbI = logical(~(nbI.*mask));
                      
                      bI=nbI;
                      flist=1:1:179;
                      [bseg,nbseg,rF,iltheta]=get_segments_latest(~bI, flist, fl, angletol, tolval, 0); nbTotal=size(bseg,1);
                      nbI=logical(rF); bI=~nbI;

                      if (nargin < 6), data.dataM=[]; data.dataM1=[]; data.dataM2=[]; data.theta_list=1:1:179; data.final_theta=iltheta; end;

                      
                      [actinFolder,fileName, extF]=fileparts(actinFile);
                      imwrite(uint8(nbI*255), [actinFolder '\binary_' fileName extF]);
                      
		       % Filaments
                       [~,onlyName,next]=fileparts(fileName);                       
		               nucleiFolder=[actinFolder '\..\..\nuclei'];
                       onlyName=onlyName(9:end);
                       nucleiFile=[nucleiFolder '\res_filaments\' onlyName '_nucleus' next '.bmp'];
                       if (exist(nucleiFile, 'file') == 2),
                         nucI=imread(nucleiFile);
                       else
                         nucI=nbI*0;
                       end;

                       dataM1=[];
                       for p=1:size(bseg,1),
		                 [my1,mx1]=ind2sub([size(nucI,1),size(nucI,2)],bseg(p,2)); 
                         [my2,mx2]=ind2sub([size(nucI,1),size(nucI,2)],bseg(p,4));
                         cx=round( (mx1+mx2)/2 ); cy=round( (my1+my2)/2 );
                         dataM1=[dataM1; bseg(p,1), 1, bseg(p,5), 0, 0, 0, 0, double(nucI(cy,cx)), double(max([nucI(my1, mx1), nucI(my2, mx2), nucI(cy, cx)]))];
                       end;
                       
                       dataM2=[];
                       for p=1:size(nbseg,1),
                         [my1,mx1]=ind2sub([size(nucI,1),size(nucI,2)],nbseg(p,2)); 
                         [my2,mx2]=ind2sub([size(nucI,1),size(nucI,2)],nbseg(p,4));
                         cx=round( (mx1+mx2)/2 ); cy=round( (my1+my2)/2 );
                         dataM2=[dataM2; nbseg(p,1), 1, nbseg(p,5), 0, 0, 0, 0, double(nucI(cy,cx)), double(max([nucI(my1, mx1), nucI(my2, mx2), nucI(cy, cx)])) ];
		       end;

                      %dataM1=[bseg(:,1),  ones(size(bseg,1),1),  bseg(:,5)];
		              %dataM2=[nbseg(:,1), ones(size(nbseg,1),1), nbseg(:,5)];

                      dataM=dataM2;
                      
                      data.minLength=fl;
                      data.dataM=[data.dataM; dataM];
                      data.dataM1=[data.dataM1; dataM1];
                      data.dataM2=[data.dataM2; dataM2];

end