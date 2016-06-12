function v = view_vol(v1)
%unix(sprintf('/home/ajoshi/sipi/AIR5.2.5/bin/makeaheader temp.hdr 0 %d %d %d %g %g %g',Msize(1),Msize(2),Msize(3),res(1),res(2),res(3)));
v=make_nii(v1);

%v.hdr.dime.dim(2:4)=Msize;

%v.hdr.dime.pixdim(2:4)=res;
%v.img=v1;

view_nii(v);


