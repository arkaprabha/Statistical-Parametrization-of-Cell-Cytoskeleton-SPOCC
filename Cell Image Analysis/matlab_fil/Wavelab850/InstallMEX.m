function InstallMEX

global WAVELABPATH

MEX_OK = 1;

% Check if all the MEX files are installed
for file={'CPAnalysis' 'WPAnalysis' 'FWT_PO' 'FWT2_PO' 'IWT_PO' ...
      'IWT2_PO' 'UpDyadHi' 'UpDyadLo' 'DownDyadHi' 'DownDyadLo' 'dct_iv' ...
      'FCPSynthesis' 'FWPSynthesis' ...
      'dct_ii' 'dst_ii' 'dct_iii' 'dst_iii' ...
      'FWT_PBS' 'IWT_PBS' ...
      'FWT_TI' 'IWT_TI' ...
      'FMIPT' 'IMIPT' ...
      'FAIPT' 'IAIPT' 'LMIRefineSeq' 'MedRefineSeq'}
  
  file = char(file);
  if exist(file)~=4,
    MEX_OK = 0;
    break;
  end
end

% If not, install...
if ~MEX_OK,
  disp('WaveLab detects that some or all of your MEX files are not installed,')
  R=input('do you want to install them now? [[Yes]/No] \n','s');
if strcmp(R,'') + strcmp(R,'Yes') | strcmp(R,'yes') | strcmp(R,'y') | strcmp(R,'Y') | strcmp(R,'YES'), 
  disp('INSTALLING MEX FILES, MAY TAKE A WHILE ...')
  disp(' ')
  disp('WaveLab assumes that your mex compiler is properly installed.')
  disp('In particular, you should be able to call mex.m within matlab')
  disp('to compile a mex file.')
  disp('Consult your system administrator if not.')
  disp(' ')      
  FIRST_COMPILE = 0;
  
  eval(sprintf('cd ''%sMEXSource''', WAVELABPATH));
  
  for file={'CPAnalysis' 'WPAnalysis' 'FWT_PO' 'FWT2_PO' 'IWT_PO' ...
	'IWT2_PO' 'UpDyadHi' 'UpDyadLo' 'DownDyadHi' 'DownDyadLo' 'dct_iv' ...
	'FCPSynthesis' 'FWPSynthesis' ...
	'dct_ii' 'dst_ii' 'dct_iii' 'dst_iii' ...
	'FWT_PBS' 'IWT_PBS' ...
	'FWT_TI' 'IWT_TI' ...
	'FMIPT' 'IMIPT' ...
	'FAIPT' 'IAIPT' 'LMIRefineSeq' 'MedRefineSeq'}
  
    file = char(file);
    disp(sprintf('%s.c',file));
    eval(sprintf('mex %s.c',file));
  end

  Friend = computer;
  isPC = 0; isMAC = 0;
  if strcmp(Friend(1:2),'PC')
    isPC = 1;
  elseif strcmp(Friend,'MAC2')
    isMAC = 1;
  end
  
  if isunix,
    
  elseif isPC,
    dos('move CPAnalysis.m* ..\Packets\One-D');
    dos('move WPAnalysis.m* ..\Packets\One-D');
    dos('move FWT_PO.m* ..\Orthogonal');
    dos('move FWT2_PO.m* ..\Orthogonal');
    dos('move IWT_PO.m* ..\Orthogonal');
    dos('move IWT2_PO.m* ..\Orthogonal');
    dos('move UpDyadHi.m* ..\Orthogonal');
    dos('move UpDyadLo.m* ..\Orthogonal');
    dos('move DownDyadHi.m* ..\Orthogonal');
    dos('move DownDyadLo.m* ..\Orthogonal');
    dos('move dct_iv.m* ..\Packets\One-D');
    dos('move FCPSynthesis.m* ..\Pursuit');
    dos('move FWPSynthesis.m* ..\Pursuit');
    dos('move dct_ii.m* ..\Meyer');
    dos('move dst_ii.m* ..\Meyer');
    dos('move dct_iii.m* ..\Meyer');
    dos('move dst_iii.m* ..\Meyer');
    dos('move FWT_PBS.m* ..\Biorthogonal');
    dos('move IWT_PBS.m* ..\Biorthogonal');
    dos('move FWT_TI.m* ..\Invariant');
    dos('move IWT_TI.m* ..\Invariant');
    dos('move FMIPT.m* ..\Median ');
    dos('move IMIPT.m* ..\Median');
    dos('move FAIPT.m* ..\Papers\MIPT');
    dos('move IAIPT.m* ..\Papers\MIPT');
    dos('move LMIRefineSeq.m* ..\Papers\MIPT');
    dos('move MedRefineSeq.m* ..\Papers\MIPT');
  elseif isMAC,
    acopy('CPAnalysis.mex', '::Packets:One-D')
    acopy('WPAnalysis.mex' ,'::Packets:One-D')
    acopy('FWT_PO.mex' ,'::Orthogonal')
    acopy('FWT2_PO.mex' ,'::Orthogonal')
    acopy('IWT_PO.mex' ,'::Orthogonal')
    acopy('IWT2_PO.mex' ,'::Orthogonal')
    acopy('UpDyadHi.mex' ,'::Orthogonal')
    acopy('UpDyadLo.mex' ,'::Orthogonal')
    acopy('DownDyadHi.mex' ,'::Orthogonal')
    acopy('DownDyadLo.mex' ,'::Orthogonal')
    acopy('dct_iv.mex' ,'::Packets:One-D')
    acopy('FCPSynthesis.mex' ,'::Pursuit')
    acopy('FWPSynthesis.mex' ,'::Pursuit')
    acopy('FastAllSeg.mex' ,'::Papers:MinEntSeg')
    acopy('dct_ii.mex' ,'::Meyer')
    acopy('dst_ii.mex' ,'::Meyer')
    acopy('dct_iii.mex' ,'::Meyer')
    acopy('dst_iii.mex' ,'::Meyer')
    acopy('FWT_PBS.mex' ,'::Biorthogonal')
    acopy('IWT_PBS.mex' ,'::Biorthogonal')
    acopy('FWT_TI.mex' ,'::Invariant')
    acopy('IWT_TI.mex' ,'::Invariant')
    acopy('FMIPT.mex' ,'::Median')
    acopy('IMIPT.mex' ,'::Median')
    acopy('FAIPT.mex' ,'::Papers:MIPT')
    acopy('IAIPT.mex' ,'::Papers:MIPT')
    acopy('LMIRefineSeq.mex' ,'::Papers:MIPT')
    acopy('MedRefineSeq.mex' ,'::Papers:MIPT')
  end
end
end

eval(sprintf('cd ''%s''', WAVELABPATH));

clear MEX_OK isPC R
 
 
%
%  Part of Wavelab Version 850
%  Built Tue Jan  3 13:20:38 EST 2006
%  This is Copyrighted Material
%  For Copying permissions see COPYING.m
%  Comments? e-mail wavelab@stat.stanford.edu 
