function [] = statisticsFilaments( path, fname, nuclei, minmaxLength, minmaxWidth )
run_feats=0;
filistp=9;
orient=0; % Draw nuclei orientation

    if (nuclei),
        feats = { 'Filament Orientation', 'Filament Length' };
        featsI = [1 3];
        snuclei='_nuclei'; ttitle='Nuclei';
    else
        %feats = {  'Filament Orientation', 'Filament Length', 'Filament Width' };
        %featsI = [1, 3, 2];
        feats = { 'Filament Orientation', 'Filament Length' };
        featsI = [1 3];
        snuclei=''; ttitle='Fibers';
    end;
    
minLength = minmaxLength(1); maxLength=minmaxLength(2);
minWidth = minmaxWidth(1); maxWidth=minmaxWidth(2);

% For the angle
for i=1:numel(feats),
   fprintf('Feature: %s\n', feats{i});
   
     load([path '\' fname]); dataM=data.dataM;     
     %dataM=zeros(size(dataM1,1), 11); dataM(:,1:3)=dataM1(:,:); lM=(dataM(:,1)-90); lM(lM < 0)=180+lM(lM < 0); dataM(:,1)=180-lM;
     if (orient > 0), lM=abs(dataM(:,1)-dataM(:,orient)); lM(lM > 90)=180-lM(lM > 90); dataM(:,1)=lM; end;
     
     dataM_E1=dataM;
     if (nuclei == 0),
       p_E1=( ((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength)) & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)));
     else if (nuclei == 1),
            p_E1=(( dataM_E1(:,filistp)> 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) ));
            %lM=abs(dataM_E1(p_E1,1)-dataM_E1(p_E1,orient));
            %lM(lM > 90)=180-lM(lM > 90);
            %dataM_E1(p_E1,1)=lM;
         else
            p_E1=(( dataM_E1(:,filistp) == 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) )); 
         end;
     end;
     
     if (featsI(i) == 1),
           th = linspace(0, pi, 36); th=[th, pi+th(2)];
           %[st,sr]=rose([dataM_E1(p_E1,1)]/180*pi,th);
           
theta = [dataM_E1(p_E1,1)]/180*pi;
x=th;
theta = rem(rem(theta,2*pi)+2*pi,2*pi); % Make sure 0 <= theta <= 2*pi
x = sort(rem(x(:)',2*pi));

edges = sort(rem([(x(2:end)+x(1:end-1))/2 (x(end)+x(1)+2*pi)/2],2*pi));
edges = [edges edges(1)+2*pi];

nn = histc(rem(theta+2*pi-edges(1),2*pi),edges-edges(1)); % This is the correct one
  [~,bb] = histc(rem(theta+2*pi-edges(1),2*pi),edges-edges(1));
  ww=dataM_E1(p_E1,3);%.*dataM_E1(p_E1,2);
%  ww=dataM_E1(p_E1,3)*0+1; 
  nn=accumarray(bb,ww);

    if (numel(nn) > 0),        
        nn(end-1) = nn(end-1)+nn(end);
        nn(end) = [];
        if min(size(nn))==1, % Vector
          nn = nn(:); 
        end
        [m,n] = size(nn);
        mm = 4*m;
        r = zeros(mm,n);
        r(2:4:mm,:) = nn;
        r(3:4:mm,:) = nn;
        zz = edges;
        t = zeros(mm,1);
        t(2:4:mm) = zz(1:m);
        t(3:4:mm) = zz(2:m+1);           

        st=t; sr=r;

                   pp=find(st <= pi);
                   h2=figure;polar(st(pp), sr(pp)/max(sr(pp))); title( ['Normalized Angular distribution of ' ttitle] );
                   print(h2, '-dpng', [path '/angulardist-' fname snuclei '.png']);
                   close(h2);
             else
               %figure; hist(dataM_E1(p_E1,featsI(i)),1:300);
             end;

                   %finalData=dataM_E1(p_E1,featsI(i));
                   %ttt=1;
                   %tt=zeros(sum(dataM_E1(t,3)),1); for t=1:size(dataM_E1,1), tt(ttt:(ttt+dataM_E1(t,3)-1))=ones(dataM_E1(t,3),1)*dataM_E1(t,featsI(i)); ttt=ttt+dataM_E1(t,3); end;
                   tt=dataM_E1(p_E1,featsI(i));
     else
         run_feats=0;
     end

end;
 

    if (run_feats),
      for i=1:numel(feats),
          allS = [];

          for e1=1:(numel(listExperiments)),
            load([path '/filaments-' listExperiments{e1} '.mat']); if (orient > 0), dataM(:,1)=dataM(:,1)-dataM(:,orient); lneg=find(dataM(:,1) < 0); dataM(lneg,1)=dataM(lneg,1)+180; end;
            dataM_E1=dataM;

            if (~nuclei),
              p_E1=( ((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) );
            else if (nuclei == 1),
                    p_E1=(( dataM_E1(:,filistp)> 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) ));
                else
                   p_E1=(( dataM_E1(:,filistp) == 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength)) & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) )); 
                end;
            end;

            allS=[allS; dataM_E1(p_E1,featsI(i)), (ones(sum(p_E1(:)),1)+e1-1)];
            for e2=(e1+1):numel(listExperiments),
               load([path '/filaments-' listExperiments{e2} '.mat']); if (orient > 0), dataM(:,1)=dataM(:,1)-dataM(:,orient); lneg=find(dataM(:,1) < 0); dataM(lneg,1)=dataM(lneg,1)+180; end;
               dataM_E2=dataM;       

               if (~nuclei),
                 p_E2=( ((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) );
               else if (nuclei == 1),
                       p_E2=(( dataM_E2(:,filistp)> 0 ) & ( ((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) ));
                   else
                       p_E2=(( dataM_E2(:,filistp) == 0 ) & (((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) )); 
                    end;
               end;

                  la=dataM_E1(p_E1,featsI(i)); lb=dataM_E2(p_E2,featsI(i));
                  r=randperm(max(numel(la), numel(lb)));

        %           if (numel(la) < numel(lb)),
        %             lb=lb(r(1:numel(la)));
        %           else
        %             la=la(r(1:numel(lb)));
        %           end;

                  %[p, h]=ranksum(la, lb);
                  [h,p]=ttest2(la,lb, 0.001, 'both', 'unequal');
                  fprintf('%i vs %i => [%s] p=%.4f\n', e1, e2, feats{i}, p); 
                  %welchanova([la ones(numel(la),1); lb ones(numel(lb),1)+1], 0.05);
                  %Levenetest([la ones(numel(la),1); lb ones(numel(lb),1)+1], 0.05);
            end;
          end;
          %welchanova(allS, 0.001);
          %Levenetest(allS, 0.001);
      end;
    end;
    end
%end

% % %*********************************************************************
% % %** (c) Copyright 2016
% % %** The author(s): Mitchel Alioscha-Perez (maperezg@etro.vub.ac.be)
% % %** Vrije Universiteit Brussel,
% % %** Department of Electronics and Informatics (ETRO),
% % %** Faculty of Engineering Sciences,
% % %** VUB-ETRO,
% % %** 2 Pleinlaan, 1050 Belgium.
% % %** (VUB - ETRO)
% % %**
% % %** All right reserved
% % %** Permission to use, copy, modify, and distribute within VUB-ETRO
% % %** this routine/program/software and/or its documentation, or part of any one of them
% % %** (the program) for research purpose within VUB-ETRO is hereby granted, provided:
% % %** (1) that the copyright notice appears in all copies,
% % %** (2) that both the copyright notice and this permission notice appear in the supporting documentation, and
% % %** (3) that all publications based partially or completely on this program will have the main publications of "the authors" related to this
% % %** work cited as references.
% % %** Any other type of handling or use of the program, CAN NOT BE DONE
% % %** WITHOUT PRIOR WRITTEN APPROVAL from the VUB-ETRO,
% % %** including but not restricted to the following:
% % %** (A) any re-distribution of the program to any person outside of the VUB-ETRO
% % %** (B) any use of the program which is not academic research;
% % %** (C) any commercial activity involving the use of the program is strictly prohibited.
% % %** Modifications: 2015, 2016
% % %** Disclaimer: VUB ETRO make no claim about the
% % %** suitability of the program for any particular purpose.
% % %** It is provided "as is" without any form of warranty or support.
% % %********************************************************************************************
% % 
% % function [] = statisticsFilaments( path, fname, nuclei, minmaxLength, minmaxWidth, langles, halfcircle )
% % run_feats=0;
% % filistp=11;
% % 
% % orient=0; % Draw nuclei orientation
% % if (nargin < 7),
% %   halfcircle=1;
% % end;
% % %halfcircle=1;
% % 
% % resol=langles(2)-langles(1);
% % 
% %     if (nuclei),
% %         feats = { 'Filament Orientation', 'Filament Length' };
% %         featsI = [1 3];
% %     else
% %         feats = { 'Filament Orientation', 'Filament Length' };
% %         featsI = [1 3];
% %     end;
% %     
% % minLength = minmaxLength(1); maxLength=minmaxLength(2);
% % minWidth = minmaxWidth(1); maxWidth=minmaxWidth(2);
% % 
% % % For the angle
% % for i=1:numel(feats),
% %    fprintf('Feature: %s\n', feats{i});
% %    
% %      load([path '\' fname]); dataM=data.dataM;
% %      if (orient > 0), lM=abs(dataM(:,1)-dataM(:,orient)); lM(lM > 90)=180-lM(lM > 90); dataM(:,1)=lM; end;
% %      
% %      dataM_E1=dataM;
% %      if (nuclei == 0),
% %        p_E1=( ((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength)) & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)));
% %      else if (nuclei == 1),
% %             p_E1=(( dataM_E1(:,filistp)> 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) ));
% %          else
% %             p_E1=(( dataM_E1(:,filistp) == 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) )); 
% %          end;
% %      end;
% %      
% %      if (featsI(i) == 1),
% %      
% %            % **** With 180 ********
% %            if (halfcircle),
% %                 %[st,sr]=rose([dataM_E1(p_E1,1)]/180*pi,th);           
% %                 theta = [dataM_E1(p_E1,1)]/180*pi;
% % 
% %                 tt1=max(histc(langles,1:180)); tt2=min(histc(langles,1:180));
% %                 th = linspace(0, pi, 180/(2*tt1+0*tt2));
% %                 th=[th, pi+th(2)];  
% % 
% %                  ww=dataM_E1(p_E1,3);%.*dataM_E1(p_E1,2);
% %                  %  ww=dataM_E1(p_E1,3)*0+1;
% % 
% %            else
% %                % **** With 360 ********
% %                %[st,sr]=rose([dataM_E1(p_E1,1)]/360*pi,th);
% %                theta = [ dataM_E1(p_E1,1); dataM_E1(p_E1,1)+180 ]/180*pi;
% %                tangles=[langles; langles+180];
% %                langles=tangles;
% % 
% %                tt1=max(histc(langles,1:360)); tt2=min(histc(langles,1:360));
% %                th = linspace(0, 2*pi, 360/(2*tt1+0*tt2));
% %                th=[th, pi+th(2)];
% % 
% %                ww=[dataM_E1(p_E1,3); dataM_E1(p_E1,3)];%.*dataM_E1(p_E1,2);
% %                %  ww=dataM_E1(p_E1,3)*0+1;
% %            end;
% %                
% % theta = rem(rem(theta,2*pi)+2*pi,2*pi); % Make sure 0 <= theta <= 2*pi
% % x=th;
% % x = sort(rem(x(:)',2*pi));
% % 
% % edges = sort(rem([(x(2:end)+x(1:end-1))/2 (x(end)+x(1)+2*pi)/2],2*pi));
% % edges = [edges edges(1)+2*pi];
% % 
% % % Per filaments
% % [~,bb] = histc(rem(theta+2*pi-edges(1),2*pi),edges-edges(1));
% % 
% % % Cumulative per pixels
% % nn=accumarray(bb,ww); % ******************** The problem is that nn is different from 360 than from 180 ~!!!!!!!!
% % %if (halfcircle), % Problem here !!
% % %     nn(end-1) = nn(end-1)+nn(end);
% % %     nn(end) = [];
% % %     if min(size(nn))==1, % Vector
% % %      nn = nn(:); 
% % %     end
% % %end;
% % 
% % [m,n] = size(nn);
% % mm = 4*m;
% % r = zeros(mm,n);
% % r(2:4:mm,:) = nn;
% % r(3:4:mm,:) = nn;
% % zz = edges;
% % t = zeros(mm,1);
% % t(2:4:mm) = zz(1:m);
% % t(3:4:mm) = zz(2:m+1);           
% % 
% % st=t; sr=r;
% %            
% %            if (halfcircle),
% %               pp=find(st <= pi); % pp=find(st <= 2*pi);
% %               str=['half_' num2str(resol) '_'];
% %            else
% %                pp=find(st <= 2*pi); % pp=find(st <= 2*pi);
% %                str=['full_' num2str(resol) '_'];
% %            end;
% %            h2=figure;polar(st(pp), sr(pp)/max(sr(pp))); title( ['Normalized Angular distribution of Fibers'] );
% %            %h2=figure;polar(st(pp), sr(pp)/sum(sr(pp))); title( ['Normalized Angular distribution of Fibers'] );
% %            print(h2, '-dpng', [path '/' str 'angulardist-' fname '.png']);
% %            close(h2);
% %            %figure;polar(st(pp), sr(pp)); title( ['Normalized Angular distribution of Fibers in ' strrep(listExperiments{e}, '_', ' ')] );
% %      else
% %        %figure; hist(dataM_E1(p_E1,featsI(i)),1:300);
% %      end;
% %            
% %            %finalData=dataM_E1(p_E1,featsI(i));
% %            %ttt=1;
% %            %tt=zeros(sum(dataM_E1(t,3)),1); for t=1:size(dataM_E1,1), tt(ttt:(ttt+dataM_E1(t,3)-1))=ones(dataM_E1(t,3),1)*dataM_E1(t,featsI(i)); ttt=ttt+dataM_E1(t,3); end;
% %            tt=dataM_E1(p_E1,featsI(i));
% %            
% %   fprintf('\n');
% % end;
% %   
% % if (run_feats),
% %   for i=1:numel(feats),
% %       allS = [];
% %       
% %       for e1=1:(numel(listExperiments)),
% %         load([path '/filaments-' listExperiments{e1} '.mat']);
% %         if (orient > 0), dataM(:,1)=dataM(:,1)-dataM(:,orient); lneg=find(dataM(:,1) < 0); dataM(lneg,1)=dataM(lneg,1)+180; end;
% %         
% %         dataM_E1=dataM;
% %         
% %         if (~nuclei),
% %           p_E1=( ((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) );
% %         else if (nuclei == 1),
% %                 p_E1=(( dataM_E1(:,filistp)> 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength))  & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) ));
% %             else
% %                p_E1=(( dataM_E1(:,filistp) == 0 ) & (((dataM_E1(:,3) >= minLength) & (dataM_E1(:,3) <= maxLength)) & ((dataM_E1(:,2) >= minWidth) & (dataM_E1(:,2) <= maxWidth)) )); 
% %             end;
% %         end;
% %         
% %         allS=[allS; dataM_E1(p_E1,featsI(i)), (ones(sum(p_E1(:)),1)+e1-1)];
% %         for e2=(e1+1):numel(listExperiments),
% %            load([path '/filaments-' listExperiments{e2} '.mat']);
% %            if (orient > 0), dataM(:,1)=dataM(:,1)-dataM(:,orient); lneg=find(dataM(:,1) < 0); dataM(lneg,1)=dataM(lneg,1)+180; end;
% %            
% %            dataM_E2=dataM;       
% %            
% %            if (~nuclei),
% %              p_E2=( ((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) );
% %            else if (nuclei == 1),
% %                    p_E2=(( dataM_E2(:,filistp)> 0 ) & ( ((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) ));
% %                else
% %                    p_E2=(( dataM_E2(:,filistp) == 0 ) & (((dataM_E2(:,3) >= minLength) & (dataM_E2(:,3) <= maxLength))  & ((dataM_E2(:,2) >= minWidth) & (dataM_E2(:,2) <= maxWidth)) )); 
% %                 end;
% %            end;
% % 
% %               la=dataM_E1(p_E1,featsI(i)); lb=dataM_E2(p_E2,featsI(i));
% %               r=randperm(max(numel(la), numel(lb)));
% % 
% % 
% %               %[p, h]=ranksum(la, lb);
% %               [h,p]=ttest2(la,lb, 0.001, 'both', 'unequal');
% %               fprintf('%i vs %i => [%s] p=%.4f\n', e1, e2, feats{i}, p); 
% %               %welchanova([la ones(numel(la),1); lb ones(numel(lb),1)+1], 0.05);
% %               %Levenetest([la ones(numel(la),1); lb ones(numel(lb),1)+1], 0.05);
% %         end;
% %       end;
% %       %welchanova(allS, 0.001);
% %       %Levenetest(allS, 0.001);
% %   end;
% % end;
% % end
