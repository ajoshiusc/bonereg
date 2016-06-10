function generate_surfaces(bone1)

b1=load_nii(bone1);
res=b1.hdr.dime.pixdim(2:4);
[X,Y,Z]=ndgrid(1:size(b1.img,1),1:size(b1.img,2),1:size(b1.img,3));
X=(X-1)*res(1);Y=(Y-1)*res(2);Z=(Z-1)*res(3);labs=setdiff(unique(b1.img),0);
for lab=labs'
    b1img=double(b1.img==lab);b1img=imfill(b1img,'holes');
    s1=isosurface(X, Y, Z, b1img,.5);
    view_patch(s1);
    b1img=smooth3(b1img,'gaussian',[9,9,9],1.5);
    s1sm=isosurface(X, Y, Z, b1img,.5);
    s1sm=reducepatch(s1sm,10000);
    s1sm=myclean_patch_cc(s1sm);
    s1sm=smooth_cortex_fast(s1sm,.1,1);
    view_patch(s1sm);
    writedfs([bone1(1:end-3),sprintf('bone%d.dfs',lab)],s1sm);
end


