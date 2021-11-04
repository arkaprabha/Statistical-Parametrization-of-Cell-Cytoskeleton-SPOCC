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

function [ np_isNormal, np_pisNormal, np_m,np_s,np_mi,np_ma, ...
           ap_isNormal, ap_pisNormal, ap_m,ap_s,ap_mi,ap_ma] ...   
= single_summary( ActinFolder )

  rres=[ActinFolder '\..\res\'];
  
  centers_data=[rres 'centers_data.csv'];
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np=str2double(C{8}(2:end));
  end;

  spreading_data=[rres 'spreading_data.csv'];
  if (exist(spreading_data, 'file')),
        fileID=fopen(spreading_data,'r');
        C=textscan(fileID, '%s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        data_ap=str2double(C{2}(2:end));
        data_ap=data_ap/1000.0;  
  end;

  [np_isNormal,np_pisNormal]=kstest( data_np(:) ); np_m=mean(data_np(:)); np_s=std( data_np(:) );  np_mi=min(data_np(:)); np_ma=max(data_np(:));
  [ap_isNormal,ap_pisNormal]=kstest( data_ap(:) ); ap_m=mean(data_ap(:)); ap_s=std( data_ap(:) );  ap_mi=min(data_ap(:)); ap_ma=max(data_ap(:));

  fileID=fopen([rres '\single_summary.csv'],'w');
  fprintf(fileID, '%i,%.4f,%.2f,%.2f,%.2f,%.2f\n', np_isNormal, np_pisNormal, np_m, np_s, np_mi, np_ma);
  fprintf(fileID, '%i,%.4f,%.2f,%.2f,%.2f,%.2f\n', ap_isNormal, ap_pisNormal, ap_m, ap_s, ap_mi, ap_ma);
  fclose(fileID);
end
