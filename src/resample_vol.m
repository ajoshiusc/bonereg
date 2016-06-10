function vs=resample_vol(v,Msizes,method)
if ~exist('method','var')
    method='linear';
end
Msize=size(v);

if (length(Msize)<3)
    
    rx=(Msize(1)-1)/(Msizes(1)-1);ry=(Msize(2)-1)/(Msizes(2)-1);
    
    [xx,yy]=ndgrid(1:rx:Msize(1),1:ry:Msize(2));
    
    vs=interp2(v,yy,xx,method);
    
else
    
    rx=(Msize(1)-1)/(Msizes(1)-1);ry=(Msize(2)-1)/(Msizes(2)-1);rz=(Msize(3)-1)/(Msizes(3)-1);
    if rx==1 && ry==1 &&rz==1
        vs=v;
    else
        %[xx,yy,zz]=ndgrid(1:rx:Msize(1),1:ry:Msize(2),1:rz:Msize(3));
        [xx,yy,zz]=ndgrid(double(1:rx:Msize(1)),double(1:ry:Msize(2)),double(1:rz:Msize(3)));
        if strcmp(method,'linear')
            vs=trilinear(double(v),yy,xx,zz);
        else
            vs=interp3(double(v),yy,xx,zz,method);
        end
    end
end
