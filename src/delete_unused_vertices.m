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
% along with SVREG.  If not, see <http://www.gnu.org/licenses/>.

function [surf,UsedV]=delete_unused_vertices(surf)
%Author Anand A. Joshi ajoshi@sipi.usc.edu
%UsedV=reshape(surf.faces,size(surf.faces,1)*3,1);
UsedV=surf.faces(:);
UsedV=unique(UsedV);

%usedmarker=zeros(size(surf.vertices,1),1); usedmarker(UsedV)=1;
new_indx=zeros(size(surf.vertices,1),1);
%num_used=sum(usedmarker);
num_used=size(UsedV,1);
new_indx(UsedV)=[1:num_used];

surf.vertices=surf.vertices(UsedV,:);
surf.faces=new_indx(surf.faces);
