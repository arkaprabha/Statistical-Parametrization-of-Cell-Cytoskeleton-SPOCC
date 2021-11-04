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
    magX=500; magY=500;
    
    %ad='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\actin\';
    %pd='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\pattern\';
    %nd='d:\Work\PhD\Projects\0-ESA Project\fibersClassificationJava\data_epfl_nov\raw\microgravity\nuclei\';

    ad=[ad '\']; pd=[pd '\']; nd=[nd '\'];
    rres=[ad '\..\res\'];
    rpr=[rres '\aligned_to_process\'];
    rps=[rres '\aligned_to_show\'];
    if (~exist(rpr,'dir')), mkdir(rpr); end;
    if (~exist(rps,'dir')), mkdir(rps); end;
    
        fla=dir([ad '\*.tif*']);
        flp=dir([pd '\*.tif*']);
        fln=dir([nd '\*.tif*']);

    lf=dir([ad '\..\template_*.bmp']);
    if (numel(lf) > 0),        
        tfile=lf(1).name(10:end-4);
    else
        tfile=flp(1).name;
    end;
    
        tt1=zeros(magX*2+1, magY*2+1);
        tt2=tt1; tt3=tt1;
        tv1=tt1; tv2=tt1; tv3=tt1;
        tt1_corr=tt1; tt2_corr=tt2; tt3_corr=tt3;
        tv1_corr=tv1; tv2_corr=tv2; tv3_corr=tv3;
        
        ot1=tt1; ot2=tt2; ot3=tt3;
        ov1=tt1; ov2=tt2; ov3=tt3;
        ot1_corr=ot1; ot2_corr=ot2; ot3_corr=ot3;
        ov1_corr=ov1; ov2_corr=ov2; ov3_corr=ov3;
        
        for i=1:numel(flp),
         fa=fla(i);
         fp=flp(i);
         fn=fln(i);
         [~, ~, tx, ty]=get_displacement( tfile, fp.name, [rres 'centers_data.csv']);
         [~, ~, tx1, ty1]=get_displacement( tfile, fp.name, [rres 'annotated_centers_data.csv']);
         if (tx1*ty1==0), tx1=tx; ty1=ty; end;
         
         %tx=500;ty=500;
         [o1,t1]=t_deep_tifread([ad fa.name], 1);
         tf1=apply_displacement( magX, magY, tx, ty, t1(:,:,1) );
         tfl_corr=apply_displacement( magX, magY, tx1, ty1, t1(:,:,1) );
         
         of1=apply_displacement( magX, magY, tx, ty, o1(:,:,1) ); 
         of1_corr=apply_displacement( magX, magY, tx1, ty1, o1(:,:,1) ); 
         
         imwrite(of1,[rpr 'actin_res_' fa.name]);
         t2=imread([pd fp.name]);
         tf2=apply_displacement( magX, magY, tx, ty, t2(:,:,1) ); 
         tf2_corr=apply_displacement( magX, magY, tx1, ty1, t2(:,:,1) ); 
         
         imwrite(tf2,[rpr 'pattern_res_' fp.name]);
         [o3,t3]=t_deep_tifread([nd fn.name], 1);
         tf3=apply_displacement( magX, magY, tx, ty, t3(:,:,1) );
         tf3_corr=apply_displacement( magX, magY, tx1, ty1, t3(:,:,1) );
         
         of3=apply_displacement( magX, magY, tx, ty, o3(:,:,1) ); 
         of3_corr=apply_displacement( magX, magY, tx1, ty1, o3(:,:,1) ); 
         imwrite(of3,[rpr 'nucleus_res_' fn.name]);

         tt1=tt1+double(tf1); tt2=tt2+double(tf2); tt3=tt3+double(tf3);
         tv1=tv1+double(tf1).^2; tv2=tv2+double(tf2).^2; tv3=tv3+double(tf3).^2;
         ot1=ot1+double(of1); ot2=ot2+double(tf2); ot3=ot3+double(of3);
         ov1=ov1+double(of1).^2; ov2=ov2+double(tf2).^2; ov3=ov3+double(of3).^2;
         
         tt1_corr=tt1_corr+double(tfl_corr); tt2_corr=tt2_corr+double(tf2_corr); tt3_corr=tt3_corr+double(tf3_corr);
         tv1_corr=tv1_corr+double(tfl_corr).^2; tv2_corr=tv2_corr+double(tf2_corr).^2; tv3_corr=tv3_corr+double(tf3_corr).^2;
         ot1_corr=ot1_corr+double(of1_corr); ot2_corr=ot2_corr+double(tf2_corr); ot3_corr=ot3_corr+double(of3_corr);
         ov1_corr=ov1_corr+double(of1_corr).^2; ov2_corr=ov2_corr+double(tf2_corr).^2; ov3_corr=ov3_corr+double(of3_corr).^2;

         tf1=double(tf1); tf2=double(tf2); tf3=double(tf3);
         tf1=tf1/1; tf1=tf1-min(tf1(:)); tf1=tf1/max(tf1(:));
         tf2=tf2/1; tf2=tf2-min(tf2(:)); tf2=tf2/max(tf2(:));
         tf3=tf3/1; tf3=tf3-min(tf3(:)); tf3=tf3/max(tf3(:));
         
         tf1_corr=double(tfl_corr); tf2=double(tf2_corr); tf3_corr=double(tf3_corr);
         tf1_corr=tf1_corr/1; tf1_corr=tf1_corr-min(tf1_corr(:)); tf1_corr=tf1_corr/max(tf1_corr(:));
         tf2_corr=tf2_corr/1; tf2_corr=tf2_corr-min(tf2_corr(:)); tf2_corr=tf2_corr/max(tf2_corr(:));
         tf3_corr=tf3_corr/1; tf3_corr=tf3_corr-min(tf3_corr(:)); tf3_corr=tf3_corr/max(tf3_corr(:));


%          tt1=tt1+double(tf1); tt2=tt2+double(tf2); tt3=tt3+double(tf3);
%          tv1=tv1+double(tf1).^2; tv2=tv2+double(tf2).^2; tv3=tv3+double(tf3).^2;
%          ot1=ot1+double(of1); ot2=ot2+double(tf2); ot3=ot3+double(of3);
%          ov1=ov1+double(of1).^2; ov2=ov2+double(tf2).^2; ov3=ov3+double(of3).^2;

         tf=zeros(size(tf1,1),size(tf1,2),3,'uint8'); tf(:,:,1)=tf1(:,:)*255;tf(:,:,2)=tf2(:,:)*255;tf(:,:,3)=tf3(:,:)*255;
         imwrite(tf,[rps 'res_' fa.name]);
        end;

        % ******************** Normal images ************************
        tt=zeros(magX*2+1, magY*2+1, 3);
        ot=tt;
        tv=tt;
        ov=tt; 
        
        tv1=( (tv1-tt1.^2)/numel(flp) )/(numel(flp)-1); tv1=tv1-min(tv1(:)); tv1=tv1/max(tv1(:)); tv1=1-tv1;
        tv2=( (tv2-tt2.^2)/numel(flp) )/(numel(flp)-1); tv2=tv2-min(tv2(:)); tv2=tv2/max(tv2(:)); tv2=1-tv2;
        tv3=( (tv3-tt3.^2)/numel(flp) )/(numel(flp)-1); tv3=tv3-min(tv3(:)); tv3=tv3/max(tv3(:)); tv3=1-tv3;
        tv(:,:,1)=tv1; tv(:,:,2)=tv2; tv(:,:,3)=tv3;
        
        ov1=( (ov1-ot1.^2)/numel(flp) )/(numel(flp)-1); ov1=ov1-min(ov1(:)); ov1=ov1/max(ov1(:)); ov1=1-ov1;
        ov2=( (ov2-ot2.^2)/numel(flp) )/(numel(flp)-1); ov2=ov2-min(ov2(:)); ov2=ov2/max(ov2(:)); ov2=1-ov2;
        ov3=( (ov3-ot3.^2)/numel(flp) )/(numel(flp)-1); ov3=ov3-min(ov3(:)); ov3=ov3/max(ov3(:)); ov3=1-ov3;
        ov(:,:,1)=ov1; ov(:,:,2)=ov2; ov(:,:,3)=ov3;

        tt1=tt1/numel(flp); tt1=tt1-min(tt1(:)); tt1=tt1/max(tt1(:));
        tt2=tt2/numel(flp); tt2=tt2-min(tt2(:)); tt2=tt2/max(tt2(:));
        tt3=tt3/numel(flp); tt3=tt3-min(tt3(:)); tt3=tt3/max(tt3(:));
        tt(:,:,1)=tt1; tt(:,:,2)=tt2; tt(:,:,3)=tt3;

        ot1=ot1/numel(flp); ot1=ot1-min(ot1(:)); ot1=ot1/max(ot1(:));
        ot2=ot2/numel(flp); ot2=ot2-min(ot2(:)); ot2=ot2/max(ot2(:));
        ot3=ot3/numel(flp); ot3=ot3-min(ot3(:)); ot3=ot3/max(ot3(:));
        ot(:,:,1)=ot1; ot(:,:,2)=ot2; ot(:,:,3)=ot3;

        m=colormap(jet);
        m1=[m(:,2), m(:,1), m(:,3)];
        imwrite(tt,[rres 'ALIGNED_all_mean.bmp']);
        imwrite(gray2ind(tt1,64),m1,[rres 'ALIGNED_actin_mean_colormap.bmp']);
        imwrite(gray2ind(tt2,64),m1,[rres 'ALIGNED_pattern_mean_colormap.bmp']);
        imwrite(gray2ind(tt3,64),m1,[rres 'ALIGNED_nuclei_mean_colormap.bmp']);
        
        imwrite(tv,[rres 'ALIGNED_all_std.bmp']);
        imwrite(gray2ind(tv1,64),m1,[rres 'ALIGNED_actin_std_colormap.bmp']);
        imwrite(gray2ind(tv2,64),m1,[rres 'ALIGNED_pattern_std_colormap.bmp']);
        imwrite(gray2ind(tv3,64),m1,[rres 'ALIGNED_nuclei_std_colormap.bmp']);        
        
        imwrite(ot,[rres 'ALIGNED_all_mean.bmp']);
        imwrite(gray2ind(ot1,64),m1,[rres 'ALIGNED_actin_stackfocus_mean_colormap.bmp']);
        imwrite(gray2ind(ot2,64),m1,[rres 'ALIGNED_pattern_stackfocus_mean_colormap.bmp']);
        imwrite(gray2ind(ot3,64),m1,[rres 'ALIGNED_nuclei_stackfocus_mean_colormap.bmp']);
        
        imwrite(tv,[rres 'ALIGNED_all_std.bmp']);
        imwrite(gray2ind(ov1,64),m1,[rres 'ALIGNED_actin_stackfocus_std_colormap.bmp']);
        imwrite(gray2ind(ov2,64),m1,[rres 'ALIGNED_pattern_stackfocus_std_colormap.bmp']);
        imwrite(gray2ind(ov3,64),m1,[rres 'ALIGNED_nuclei_stackfocus_std_colormap.bmp']);       
        
        % *************************** Corrected images ********************
        tt_corr=zeros(magX*2+1, magY*2+1, 3);
        ot_corr=tt_corr;
        tv_corr=tt_corr;
        ov_corr=tt_corr; 
        
        tv1_corr=( (tv1_corr-tt1_corr.^2)/numel(flp) )/(numel(flp)-1); tv1_corr=tv1_corr-min(tv1_corr(:)); tv1_corr=tv1_corr/max(tv1_corr(:)); tv1_corr=1-tv1_corr;
        tv2_corr=( (tv2_corr-tt2_corr.^2)/numel(flp) )/(numel(flp)-1); tv2_corr=tv2_corr-min(tv2_corr(:)); tv2_corr=tv2_corr/max(tv2_corr(:)); tv2_corr=1-tv2_corr;
        tv3_corr=( (tv3_corr-tt3_corr.^2)/numel(flp) )/(numel(flp)-1); tv3_corr=tv3_corr-min(tv3_corr(:)); tv3_corr=tv3_corr/max(tv3_corr(:)); tv3_corr=1-tv3_corr;
        tv_corr(:,:,1)=tv1_corr; tv_corr(:,:,2)=tv2_corr; tv_corr(:,:,3)=tv3_corr;
        
        ov1_corr=( (ov1_corr-ot1_corr.^2)/numel(flp) )/(numel(flp)-1); ov1_corr=ov1_corr-min(ov1_corr(:)); ov1_corr=ov1_corr/max(ov1_corr(:)); ov1_corr=1-ov1_corr;
        ov2_corr=( (ov2_corr-ot2_corr.^2)/numel(flp) )/(numel(flp)-1); ov2_corr=ov2-min(ov2_corr(:)); ov2_corr=ov2_corr/max(ov2_corr(:)); ov2_corr=1-ov2_corr;
        ov3_corr=( (ov3_corr-ot3_corr.^2)/numel(flp) )/(numel(flp)-1); ov3_corr=ov3_corr-min(ov3_corr(:)); ov3_corr=ov3_corr/max(ov3_corr(:)); ov3=1-ov3_corr;
        ov_corr(:,:,1)=ov1_corr; ov_corr(:,:,2)=ov2_corr; ov_corr(:,:,3)=ov3_corr;

        tt1_corr=tt1_corr/numel(flp); tt1_corr=tt1_corr-min(tt1_corr(:)); tt1_corr=tt1_corr/max(tt1_corr(:));
        tt2_corr=tt2_corr/numel(flp); tt2_corr=tt2_corr-min(tt2_corr(:)); tt2_corr=tt2_corr/max(tt2_corr(:));
        tt3_corr=tt3_corr/numel(flp); tt3_corr=tt3_corr-min(tt3_corr(:)); tt3_corr=tt3_corr/max(tt3_corr(:));
        tt_corr(:,:,1)=tt1_corr; tt_corr(:,:,2)=tt2_corr; tt_corr(:,:,3)=tt3_corr;

        ot1_corr=ot1_corr/numel(flp); ot1_corr=ot1_corr-min(ot1_corr(:)); ot1_corr=ot1_corr/max(ot1_corr(:));
        ot2_corr=ot2_corr/numel(flp); ot2_corr=ot2_corr-min(ot2_corr(:)); ot2_corr=ot2_corr/max(ot2_corr(:));
        ot3_corr=ot3_corr/numel(flp); ot3_corr=ot3_corr-min(ot3_corr(:)); ot3_corr=ot3_corr/max(ot3_corr(:));
        ot_corr(:,:,1)=ot1_corr; ot_corr(:,:,2)=ot2_corr; ot_corr(:,:,3)=ot3_corr;

        m=colormap(jet);
        m1=[m(:,2), m(:,1), m(:,3)];
        imwrite(tt_corr,[rres 'ALIGNED_all_mean_corr.bmp']);
        imwrite(gray2ind(tt1_corr,64),m1,[rres 'ALIGNED_actin_mean_colormap_corr.bmp']);
        imwrite(gray2ind(tt2_corr,64),m1,[rres 'ALIGNED_pattern_mean_colormap_corr.bmp']);
        imwrite(gray2ind(tt3_corr,64),m1,[rres 'ALIGNED_nuclei_mean_colormap_corr.bmp']);
        
        imwrite(tv_corr,[rres 'ALIGNED_all_std_corr.bmp']);
        imwrite(gray2ind(tv1_corr,64),m1,[rres 'ALIGNED_actin_std_colormap_corr.bmp']);
        imwrite(gray2ind(tv2_corr,64),m1,[rres 'ALIGNED_pattern_std_colormap_corr.bmp']);
        imwrite(gray2ind(tv3_corr,64),m1,[rres 'ALIGNED_nuclei_std_colormap_corr.bmp']);        
        
        imwrite(ot_corr,[rres 'ALIGNED_all_mean_corr.bmp']);
        imwrite(gray2ind(ot1_corr,64),m1,[rres 'ALIGNED_actin_stackfocus_mean_colormap_corr.bmp']);
        imwrite(gray2ind(ot2_corr,64),m1,[rres 'ALIGNED_pattern_stackfocus_mean_colormap_corr.bmp']);
        imwrite(gray2ind(ot3_corr,64),m1,[rres 'ALIGNED_nuclei_stackfocus_mean_colormap_corr.bmp']);
        
        imwrite(tv_corr,[rres 'ALIGNED_all_std_corr.bmp']);
        imwrite(gray2ind(ov1_corr,64),m1,[rres 'ALIGNED_actin_stackfocus_std_colormap_corr.bmp']);
        imwrite(gray2ind(ov2_corr,64),m1,[rres 'ALIGNED_pattern_stackfocus_std_colormap_corr.bmp']);
        imwrite(gray2ind(ov3_corr,64),m1,[rres 'ALIGNED_nuclei_stackfocus_std_colormap_corr.bmp']);       
        
end