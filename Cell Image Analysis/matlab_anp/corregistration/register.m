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

function [] = register(folder, file ),
  magX=500; magY=500;

  rimgfile=0;
  fl=dir([folder '\..\template*.bmp']);
  if (isempty(fl)), 
     fl=dir([folder '\..\template*.*']);
     if (~isempty(fl)),
       im=imread( [folder '\..\' fl(1).name] ); im=double(im); im=im-min(im(:)); im=im/max(im(:));
       imwrite(uint8(im*255), [folder '\..\' fl(1).name '.bmp']);
       templatefile=[fl(1).name '.bmp'];
       rimgfile=[folder '\..\' fl(1).name '.bmp'];
     end;
  else
     templatefile=fl(1).name;
     rimgfile=[folder '\..\' fl(1).name];
  end;
  
  p=strfind(file,'_');
  if (numel(p) == 1),
    type=['_' file(1:p-1)];
  else
    type='';
  end;
  
  if ((rimgfile) & (exist([folder '\..\npf' type '.txt'], 'file'))),
      
      % Data of the pattern centroid available ?
      rres = [folder '\..\res\'];
      [tx, ty, mx, my]=get_displacement( templatefile(10:end-4), file, [rres 'centers_data.csv'] );
      
%      tx=0; ty=0; mx=0; my=0;
%       if (exist([rres 'centers_data.csv'], 'file')),
%         fileID=fopen([rres 'centers_data.csv'],'r');
%         C=textscan(fileID, '%s %s %s %s %s %s %s %s %s %s','delimiter', ',', 'EmptyValue', -Inf);
%         fclose(fileID);
%         
%         actinF=C{10};
%         tf=templatefile(10:end-4);
%         % Locate template and actual file
%         for i=2:numel(actinF),
%           if (strcmp(actinF{i},tf)),
%             tx=str2double(C{4}{i}); ty=str2double(C{5}{i});
%           else if (strcmp(actinF{i},file)),
%             mx=str2double(C{4}{i}); my=str2double(C{5}{i});
%           end;
%         end;
%       end;
      
      cuadimg=[folder '\..\cuad.bmp'];
      ffile=[folder '\' file];
      res=[folder '\res\']; if (~exist(res, 'dir')), mkdir(res); end;

      rres=[res '\registered\'];
      if (~exist(rres, 'dir')), mkdir(rres); end; 

      rtmp=[rres '\tmp\'];
      if (~exist(rtmp, 'dir')), mkdir(rtmp); end; 

            tim=imread(ffile);

            tim=double(tim-min(tim(:))); tim=tim/max(tim(:)); tim=uint8(tim*255);
            
            % Displace it here according to tx-mx and ty-mx
            if (abs(tx-mx)+abs(ty-my) > 0),
              %cx=magX+1; cy=magX+1;
              
              % Template
              t=imread(rimgfile);
              btim=apply_displacement( magX, magY, tx, ty, t(:,:,1) );
%               sy=size(t,1); sx=size(t,2);
%               lx=tx-magX; rx=tx+magX; if (lx < 1), lx=1; end; if (rx > sx), rx=sx; end; lx=round(lx); rx=round(rx);
%               ly=ty-magY; ry=ty+magY; if (ly < 1), ly=1; end; if (ry > sy), ry=sy; end; ly=round(ly); ry=round(ry);
% 
%               btim=zeros(magX*2+1, magY*2+1, 'uint8');
%               btim( (cy-(ty-ly)):(cy+(ry-ty)), (cx-(tx-lx)):(cx+(rx-tx)) )=t(ly:ry, lx:rx);
              templatefile=['t_' templatefile];
              imwrite(btim,[folder '\..\' templatefile]);
              rimgfile=[folder '\..\' templatefile];
              
              % This image
                tim=apply_displacement( magX, magY, mx, my, tim(:,:,1) );
%               sy=size(tim,1); sx=size(tim,2);
%               lx=mx-magX; rx=mx+magX; if (lx < 1), lx=1; end; if (rx > sx), rx=sx; end; lx=round(lx); rx=round(rx);
%               ly=my-magY; ry=my+magY; if (ly < 1), ly=1; end; if (ry > sy), ry=sy; end; ly=round(ly); ry=round(ry);
% 
%               btim=zeros(magX*2+1, magY*2+1, 'uint8');
%               btim( (cy-(my-ly)):(cy+(ry-my)), (cx-(mx-lx)):(cx+(rx-mx)) )=tim(ly:ry, lx:rx);
%               tim=btim;
            end;
              
            rgbimg=zeros(size(tim,1),size(tim,2),3,'uint8'); rgbimg(:,:,1)=tim(:,:,1);
            imwrite(rgbimg, [rtmp '\' file '.bmp']);

            if (~exist([rtmp file '\'], 'dir')),
              mkdir([rtmp file '\']);
            end;

            % Init
             if (1),
               sx=size(tim,1); sy=size(tim,2);
               percent = 0.1;
               numPoints = round(percent*sx*sy);

               lP=round(rand(numPoints,1)*(sx*sy-1))+1;
               [x,y]=ind2sub([sx, sy], lP);
               x(x == 0)=1; y(y==0)=1;

               fileID = fopen([rtmp '\points.txt'],'w');
               fprintf(fileID, 'point\n');
               fprintf(fileID, '%i\n', numPoints);
               for i=1:numPoints,
                 fprintf(fileID, '%i %i\n', x(i), y(i));
               end;
               fclose(fileID);
               %ts=ones([sx,sy], 'uint8')*255; ts(lP)=0;
               %allNorm = sqrt(sum(abs([1 2; 3 4]).^2,2)); % Displacement matri

               cimg=zeros([sx, sy], 'uint8');
               l=10:50:sx; l=[l, l+1]; t=repmat( (1:sy), [numel(l) 1]); tt=repmat(l, [1 sy]); cimg( tt(:), t(:) ) = 255;
               c=10:50:sy; c=[c, c+1]; t=repmat( (1:sx), [numel(c) 1]); tt=repmat(c, [1 sy]); cimg( t(:), tt(:) ) = 255;
               cimg=repmat(cimg, [1 1 3]);
               imwrite(cimg, cuadimg);
             end;


            % Inverse
            system(['elastix -m "' rimgfile '" -f "' rtmp file '.bmp" -out "' rtmp file '" -p "' folder '\..\npf' type '.txt"']);
            if (exist([rtmp file '\result.0.mhd'], 'file')),
              im=metaImageRead([rtmp file '\result.0.mhd']);im=uint8(double(im)/double(max(im(:)))*255);
            else
              im=zeros(size(tim),'uint8');
            end;
            imwrite(uint8(im), [rres 'inverse_' file(1:end-4) '_registered.bmp']);

            system(['transformix -in "' cuadimg '"  -out "' rtmp file '" -tp "' rtmp file '\TransformParameters.0.txt"'])
            if (exist([rtmp file '\result.mhd'], 'file')),
              im=metaImageRead([rtmp file '\result.mhd']);im=uint8(double(im)/double(max(im(:)))*255);
            else
              im=zeros(size(tim),'uint8');
            end;
            imwrite(uint8(im), [rres 'inverse_transformed_' file(1:end-4) '.bmp']);

            system(['transformix -def "' [rtmp '\points.txt'] '"  -out "' rtmp file '" -tp "' rtmp file '\TransformParameters.0.txt"'])
            if (exist([rtmp file '\outputpoints.txt'], 'file')),
              movefile([rtmp file '\outputpoints.txt'], [rres '\inverse_' file '.txt']);
            end;        

            % Normal
            system(['elastix -f "' rimgfile '" -m "' rtmp file '.bmp" -out "' rtmp file '" -p "' folder '\..\npf' type '.txt']);
            if (exist([rtmp file '\result.0.mhd'], 'file')),
              im=metaImageRead([rtmp file '\result.0.mhd']);im=uint8(double(im)/double(max(im(:)))*255);
            else
              im=zeros(size(tim),'uint8');
            end;
            imwrite(uint8(im), [rres file(1:end-4) '_registered.bmp']);

            system(['transformix -in "' cuadimg '"  -out "' rtmp file '" -tp "' rtmp file '\TransformParameters.0.txt"'])
            if (exist([rtmp file '\result.mhd'], 'file')),
              im=metaImageRead([rtmp file '\result.mhd']);im=uint8(double(im)/double(max(im(:)))*255);
            else
              im=zeros(size(tim),'uint8');
            end;
            imwrite(uint8(im), [rres 'transformed_' file(1:end-4) '.bmp']);

            system(['transformix -def "' [rtmp '\points.txt'] '"  -out "' rtmp file '" -tp "' rtmp file '\TransformParameters.0.txt"'])
            if (exist([rtmp file '\outputpoints.txt'], 'file')),
              movefile([rtmp file '\outputpoints.txt'], [rres '\..\' file '.txt']);
            end;
  else
    fprintf('Error: no template or parameters file available(s)\n');
  end;
end