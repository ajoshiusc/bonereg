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

function TRIn = myclean_tri(TRI1)
%Author: Anand A Joshi ajoshi@sipi.usc.edu
A = sort(TRI1,2);
[B,I,J] = unique(A,'rows');
TRI = TRI1(I,:);
%disp(sprintf('%d duplicates!!',size(TRI1,1)-size(TRI,1)));
S=(abs(TRI(:,1)-TRI(:,2))>0)+(abs(TRI(:,2)-TRI(:,3))>0)+(abs(TRI(:,1)-TRI(:,3))>0);
I=find(S==3);
%disp(sprintf('%d duplicate vertices!!',size(TRI,1)-size(I,1)));
TRIn=TRI(I,:);