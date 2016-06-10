% Copyright 2010 Anand A. Joshi, David W. Shattuck and Richard M. Leahy 
% This file is part SVREG.
% 
% SVREG is free software: you can redistribute it and/or modify
% it under the terms of the GNU Lesser General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% SVREG is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU Lesser General Public License for more details.
% 
% You should have received a copy of the GNU Lesser General Public License
% along with BSE.  If not, see <http://www.gnu.org/licenses/>.

function [surf_sm,A,VC]=smooth_cortex_fast(surf,a,nIterations,A)
% function [surf_sm,A]=smooth_cortex_fast(surf,a,nIterations,A)
%
% Smooths a surface
%
% Input:
%   surf: surface to smooth
%   a: scalar smooth weighting parameter (0-1 less-more smoothing)
%   nIterations: number of times to apply the smoothing

%calculate smoothing matrix
if ~exist('A','var')
    [vertConn,VC] = vertices_connectivity_fast(surf);
    A=spones(VC);
    A=spdiags((a./sum(A))',0,size(A,1),size(A,2))*A;
    A=A+spdiags((1-a)*ones(size(A,1),1),0,size(A,1),size(A,2));
end

%smooth
surf_sm = surf;
for i = 1:nIterations
    surf_sm.vertices=A*surf_sm.vertices;
end


