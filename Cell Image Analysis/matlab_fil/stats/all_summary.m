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

function [] = all_summary( dataFolder, cond1, cond2, cond3 )
  
  rres1=[dataFolder '\' cond1 '\res\'];
  rres2=[dataFolder '\' cond2 '\res\'];
  rres3=[dataFolder '\' cond3 '\res\'];
  
    
  centers_data=[rres1 'centers_data.csv'];
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np1=str2double(C{8}(2:end));
  end;

  spreading_data=[rres1 'spreading_data.csv'];
  if (exist(spreading_data, 'file')),
        fileID=fopen(spreading_data,'r');
        C=textscan(fileID, '%s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        data_ap1=str2double(C{2}(2:end));
        data_ap1=data_ap1/1000.0;  
  end;

  
  centers_data=[rres2 'centers_data.csv'];
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np2=str2double(C{8}(2:end));
  end;

  spreading_data=[rres2 'spreading_data.csv'];
  if (exist(spreading_data, 'file')),
        fileID=fopen(spreading_data,'r');
        C=textscan(fileID, '%s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        data_ap2=str2double(C{2}(2:end));
        data_ap2=data_ap2/1000.0;  
  end;

  centers_data=[rres3 'centers_data.csv'];
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np3=str2double(C{8}(2:end));
  end;

  spreading_data=[rres3 'spreading_data.csv'];
  if (exist(spreading_data, 'file')),
        fileID=fopen(spreading_data,'r');
        C=textscan(fileID, '%s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        data_ap3=str2double(C{2}(2:end));
        data_ap3=data_ap3/1000.0;  
  end;
  
  y=[data_ap1(:)', data_ap2(:)', data_ap3(:)'];
  g=[ones( 1, numel(data_ap1) ), ones( 1, numel(data_ap2) )+1, ones( 1, numel(data_ap3) )+2];
  anova1(y,g);
  
  y=[data_np1(:)', data_np2(:)', data_np3(:)'];
  g=[ones( 1, numel(data_np1) ), ones( 1, numel(data_np2) )+1, ones( 1, numel(data_np3) )+2];
  anova1(y,g);

end