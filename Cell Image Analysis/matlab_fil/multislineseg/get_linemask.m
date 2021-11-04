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

function linemask = get_linemask(theta,masksize)
% (theta,masksize)
% Create a mask for line with angle theta
if theta > 90
   mask = getbasemask(180- theta,masksize);
   linemask = rotatex(mask);
else
   linemask = getbasemask(theta,masksize);
end
% imshow(linemask,'InitialMagnification','fit');
end

function rotatedmask = rotatex(mask)
[h,w] = size(mask);
rotatedmask = zeros(h,w);

for i = 1:h
    for j = 1:w
        rotatedmask(i,j) = mask(i,w-j+1);
    end
end
end

function mask = getbasemask(theta,masksize)

mask = zeros(masksize);

halfsize = round((masksize-1)/2);

if theta == 0
    mask(halfsize+1,:) = 1;
elseif theta == 90
    mask(:,halfsize+1) = 1;
else
    x0 = -halfsize;
    y0 = round(x0*(sind(theta)/cosd(theta)));

    if y0 < -halfsize
        y0 = -halfsize;
        x0 = round(y0*(cosd(theta)/sind(theta)));
    end

    x1 = halfsize;
    y1 = round(x1*(sind(theta)/cosd(theta)));

    if y1 > halfsize
        y1 = halfsize;
        x1 = round(y1*(cosd(theta)/sind(theta)));
    end

    pt0 = [halfsize-y0+1 halfsize+x0+1];
    pt1 = [halfsize-y1+1 halfsize+x1+1];

    mask = drawline(pt0,pt1,mask);
end

end

function img = drawline(pt0,pt1,orgimg)
img = orgimg;
linepts = getlinepts(pt0,pt1);
for i = 1:size(linepts,1)
   img(linepts(i,1),linepts(i,2)) = 1; 
end

end

function [linepts] = getlinepts(pt0,pt1)
% Return the points along the straight line connecting pt1 and pt2
if pt0(2) < pt1(2)
    x0 = pt0(2);    y0 = pt0(1);
    x1 = pt1(2);    y1 = pt1(1);
else
    x0 = pt1(2);    y0 = pt1(1);
    x1 = pt0(2);    y1 = pt0(1);
end

dx = x1 - x0;   dy = y1 - y0;
ind = 1;
linepts = zeros(numel(x0:x1),2);
step = 1;
if dx == 0 
   x = x0;
   if dy < 0,   step = -1;  end
   for y = y0:step:y1
        linepts(ind,:) = [y,x];
        ind = ind + 1;
   end
elseif abs(dy) > abs(dx)
    if dy < 0,  step = -1;  end
    for y = y0:step:y1
       x = round((dx/dy)*(y - y0) + x0);
       linepts(ind,:) = [y,x];
       ind = ind + 1;
    end
else
    for x = x0:x1
        y = round((dy/dx)*(x - x0) + y0);
        linepts(ind,:) = [y, x]; 
        ind = ind + 1;
    end
end

end