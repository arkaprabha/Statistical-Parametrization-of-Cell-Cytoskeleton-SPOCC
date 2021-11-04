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

function [ tx, ty, mx, my ] = get_displacement( factin_name1, factin_name2, centers_data )
     tx=0; ty=0; mx=0; my=0;
     if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        % File name
        p=10;
        for i=1:length(C),
          if ((strcmp(C{i}{1}, 'Pattern File')) || (strcmp(C{i}{1}, '"imageName"'))),
            p=i; break;
          end;
        end;
        
        % Nucleus X
        px=4;
        for i=1:length(C),
          if ((strcmp(C{i}{1}, 'Pattern X center')) || (strcmp(C{i}{1}, '"patternX"'))),
            px=i; break;
          end;
        end;
        
        % Nucleus Y
        py=5;
        for i=1:length(C),
          if ((strcmp(C{i}{1}, 'Pattern Y center')) || (strcmp(C{i}{1}, '"patternY"'))),
            py=i; break;
          end;
        end;
        
        actinF=C{p};
        p1=0; p2=0;
        % Locate template and actual file
        for i=2:numel(actinF),
          cfile=actinF{i}; efile=cfile(end-3:end);
          if (strcmp(efile,'.bmp')), 
            cfile=cfile(1:end-4); ii=1;
          else
            ii = 2;
            cfile = cfile(ii:(end-ii+1));            
          end;
          if (strcmp(cfile,factin_name1)),
              p1=1;
            tx=str2double(C{px}{i}(ii:(end-ii+1))); ty=str2double(C{py}{i}(ii:(end-ii+1)));
          end;
          if (strcmp(cfile,factin_name2)),
              p2=1;
            mx=str2double(C{px}{i}(ii:(end-ii+1))); my=str2double(C{py}{i}(ii:(end-ii+1)));
          end;
        end;
        if (p1*p2 == 0),
          fprintf('.');
        end;
     else
       tx=0; ty=0; mx=0; my=0;
     end;

end

