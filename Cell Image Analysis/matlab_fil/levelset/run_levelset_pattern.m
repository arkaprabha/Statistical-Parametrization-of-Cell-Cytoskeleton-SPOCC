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

function [model] = run_levelset( Img,fg_bg_markers, model, actualiter, numiter, verbose )

% Initialization ************************
% parameter setting
if (actualiter <= 1),
    model.timestep=1;  % time step
    model.mu=0.2/model.timestep;  % coefficient of the distance regularization term R(phi)
    model.iter_inner=10;
    model.lambda=10; % coefficient of the weighted length term L(phi)
    model.alfa=-3;  % coefficient of the weighted area term A(phi)
    model.epsilon=1.5; % papramater that specifies the width of the DiracDelta function

    model.Img=double(Img(:,:,1));

    model.sigma=.8;    % scale parameter in Gaussian kernel
    model.G=fspecial('gaussian',15,model.sigma); % Caussian kernel
    model.Img_smooth=conv2(model.Img,model.G,'same');  % smooth image by Gaussiin convolution
    [model.Ix,model.Iy]=gradient(model.Img_smooth);
    model.f=model.Ix.^2+model.Iy.^2;
    model.g=1./(1+model.f);  % edge indicator function.

    % initialize LSF as binary step function
    model.c0=-2;
    model.initialLSF = model.c0*ones(size(model.Img));
    model.initialLSF(fg_bg_markers > 0) = -model.c0;

    model.phi=model.initialLSF;

    if (verbose),
      mfigure(2);
      imagesc(model.Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(model.phi, [0,0], 'r');
    end;

    model.potential=2;  
    if model.potential ==1
        model.potentialFunction = 'single-well';  % use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model 
    elseif model.potential == 2
        model.potentialFunction = 'double-well';  % use double-well potential in Eq. (16), which is good for both edge and region based models
    else
        model.potentialFunction = 'double-well';  % default choice of potential function
    end  
end;

% start level set evolution
%for n=1:iter_outer
    model.phi = drlse_edge(model.phi, model.g, model.lambda, model.mu, model.alfa, model.epsilon, model.timestep, model.iter_inner, model.potentialFunction);    
    if (verbose)
        mfigure(2);
        imagesc(model.Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(model.phi, [0,0], 'r');
    end
%end

% refine the zero level contour by further level set evolution with alfa=0
if (actualiter >= numiter),
    model.alfa=0;
    model.phi = drlse_edge(model.phi, model.g, model.lambda, model.mu, model.alfa, model.epsilon, model.timestep, model.iter_inner, model.potentialFunction);

    if (verbose),
        mfigure(2);
        imagesc(model.Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(model.phi, [0,0], 'r');
        hold on;  contour(model.phi, [0,0], 'r');
    end;
end;

end

function [] = mfigure(f),
  hf=figure(f);
%   jFrame = get(hf,'JavaFrame');
%   set(hf,'Visible','off');
%   jCanvas = jFrame.getAxisComponent;
%   jFrameProxy = jCanvas.getParent.getParent.getTopLevelAncestor;
%   jf2 = javax.swing.JFrame;
%   jf2.pack; 
%   jf2.setTitle('Levelset progress');
%   awtinvoke(jf2,'add(Ljava.awt.Component;)',jCanvas);
%   jf2.setSize(java.awt.Dimension(500, 500));
%   awtinvoke(jf2,'setVisible',1);	% the plot shows in the Java Frame
%   awtinvoke(jf2,'show()');
end