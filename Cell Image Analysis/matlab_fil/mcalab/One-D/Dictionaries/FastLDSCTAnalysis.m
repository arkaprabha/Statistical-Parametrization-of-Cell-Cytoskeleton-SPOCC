function ldsct = FastLDSCTAnalysis(x,w,overlap,pars3)
% FastLDSCTAnalysis -- Local transform using a DCT-DST dictionary for 1D signals
%  Usage
%    ldsct = FastLDSCTAnalysis(x,w,overlap) 
%  Inputs
%    x        	1-d signal:  length(x)=2^J
%    overlap    blocks overlapping, fraction of the window width (>=0 & <1), 
%               eg: 0.75, 0.5, 0.25, 0.125
%    w        	width of window (must be a power of two)
%  Outputs
%    ldsct    	Local DSCT coefficients (structure array)
%  Description
%    The ldsct contains coefficients of the Local DSCT Decomposition.
% See Also
%   FastLDSCTSynthesis, dst, idst
%		

    if overlap < 0 | overlap >0.5
        error('The blocks overlapping must be >=0 and <=0.5');
    end
    
	[n,J] = dyadlength(x);
	
	d = floor(n/w);
	m = floor(w*overlap);
	
	ldsct = [struct('winwidth', w, 'overlap', overlap, 'coeff', zeros(d,1)) ...
		     struct('winwidth', w, 'overlap', overlap, 'coeff', zeros(2*(w+2*m),d))];
    
	xtmp  = [zeros(m,1);ShapeAsRow(x)';zeros(m,1)];
%
	for p=0:d-1
        xp = xtmp(p*w+1:(p+1)*w+2*m);
		cs = dst_i(xp)';            % DST analysis
        cc = dct(xp);               % DCT Analysis
		ldsct(2).coeff(:,p+1) = [cc;cs];   % store
	end


    

    
