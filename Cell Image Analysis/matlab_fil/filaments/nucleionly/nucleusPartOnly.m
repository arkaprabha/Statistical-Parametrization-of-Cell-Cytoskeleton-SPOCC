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

function [ndI,dI] = nucleusPartOnly( input_file ),
		margin=20;

		processNuclei=exists(input_file);

		if (processNuclei==1),
		       cI=imread(input_file);

                       dI=cI;
                       
                       lnn=[]; 
                       tnn=dI(1:margin,:); lnn=[lnn, unique(tnn(:))'];
                       tnn=dI(:, 1:margin); lnn=[lnn, unique(tnn(:))'];
                       tnn=dI((end-margin+1):end,:); lnn=[lnn, unique(tnn(:))'];
                       tnn=dI(:,(end-margin+1):end); lnn=[lnn, unique(tnn(:))'];

                       ndI=dI; lnn(lnn == 0)=[];
                       for nn=1:numel(lnn), ndI(dI == lnn(nn))=0; end;
                  else
                       ndI=I*0;
                       dI=I*0;
                  end;

end;