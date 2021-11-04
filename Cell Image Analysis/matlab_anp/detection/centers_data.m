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

function [] = centers_data( DAPIFolder, PatternFolder, ActinFolder, verbose )
  addpath('../deepimg');

  magX=500; magY=500;

  filesDapi=dir([DAPIFolder '\res\*.bmp']);
  filesPattern=dir([PatternFolder '\res\*.bmp']);
  %filesActin=dir([ActinFolder '\*.txt']);
  filesActin=dir([ActinFolder '\*.tif']);
  
  rres = [ActinFolder '\..\res\'];
  if (~exist(rres, 'dir')), mkdir(rres); end; 
  fileID = fopen([rres 'centers_data.csv'],'w');
  
  fprintf(fileID, 'Nucleus X center, Nucleus Y center, Nucleus radious, Pattern X center, Pattern Y center, Nucleus area, Pattern area, Nucleus-Pattern distance, Nuclei File, Pattern File, Actin File\n');
  for f=1:numel(filesDapi),
    rI=logical(imread([DAPIFolder '\res\' filesDapi(f).name]));
    r=regionprops(rI, 'centroid', 'area', 'majoraxislength', 'minoraxislength');
    t=r(:).Area; [~,b]=max(t); r=r(b);
    
    xc=zeros(numel(r),1); yc=zeros(numel(r),1);
    
    pI=logical(imread([PatternFolder '\res\' filesPattern(f).name]));
    [sy,sx]=size(pI);
    for i=1:numel(r),
      xc(i)=r(i).Centroid(1); yc(i)=r(i).Centroid(2);
      radius = (r(i).MajorAxisLength(1)+r(i).MinorAxisLength(1))/2;

      
      lx=xc(i)-magX; rx=xc(i)+magX; if (lx < 1), lx=1; end; if (rx > sx), rx=sx; end; lx=round(lx); rx=round(rx);
      ly=yc(i)-magY; ry=yc(i)+magY; if (ly < 1), ly=1; end; if (ry > sy), ry=sy; end; ly=round(ly); ry=round(ry);
      
      t=pI(ly:ry, lx:rx);
      rp=regionprops(t, 'centroid', 'area');
      if (numel(rp) >= 1),
        si=1;
        for ii=2:numel(rp),
          if (rp(si).Area(1) <= rp(ii).Area(1)), si=ii; end; 
        end;

        [npx, npy]=get_centroid(pI(ly:ry, lx:rx), rp(si).Centroid(1), rp(si).Centroid(2)); 
        
        if (sqrt(abs(npx-xc(i))^2+abs(npy-yc(i))^2) <= sqrt(magX^2+magY^2)),
             npx=npx+lx; npy=npy+ly;
              fprintf(fileID, '%.2f,%.2f,%.2f,%i,%i,%i,%i,%.2f,%s,%s,%s\n', xc(i), yc(i), radius, npx, npy, r(i).Area(1), rp(si).Area(1), sqrt( (xc(i)-npx)^2 + (yc(i)-npy)^2 ),  filesDapi(f).name, filesPattern(f).name, filesActin(f).name);        

              [nimg]=(t_deep_tifread([DAPIFolder '\' filesDapi(f).name(1:end-4)], 1)); nimg=double(nimg);
              nimg=(nimg)-min(nimg(:)); nimg=nimg/max(nimg(:));
              pimg=double(imread([PatternFolder '\' filesPattern(f).name(1:end-4)]));
              pimg=double(pimg)-min(pimg(:)); pimg=pimg/max(pimg(:));

              simg=zeros(ry-ly+1, rx-lx+1, 3, 'uint8');
              simg(:,:,3)=uint8(nimg(ly:ry, lx:rx)*255);
              simg(:,:,2)=uint8(pimg(ly:ry, lx:rx,1)*255);

              if (length(filesActin) >= f),
                %aimg=double(imread([ActinFolder '\..\' filesActin(f).name(1:end-4)]));
                [aimg]=t_deep_tifread([ActinFolder '\' filesActin(f).name], 1); aimg=double(aimg);
                aimg=double(aimg)-min(aimg(:)); aimg=aimg/max(aimg(:));
                simg(:,:,1)=uint8(aimg(ly:ry, lx:rx,1)*255);
              end;

              simg=drawCross( yc(i)-ly+1, xc(i)-lx+1, simg );
              simg=drawCross( npy-ly+1, npx-lx+1, simg );

              if (verbose), figure(2); imshow(simg); pause; end;
              imwrite(simg,[rres filesPattern(f).name(1:end-4) '.bmp']);
        else
          %fprintf(fileID, '%.2f,%.2f,%.2f,%i,%i,%i,%i,%s,%s,%s\n', xc(i), yc(i), 0, 0, r(i).Area(1), 0, filesDapi(f).name, filesPattern(f).name, filesActin(f).name, filesActin(f).name ); 
        end
      else
        %fprintf(fileID, '%.2f,%.2f,%.2f,%i,%i,%i,%i,%s,%s,%s\n', xc(i), yc(i), 0, 0, r(i).Area(1), 0, filesDapi(f).name, filesPattern(f).name, filesActin(f).name, filesActin(f).name ); 
      end;
    end;  
  end;
  fclose(fileID);
end

function [rimg] = drawCross( y, x, dimg )
  rimg=dimg; x=round(x); y=round(y);
  uy=y-10; dy=y+10; ux=x-10; dx=x+10;
  if (uy < 1), uy=1; end; if (ux < 1), ux=1; end;
  if (dy > size(dimg,1)), dy=size(dimg,1); end; if (dx > size(dimg,2)), dx=size(dimg,2); end; 
  for i=-2:2,
    ix=x+i; iy=y+i;
    if (ix < 1), ix=1; end; if (ix > size(dimg,2)), ix=size(dimg,2); end;
    if (iy < 1), iy=1; end; if (iy > size(dimg,1)), iy=size(dimg,1); end;
    rimg( (uy:dy),(ix), 1)=255;  rimg( (uy:dy),(ix), 2)=255;  rimg( (uy:dy),(ix), 3)=255; 
    rimg( (iy) , (ux:dx),1)=255; rimg( (iy) , (ux:dx),2)=255; rimg( (iy) , (ux:dx),3)=255;  
  end;
end