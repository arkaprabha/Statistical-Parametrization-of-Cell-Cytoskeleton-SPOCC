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

function [] = pairwise_summary( dataFolder, cond1, cond2)
  
  rres1=[dataFolder '\' cond1 '\res\'];
  rres2=[dataFolder '\' cond2 '\res\'];
  
    
  centers_data=[rres1 'centers_data.csv'];
  annotated_centers=[rres1 'annotated_centers_data.csv'];  
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np1=str2double(C{8}(2:end));
        if (exist(annotated_centers, 'file')),
          ln=C{10}(2:end);
          fileID=fopen(annotated_centers,'r');
          C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
          fclose(fileID);
          a_data_np=(C{10}(2:end)); a_ln=C{1}(2:end);
          for i=1:numel(a_ln),
            fn=[a_ln{i}(2:end-1) '.bmp']; vn=a_data_np{i}(2:end-1);
            ii=find(~cellfun(@isempty,strfind(ln, fn)));
            if (ii > 0),
              data_np1(ii)=str2double(vn);
            end;
          end;
        end;
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
  annotated_centers=[rres2 'annotated_centers_data.csv'];  
  if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        data_np2=str2double(C{8}(2:end));
        if (exist(annotated_centers, 'file')),
          ln=C{10}(2:end);
          fileID=fopen(annotated_centers,'r');
          C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
          fclose(fileID);
          a_data_np=(C{10}(2:end)); a_ln=C{1}(2:end);
          for i=1:numel(a_ln),
            fn=[a_ln{i}(2:end-1) '.bmp']; vn=a_data_np{i}(2:end-1);
            ii=find(~cellfun(@isempty,strfind(ln, fn)));
            if (ii > 0),
              data_np2(ii)=str2double(vn);
            end;
          end;
        end;
  end;

  spreading_data=[rres2 'spreading_data.csv'];
  if (exist(spreading_data, 'file')),
        fileID=fopen(spreading_data,'r');
        C=textscan(fileID, '%s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        data_ap2=str2double(C{2}(2:end));
        data_ap2=data_ap2/1000.0;  
  end;
  
  % Levene
  [vhn,vpn]=Levenetest([data_np1(:) ones(numel(data_np1),1); data_np2(:) ones(numel(data_np2),1)+1], 0.05);
  [vha,vpa]=Levenetest([data_ap1(:) ones(numel(data_ap1),1); data_ap2(:) ones(numel(data_ap2),1)+1], 0.05);
  
  % t-Test
  if (vhn),
    [hn,pn]=ttest2(data_np1, data_np2, 0.05, 'both', 'equal');
  else
    [hn,pn]=ttest2(data_np1, data_np2, 0.05, 'both', 'unequal');
  end;
  
  if (vha),
    [ha,pa]=ttest2(data_ap1, data_ap2, 0.05, 'both', 'equal');
  else
    [ha,pa]=ttest2(data_ap1, data_ap2, 0.05, 'both', 'unequal');
  end;
  fileID=fopen([dataFolder '\pairwise_' cond1 '_' cond2 '.csv'], 'w');
  fprintf(fileID,'Diff variances P-N (h), Diff variances P-N (p), Diff variances Area (h), Diff variances Area (p), Diff P-N (h), Diff P-N (p), Diff Area (h), Diff Area (p)\n');
  fprintf(fileID, '%i,%.4f,%i,%.4f,%i,%.4f,%i,%.4f\n', ~vhn, vpn, ~vha, vpa, hn,pn, ha,pa );
  fclose(fileID);
end