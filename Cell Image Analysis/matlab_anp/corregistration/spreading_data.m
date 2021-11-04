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

function [] = spreading_data( ActinFolder )
  
  filesActin=dir([ActinFolder '\res\*.txt']);
  rres=[ActinFolder '\..\res\'];
  
  oID=fopen([rres 'spreading_data.csv'], 'w');
  fprintf(oID,'Spreading value, Mean, Std, Actin File\n');
  for f=1:numel(filesActin),
    fileID=fopen([ActinFolder '\res\' filesActin(f).name],'r');
    C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter', ' ', 'EmptyValue', -Inf);
    fclose(fileID);
    %tx1=str2double(C{29}); ty1=str2double(C{30});
    
    p1x=str2double(C{5}); p1y=str2double(C{6});
    d1x=str2double(C{17}); d1y=str2double(C{18});

    fileID=fopen([ActinFolder '\res\registered\inverse_' filesActin(f).name],'r');
    C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s','delimiter', ' ', 'EmptyValue', -Inf);
    fclose(fileID);
    %tx2=str2double(C{29}); ty2=str2double(C{30});
    
    p2x=str2double(C{5}); p2y=str2double(C{6});
    d2x=str2double(C{17}); d2y=str2double(C{18});
    
%     n1=sqrt( tx1.^2 + ty1.^2 ); n2=sqrt( tx2.^2 + ty2.^2 );
%     
%     [~,p1]=min(n1); vx1=tx1(p1); vy1=ty1(p1);
%     tx1=tx1-vx1; ty1=ty1-vy1;
%     
%     [~,p2]=min(n2); vx2=tx1(p2); vy2=ty2(p2);
%     tx2=tx2-vx2; ty2=ty2-vy2;
    
    %nn1=sqrt( tx1.^2 + ty1.^2 ); nn2=sqrt( tx2.^2 + ty2.^2 );

    r1=round(rand(numel(p1x),1)*(numel(p1x)-1)+1); dn1=sqrt( (p1x-p1x(r1)).^2 + (p1y-p1y(r1)).^2 ); nn1=dn1-sqrt( (d1x-d1x(r1)).^2 + (d1y-d1y(r1)).^2 );%nn1=(dn1+sqrt( (d1x-d1x(r1)).^2 + (d1y-d1y(r1)).^2 ))./dn1;
    r2=round(rand(numel(p2x),1)*(numel(p2x)-1)+1); dn2=sqrt( (p2x-p2x(r2)).^2 + (p2y-p2y(r2)).^2 ); nn2=dn2-sqrt( (d2x-d2x(r2)).^2 + (d2y-d2y(r2)).^2 );%nn2=(dn2+sqrt( (d2x-d2x(r2)).^2 + (d2y-d2y(r2)).^2 ))./dn2;
    
    nf=( max(nn1)+max(nn2) )/2;
    fprintf(oID, '%.4f,%.4f,%.4f,%s\n', nf, mean([nn1; nn2]), std([nn1; nn2]), filesActin(f).name(1:end-4));
  end;
  fclose(oID);
end
