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

function [] = filter( actinFile, numIter, display )

  addpath('../Wavelab850/'); WavePath( [pwd '\\..\\\Wavelab850\\'] ); InstallMEX;
  %addpath(matlabroot,'\toolbox\Wavelab850\'); WavePath([matlabroot '\toolbox\Wavelab850\']);
  
  addpath('../mcalab/'); MCAPath( [pwd '\\..\\\mcalab\\'] );
  addpath('../deepimg/');
  addpath('nucleionly');

    % Dictionary stuff (here Curvelets + UDWT).
    qmf=MakeONFilter('Symmlet',6);
    dict1='UDWT2';pars11=3;pars12=qmf;pars13=0;
    dict2='CURVWRAP';pars21=2;pars22=0;pars23=0;
    %dict2='CURV';pars21=2;pars22=0;pars23=0;
    addpath ../mcalab/Utils
    addpath ../mcalab/MCALab110/One-D/Dictionaries
    addpath ../mcalab/MCALab110/Two-D/Decomposition
    dicts=MakeList(dict1,dict2);
    pars1=MakeList(pars11,pars21);
    pars2=MakeList(pars12,pars22);
    pars3=MakeList(pars13,pars23);

if (nargin < 2), numIter=100; end;

    % MCA related params
    itermax 	= numIter;
    tvregparam 	= 3;
    tvcomponent	= 1;
    expdecrease	= 0;
    lambdastop	= 3;
    
    % Processing related parameters
    maxSize=512;
    
if (nargin < 3), display=0; end;
    
[actinFolder,fileName, extF]=fileparts(actinFile);
rres=[actinFolder '\res_filaments\'];
if (~exist(rres, 'dir')), mkdir(rres); end;

if (exist([actinFolder '\..\res\aligned_to_process\actin_res_' fileName], 'file')),
      I=imread([actinFolder '\..\res\aligned_to_process\actin_res_' fileName]);
else
      image=actinFile;
      tifi=imread(actinFile);
      if ((numel(tifi) > 1) && ((strcmpi(actinFile((end-4):end), '.tiff') || strcmpi(actinFile((end-3):end), '.tif')))),
        I=imread(actinFile);
        if ((size(I,1) > maxSize) || (size(I,2) > maxSize)),
          tr=maxSize/min(size(I,1),size(I,2));
          I=t_deep_tifread( image, 1, tr);
        else
          tr=1;
          I=t_deep_tifread( image, 1, tr);
        end;
      else
        I=tifi;
        if (size(I,3) > 1), I=rgb2gray(I); end;
        I=double(I);
        if ((size(I,1) > maxSize) || (size(I,2) > maxSize)),
           tr=maxSize/max(size(I,1),size(I,2));
           I=imresize(I,tr);
        end
      end;
end;
      %Better not to normalize
      %I=double(I); I=I-min(I(:)); I=I/max(I(:)); I=I(:,:,1);
      [parts,options]=MCA2_Bcr(I,dicts,pars1,pars2,pars3,itermax,tvregparam,tvcomponent,expdecrease,lambdastop,[],[],display);
      fI =  parts(:,:,2);
      rI=fI; rI=rI-min(rI(:)); rI=rI/max(rI(:));
          
      imwrite(uint8(rI*255), [rres '\' fileName extF '.bmp']);
      I=double(I); I=I-min(I(:)); I=I/max(I(:)); I=I(:,:,1); I=I*255;
      imwrite(I, [rres '\orig-' fileName extF '.bmp']);
      
      % Nuclei processing
      nucleiFolder=[actinFolder '\..\nuclei'];
      if (exist(nucleiFolder, 'dir')),
          rres=[nucleiFolder '\res_filaments\'];
          if (~exist(rres, 'dir')), mkdir(rres); end;
          outNuclei=[nucleiFolder '\res_filaments\' fileName '_nucleus' extF '.bmp'];
          
          process_thisnuclei( [nucleiFolder '\' fileName '_nucleus' extF], outNuclei, tr );
          nucI=imresize(imread(outNuclei),tr);
          imwrite(nucI,outNuclei);
      end
end