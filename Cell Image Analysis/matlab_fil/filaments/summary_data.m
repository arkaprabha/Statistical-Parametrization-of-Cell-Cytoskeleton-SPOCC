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
%*******************************************************************************************
function [rI,sI,sF] = clean_data(actinFolder),
magX=250; magY=250;

rres=[actinFolder '\..\res\'];
fl=dir([actinFolder '\res_filaments\preproc*.bmp']);

  if (~exist(rres, 'dir')), mkdir(rres); end;
  fileIDd=fopen([rres '\filaments_data.csv'],'w');
  fprintf(fileIDd, 'totalActin, Image\n');

lc=[];
flage=0;
for f=fl',
  d=imread([actinFolder '\res_filaments\preproc_' f.name(9:end)]); %d=imresize(d,0.5);
  b=imread([actinFolder '\res_filaments\binary_' f.name]);
  if (exist([actinFolder '\res\' f.name(9:end)])), 
    a=imread([actinFolder '\res\' f.name(9:end)]); %a=imresize(a,0.5);
    c=uint8(a).*b; imwrite(c, [actinFolder '\res_filaments\fb_' f.name]); 

    [~, ~, tx, ty]=get_displacement( fl(1).name(9:end-4), f.name(9:end-4), [rres 'centers_data.csv']);
    c=apply_displacement( magX, magY, floor(tx/2), floor(ty/2), c(:,:) ); 
    d=apply_displacement( magX, magY, floor(tx/2), floor(ty/2), d(:,:) );
  else
    c=b; imwrite(c, [actinFolder '\res_filaments\fb_' f.name]);
  end;
  lc=[lc, sum(c(:))];
  
  fprintf(fileIDd, '%i,%s\n', sum(c(:)), f.name(9:end-4));
  
  if (~flage),
      rI=c; sI=double(d); flage=1;
  else
      if (numel(rI(:)) == numel(c(:))),
        rI = rI+c; sI=sI+double(d);
      end;
  end;
end;
  fclose(fileIDd);


sF=uint8(sI);
sI=double(sI);
sI=sI/numel(fl);
%sI=sI-min(sI(:)); sI=sI/max(sI(:));

imwrite(rI, [rres 'sum_filaments.bmp']);
imwrite(uint8(sI), [rres 'visual_filaments.bmp']);

  lc=double(lc)/1000;
  [np_isNormal,np_pisNormal]=kstest(lc);
  np_m=mean(lc); np_s=std(lc);np_mi=min(lc); np_ma=max(lc);

  fileID=fopen([rres '\filaments_summary.csv'],'w');
  fprintf(fileID, 'isNormal (h), isNormal (p), Mean * 10^-3, Std* 10^-3, Min* 10^-3, Max* 10^-3\n');
  fprintf(fileID, '%i,%.4f,%.2f,%.2f,%.2f,%.2f\n', np_isNormal, np_pisNormal, np_m, np_s, np_mi, np_ma);
  fclose(fileID);

data.dataM=[];
data.dataM1=[];
data.dataM2=[];
fl=dir([actinFolder '\res_filaments\dataM-*.mat']);
for f=fl'
  load([actinFolder '\res_filaments\' f.name]);
  data.dataM=[data.dataM; all_data.dataM];
  data.dataM1=[data.dataM1; all_data.dataM1];
  data.dataM2=[data.dataM2; all_data.dataM2];
end;
data.theta_list=all_data.theta_list; data.final_theta=all_data.final_theta;
save([actinFolder '\..\res\dataFilaments.mat'], 'data');

% Normal
% statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:1:179, 1 );
% %statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:1:179, 0 );
% 
% statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:2:179, 1 );
% %statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:2:179, 0 );
% 
% statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:3:179, 1 );
% %statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:3:179, 0 );
% 
% statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:4:179, 1 );
% %statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:4:179, 0 );
% 
% statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:5:179, 1 );
% %statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:5:179, 0 );

statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10] );
%statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 0, [all_data.minLength, 3000], [1 10], 1:6:179, 0 );

statisticsFilaments([actinFolder '\..\res\'], 'dataFilaments.mat', 1, [all_data.minLength, 3000], [1 10] );
end