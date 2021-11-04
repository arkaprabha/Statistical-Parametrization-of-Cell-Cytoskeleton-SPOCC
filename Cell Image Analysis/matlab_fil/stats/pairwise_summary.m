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

function [] = pairwise_summary( dataFolder1, dataFolder2, cond1, cond2 )
  
  %rres1=[dataFolder1 '\' cond1 '\res\'];
  %rres2=[dataFolder '\' cond2 '\res\'];
  
  centers_data1=[dataFolder1 'filaments_data.csv'];
  if (exist(centers_data1, 'file')),
        fileID=fopen(centers_data1,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np1=str2double(C{1}(2:end))/1000;
  end;

  centers_data2=[dataFolder2 'filaments_data.csv'];
  if (exist(centers_data2, 'file')),
        fileID=fopen(centers_data2,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np2=str2double(C{1}(2:end))/1000;
  end;

  if (exist(centers_data1,'file') && exist(centers_data2,'file')),
      % Levene
      [vhn,vpn]=Levenetest([data_np1(:) ones(numel(data_np1),1); data_np2(:) ones(numel(data_np2),1)+1], 0.05);

      % t-Test
      if (vhn),
        [hn,pn]=ttest2(data_np1, data_np2, 0.05, 'both', 'equal');
      else
        [hn,pn]=ttest2(data_np1, data_np2, 0.05, 'both', 'unequal');
      end;

      fileID=fopen([dataFolder1 '\..\..\pairwise_' cond1 '_' cond2 '_filaments.csv'], 'w');
      fprintf(fileID,'Diff variances Filaments (h), Diff variances Filaments (p), Diff Filaments (h), Filaments (p)\n');
      fprintf(fileID, '%i,%.4f,%i,%.4f\n', ~vhn, vpn, hn,pn );
      fclose(fileID);
  end;
end