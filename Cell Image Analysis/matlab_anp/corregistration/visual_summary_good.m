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

function [] = visual_summary( ad, pd, nd ),
    addpath('../deepimg');

    %ad='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\actin\';
    %pd='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\pattern\';
    %nd='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\nuclei\';

    ad=[ad '\']; pd=[pd '\']; nd=[nd '\'];
    rres=[ad '\..\res\'];
    rpr=[rres '\aligned_to_process\'];
    rps=[rres '\aligned_to_show\'];
    if (~exist(rpr,'dir')), mkdir(rpr); end;
    if (~exist(rps,'dir')), mkdir(rps); end;
    
    lf=dir([ad '\..\template_*.bmp']);
    if (numel(lf) > 0),
      tfile=lf(1).name(10:end-4);
    
        fla=dir([ad '\*.tif*']);
        flp=dir([pd '\*.tif*']);
        fln=dir([nd '\*.tif*']);

        tt1=zeros(1001, 1001);
        tt2=tt1; tt3=tt1;
        for i=1:numel(flp),
         fa=fla(i);
         fp=flp(i);
         fn=fln(i);
         [~, ~, tx, ty]=get_displacement( tfile, fa.name, [rres 'centers_data.csv']);
         %tx=500;ty=500;
         t1=deep_tifread([ad fa.name]);
         tf1=apply_displacement( 500, 500, tx, ty, t1(:,:,1) ); 
         imwrite(tf1,[rpr 'actin_res_' fa.name]);
         t2=imread([pd fp.name]);
         tf2=apply_displacement( 500, 500, tx, ty, t2(:,:,1) ); 
         imwrite(tf2,[rpr 'pattern_res_' fp.name]);
         t3=deep_tifread([nd fn.name]);
         tf3=apply_displacement( 500, 500, tx, ty, t3(:,:,1) ); 
         imwrite(tf3,[rpr 'nucleus_res_' fn.name]);

         tt1=tt1+double(tf1); tt2=tt2+double(tf2); tt3=tt3+double(tf3);

         tf1=double(tf1); tf2=double(tf2); tf3=double(tf3);
         tf1=tf1/1; tf1=tf1-min(tf1(:)); tf1=tf1/max(tf1(:));
         tf2=tf2/1; tf2=tf2-min(tf2(:)); tf2=tf2/max(tf2(:));
         tf3=tf3/1; tf3=tf3-min(tf3(:)); tf3=tf3/max(tf3(:));
         tf=zeros(size(tf1,1),size(tf1,2),3,'uint8'); tf(:,:,1)=tf1(:,:)*255;tf(:,:,2)=tf2(:,:)*255;tf(:,:,3)=tf3(:,:)*255;
         imwrite(tf,[rps 'res_' fa.name]);
        end;

        tt=zeros(1001, 1001, 3);
        tt1=tt1/numel(flp); tt1=tt1-min(tt1(:)); tt1=tt1/max(tt1(:));
        tt2=tt2/numel(flp); tt2=tt2-min(tt2(:)); tt2=tt2/max(tt2(:));
        tt3=tt3/numel(flp); tt3=tt3-min(tt3(:)); tt3=tt3/max(tt3(:));
        tt(:,:,1)=tt1; tt(:,:,2)=tt2; tt(:,:,3)=tt3;

        imwrite(tt,[rres 'ALIGNED_all_mean.bmp']);
        imwrite(gray2ind(tt1),jet,[rres 'ALIGNED_actin_mean_colormap.bmp']);
        imwrite(gray2ind(tt2),jet,[rres 'ALIGNED_pattern_mean_colormap.bmp']);
        imwrite(gray2ind(tt3),jet,[rres 'ALIGNED_nuclei_mean_colormap.bmp']);
    else
        fprintf('Nothing to summarize');
    end;
end