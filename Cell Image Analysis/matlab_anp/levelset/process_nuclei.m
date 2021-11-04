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

function [pmodel] = process( input_file, output_file, twosteps, verbose, pmodel, actualiter, numiter, clean ),

addpath('../deepimg');
addpath('../gm');

if (nargin < 8), clean=0; end;

if (actualiter <= 1),
    [pmodel.img]=(t_deep_tifread(input_file, 1)); pmodel.img=double(pmodel.img); pmodel.img=pmodel.img/max(pmodel.img(:))*255;
    pmodel.bimg=imresize(pmodel.img,0.25);
    %pmodel.bimg=autocontrast2gray(pmodel.bimg,4);
    %kernel = fspecial('gaussian', 3, 1.25);
    %pmodel.bimg=uint8(round(conv2(double(pmodel.bimg),kernel,'same')));
    
    mfd=false(size(pmodel.bimg)); mfd(10:end-10,10:end-10)=true(size(pmodel.bimg)-19);

    if (twosteps),
        abimg=uint8(pmodel.bimg)*0.5+imadjust(uint8(imresize(pmodel.img,0.25)))*0.5;
        kernel = fspecial('gaussian', 5, 2.5);
        pmodel.bimg=uint8(round(conv2(double(abimg),kernel,'same')));
        sgb=mfd*0;
    else
        sgb=mfd*0;
    end;
    if (sum(sgb(:)) == 0), sgb=mfd; end;
    pmodel.sgb=sgb;
    
    pmodel.model2=[];
    pmodel.tt=0; pmodel.ttt=0; pmodel.tN=0;
end;

if ((pmodel.tt <= 5) && (pmodel.ttt <= 20)),
  pmodel.model2=run_levelset_nuclei(pmodel.bimg,pmodel.sgb, pmodel.model2, actualiter, numiter, verbose);
  tN=numel(find(pmodel.model2.phi >= 0));
  if (pmodel.tN == tN),
    pmodel.tt = pmodel.tt+1;
  else
    if (abs(pmodel.tN-tN) <= 5),
      pmodel.ttt=pmodel.ttt+1;
    else
      pmodel.ttt=0;
    end;
    pmodel.tN = tN;
    pmodel.tt = 1;
  end;
end;

if (actualiter >= numiter),
    sg=false(size(pmodel.model2.phi)); sg(pmodel.model2.phi >= 0)=1;
    sg=imresize(sg,4);
    
    se = strel('disk',10); % For the considered magnification
    sg = imclose(imopen(sg,se),se);    
    
    if (clean),
      r=bwlabel(sg);
      l=histc(r(:), 1:max(r(:)));
      [~,b]=max(l);
      sg(r ~= b)=0;
    end;
    
    [PathStr,~]=fileparts(output_file);
    if (~exist(PathStr,'dir')), mkdir(PathStr); end;
    
    imwrite(sg, output_file);
end;

end