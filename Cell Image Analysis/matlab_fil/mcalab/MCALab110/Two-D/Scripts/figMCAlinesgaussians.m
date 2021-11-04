%%%%%%%%%%%%%%% 2D synthetic image: lines+gaussians %%%%%%%%%%%%%%%%%%%%%%%%
%clear all
%load linesgaussians
%load linesgaussians1
%load linesgaussians2

% Make the lines and gaussians part.
%n=256;
nx=359;
ny=359;
%n=520;
ix = ((-nx/2):(nx/2-1))' * ones(1,nx);
iy = ones(ny,1) * ((-ny/2):(ny/2-1));
ix = ix./nx; iy = iy./ny;
imgg=50.^(-960.*ix.^2- 960.*iy.^2 )+90.^(-960.*(ix-0.1).^2- 960.*(iy+0.1).^2 )+exp(-860.*(ix-0.25).^2- 860.*(iy-0.25).^2)+exp(-240.*(ix-0.35).^2-240.*(iy+0.35).^2);
img=rgb2gray(imread('test1.bmp')); img=img(:,1:359);
imgl=double(img)/255.0+imgg((end-size(img,1)+1):end, :)/1; imgl=imgl-min(imgl(:)); imgl/max(imgl(:));

%imnoisy = part1 + part2 + noise
sigma  = 0.05;
imnoisy=imgl+sigma*randn(size(img));

l=imnoisy; l=l-min(l(:)); l=l/max(l(:)); figure; imshow(l);
%img=double(imread('rs-cell3_w2Green-FITC-wf_s6.TIF.bmp'));
%imnoisy=img;

% Dictionary stuff (here Curvelets + UDWT).
qmf=MakeONFilter('Symmlet',6);
dict1='UDWT2';pars11=3;pars12=qmf;pars13=0;
dict2='CURVWRAP';pars21=2;pars22=0;pars23=0;
dicts=MakeList(dict1,dict2);
pars1=MakeList(pars11,pars21);
pars2=MakeList(pars12,pars22);
pars3=MakeList(pars13,pars23);


% Call the MCA.
itermax 	= 200;
tvregparam 	= 3;
tvcomponent	= 1;
expdecrease	= 0;
lambdastop	= 3;
display		= 2;
[parts,options]=MCA2_Bcr(imnoisy,dicts,pars1,pars2,pars3,itermax,tvregparam,tvcomponent,expdecrease,lambdastop,[],[],display);
options.inputdata = 'Input image: Lines + Texture 256 x 256';
options
[ST,I] = dbstack;
name=eval(['which(''' ST(1).name ''')']);
%eval(sprintf('save %s options -V6',[name(1:end-2) 'metadata']));

% Display results.
figure;
set(gcf,'Name','MCA Lines + Gaussians','NumberTitle','off');
subplot(331);
imagesc(img);axis image;rmaxis;
title('Original Lines + Gaussians');

subplot(332);
imagesc(imnoisy);axis image;rmaxis;
title(sprintf('Noisy PSNR=%.3g dB',psnr(img,imnoisy)));

subplot(333);
imagesc(squeeze(sum(parts,3)));axis image;rmaxis;
title(sprintf('Denoised MCA PSNR=%.3g dB',psnr(img,squeeze(sum(parts,3)))));

subplot(323);
imagesc(img);axis image;rmaxis;
title('Original Gaussians');

subplot(324);
imagesc(squeeze(parts(:,:,1)));axis image;rmaxis;
title(sprintf('MCA Gaussians PSNR=%.3g dB',psnr(imgg,squeeze(parts(:,:,1)))));

subplot(325);
imagesc(imgl);axis image;rmaxis;
title('Original Lines');

subplot(326);
imagesc(squeeze(parts(:,:,2)));axis image;rmaxis;
title(sprintf('MCA Lines PSNR=%.3g dB',psnr(imgl,squeeze(parts(:,:,2)))));

colormap('gray');


