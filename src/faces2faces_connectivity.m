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

function [Ctri] = faces2faces_connectivity(FV,faceConn);
% function [Ctri] = faces2faces_connectivity(FV,faceConn);
%
% Computes connectivity of faces to other faces in a tesselation
% 
% Input:
%   FV: the standard matlab structure for faces and vertices,
%         where FV.faces is m x 3, and FV.vertices is n x 3.
%   faceConn: faces connectivity of FV (use faces_connectivity function)
% Output:
%   Ctri:  nFaces x nFaces sparse matrix with nonzeros indicating triangle
%   connections
%
% See also FACES_CONNECTIVITY, VERTICES_CONNECTIVITY
%
% Author: Dimitrios Pantazis, November 2007 

%initialize
nVertices = size(FV.vertices,1);
nFaces = size(FV.faces,1);

%get columns of faces2faces connectivity matrix
cols = zeros(nFaces*5,1);
cols(1:5:nFaces*5)=1;
cols = cumsum(cols);

%get rows of faces2faces connectivity matrix
rows = zeros(nFaces*5,1);
for i = 1:nFaces
    verts = FV.faces(i,:);
    t = sort([faceConn{verts(1),:} faceConn{verts(2),:} faceConn{verts(3),:}]);
    %nei_tri = setdiff(t(~diff(t)),i);
    nei_tri = t(~diff(t));
    rows((i*5-4):(i*5-5)+length(nei_tri)) = nei_tri;
end

%remove zero elements
ndx = find(rows==0);
rows(ndx) = [];
cols(ndx) = [];

%make faces2faces connectivity matrix
Ctri = sparse(cols,rows,ones(size(cols)),nFaces,nFaces);
Ctri = spones(Ctri);
Ctri = Ctri-speye(size(Ctri));

%to find boundary vertices, use ndx = find(sum(Ctri)<3);

