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

function [segList, isegList, rIc, iltheta] = get_segments_latest( binI, theta_list, minLength, angleTol, lengthTol, merge ),

    if (nargin < 6), merge=0; end;   
    
    hL=round(minLength/3); L=hL*2+1; LL=L;
    %hL=round(min(size(binI))/3); LL=hL*2+1; L=LL;
    ltheta=theta_list;
    iltheta=theta_list;

    Ltol=lengthTol*LL;

    I=logical(binI);
    [sy,sx]=size(I);

    if (~merge),
      tL=L;
      I(1:tL,:)=0; I((end-tL+1):end,:)=0; I(:,1:tL)=0; I(:,(end-tL+1):end)=0;
      xy=find(I);
      [y,x]=find(I);
      sI=false(sy,sx,180);

      linemask=false(LL,LL,180);
      lx=zeros(LL,180);
      ly=zeros(LL,180);

      % Create the directional filters
        fltheta=[];
        iltheta=zeros(numel(ltheta),1);
        for ti=1:numel(ltheta),
            theta=ltheta(ti);
            ts = logical(get_linemask(theta,LL));%ts = logical(get_linemask(theta,L));
            linemask(:,:,theta) = ts;
            repeated=false;
            for tt=1:numel(fltheta),
              tj=fltheta(tt);
              ls=linemask(:,:,tj).*linemask(:,:,theta);
              if (sum(ls) == sum(ts)),
                %repeated=true; break;
              end;
            end;
            repeated=false; % Ignore the minLength for the angular resolution!
            if (~repeated),
              fltheta=[fltheta, theta];
              [tly,tlx] = find(linemask(:,:,theta));
              ly(:,theta)=tly-hL-1;              
              lx(:,theta)=(tlx-hL-1)*sy;
              iltheta(ti)=[theta];
            else
              iltheta(ti)=tj;
            end;            
        end

        % Find all the segments
        rI=zeros(sy,sx,'uint32');
        ltheta=fltheta;
        seg=zeros(numel(xy)*numel(ltheta), 7); top=1;
        for tti=1:numel(ltheta),
          ti=ltheta(tti);
          for i=1:numel(xy),
              txy=xy(i) + (lx(:,ti) + ly(:,ti));
              p=I(txy); sp=sum(p);
              if (sp >= Ltol),
                vID=rI(txy(p));
                iID=find(vID,1,'first');
                if (iID > 0),
                  oID=vID(iID);
                  overlapis=logical(rI(txy(p)));
                  seg(oID,:)=[ti, min(seg(oID,2),min(txy(p))), seg(oID,3), max(seg(oID,4),max(txy(p))), seg(oID,5)+(sp-sum(overlapis)), seg(oID,6)+1, 0];
                  rI(txy(p))=oID;
                else
                    if (sp == L),
                      seg(top,:)=[ti txy(1) xy(i) txy(L) sp 1 0];
                    else
                      wl=find(p,1,'first'); wr=find(p,1,'last');
                      seg(top,:)=[ti txy(wl) xy(i) txy(wr) sp 1 0];
                    end;
                    rI(txy(p))=top;
                    top = top + 1;
                end;
              end
          end
          rI=zeros(sy,sx,'uint32');
        end
        seg((top):end,:)=[];
        %xys((top):end,:)=[];
        bseg=seg;  
    else
        bseg=zeros(0,7);
    end
    isegList=bseg(bseg(:,5) >= minLength,:);

    %merge=[];
    if (size(merge,2) > 1),
        bseg=merge;
        %bxys=xys;
        % Merge the segments
        for al=0:1:angleTol,
        for i=1:(size(bseg,1)-1),
          if (bseg(i,5) > 0),
              l=find((bseg((i+1):end,2)==bseg(i,4)) & (abs(bseg((i+1):end,1)-bseg(i,1)) <= al),1,'first')+i;
              if (numel(l) > 0), % Left (l <= l)
                 bseg(l,1)=(bseg(l,1)*bseg(l,6)+bseg(i,1)*bseg(i,6))/(bseg(l,6)+bseg(i,6));
                 bseg(l,6)=bseg(l,6)+bseg(i,6); bseg(l,5)=bseg(l,5)+bseg(i,5)-hL-1;
                 bseg(l,2)=bseg(i,2); %bxys(l,1:2)=bxys(i,1:2);
                 bseg(l,7)=al;
                 bseg(i,:)=[0 0 0 0 -inf 0 0];
              else   
                l=find((bseg((i+1):end,4)==bseg(i,2)) & (abs(bseg((i+1):end,1)-bseg(i,1)) <= al),1,'first')+i;
                if (numel(l) > 0), % Right (r <= r)
                  bseg(l,1)=(bseg(l,1)*bseg(l,6)+bseg(i,1)*bseg(i,6))/(bseg(l,6)+bseg(i,6)); % Merging angle
                  bseg(l,6)=bseg(l,6)+bseg(i,6); bseg(l,5)=bseg(l,5)+bseg(i,5)-hL-1;         % Merging length and total segments
                  bseg(l,4)=bseg(i,4); %bxys(l,3:4)=bxys(i,3:4);                             % Updating start/end points
                  bseg(l,7)=al;
                  bseg(i,:)=[0 0 0 0 -inf 0 0];                                                % Nullifing actual segment
                else % (l <= r)
                  l=find((bseg((i+1):end,2)==bseg(i,2)) & (abs(bseg((i+1):end,1)-bseg(i,1)) <= al),1,'first')+i;
                  if (numel(l) > 0),
                    if (bseg(i,5) > bseg(l,5)),
                      bseg(l,1)=(bseg(l,1)*bseg(l,6)+bseg(i,1)*bseg(i,6))/(bseg(l,6)+bseg(i,6));
                      bseg(l,6)=bseg(l,6)+bseg(i,6); bseg(l,5)=bseg(l,5)+bseg(i,5)-hL-1;
                      bseg(l,2)=bseg(i,4); %bxys(l,1:2)=bxys(i,1:2);
                      bseg(l,7)=al;
                    end;
                    bseg(i,:)=[0 0 0 0 -inf 0 0];
                  else % (r <= l)
                    l=find((bseg((i+1):end,4)==bseg(i,4)) & (abs(bseg((i+1):end,1)-bseg(i,1)) <= al),1,'first')+i;
                    if (numel(l) > 0),
                      if (bseg(i,5) > bseg(l,5)),
                        bseg(l,1)=(bseg(l,1)*bseg(l,6)+bseg(i,1)*bseg(i,6))/(bseg(l,6)+bseg(i,6));
                        bseg(l,6)=bseg(l,6)+bseg(i,6); bseg(l,5)=bseg(l,5)+bseg(i,5)-hL-1;
                        bseg(l,4)=bseg(i,2); %bxys(l,1:2)=bxys(i,1:2);
                        bseg(l,7)=al;
                      end;
                      bseg(i,:)=[0 0 0 0 -inf 0 0];                
                    end;
                  end
                end
              end;
          end;
        end
        end
    end;
    l=find(bseg(:,5) >= 0);
    segList=bseg(l,:);
    
    if (1==1),
        
        mc1=zeros(180,1); mc2=zeros(180,1); mc3=zeros(180,1);
        for c=1:12,
          mc1( ((c-1)*15+1):(c*15) ) = round(rand(1)*255);
          mc2( ((c-1)*15+1):(c*15) ) = round(rand(1)*255);
          mc3( ((c-1)*15+1):(c*15) ) = round(rand(1)*255);
        end;
        
        rI=false(sy,sx); rIc=double(rI);
        bseg=segList;
        [~,p]=sort(bseg(:,5), 'ascend'); tb=bseg(p,:); bseg=tb; p=1:numel(p); t=numel(p); %p=(numel(p)-99):numel(p); t=numel(p); % top100
        p=find(bseg(:,5)> minLength); t=numel(p); p=p(1:t);
        rc1=zeros(sy,sx,'uint8'); rc2=rc1; rc3=rc1;
        rrc1=binI(:,:,1); rrc2=binI(:,:,1); rrc3=binI(:,:,1);
        
        n=1;
        for i=1:t,
          [my1,mx1]=ind2sub([size(I,1),size(I,2)],bseg(p(i),2)); 
          [my2,mx2]=ind2sub([size(I,1),size(I,2)],bseg(p(i),4));
          
          %if ((min(mx1,mx2) >= 175) && (max(mx1,mx2) <=330) && (min(my1,my2) >= 160) && (max(my1,my2) <= 330)),
          if (abs(mx1-mx2) > abs(my1-my2)),
            M = repmat([mx1 mx2]',1,n+1); M = bsxfun(@power,M,0:n);
            pf=M\[my1 my2]';
            mx=min(mx1,mx2):0.01:max(mx1,mx2);
            my=polyval([pf(2) pf(1)], mx);
            l=unique(sub2ind(size(rI), round(my), round(mx)));
          else
            if (abs(my1-my2) > 0),
                M = repmat([my1 my2]',1,n+1); M = bsxfun(@power,M,0:n);
                pf=M\[mx1 mx2]';
                my=min(my1,my2):0.01:max(my1,my2);
                mx=polyval([pf(2) pf(1)], my);
                l=unique(sub2ind(size(rI), round(my), round(mx)));
            end;
            l=unique(sub2ind(size(rI), round(my), round(mx)));
          end;
          rI(l)=1; rIc(l)=bseg(p(i),1)/15;
          v1=round(rand(1)*255); v2=round(rand(1)*255); v3=round(rand(1)*255);
          %v1=mc1(round(bseg(p(i),1))); v2=mc2(round(bseg(p(i),1))); v3=mc3(round(bseg(p(i),1)));
          rc1(l)=v1; rc2(l)=v2; rc3(l)=v3;
          rrc1(l)=v1; rrc2(l)=v2; rrc3(l)=v3;
          %end;
        end;
    end;
    rC=zeros(sy,sx,3,'uint8'); rC(:,:,1)=rc1; rC(:,:,2)=rc2; rC(:,:,3)=rc3;
end