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

     if (exist(centers_data, 'file')),
        fileID=fopen(centers_data,'r');
        C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
        fclose(fileID);
        
        actinF=C{10};
        p1=0; p2=0;
        % Locate template and actual file
        for i=2:numel(actinF),
          if (strcmp(actinF{i},factin_name1)),
              p1=1;
            tx=str2double(C{4}{i}); ty=str2double(C{5}{i});
          end;
          if (strcmp(actinF{i},factin_name2)),
              p2=1;
            mx=str2double(C{4}{i}); my=str2double(C{5}{i});
          end;
        end;
        if (p1*p2 == 0),
          fprintf('.');
        end;
     else
       tx=0; ty=0; mx=0; my=0;
     end;

end

