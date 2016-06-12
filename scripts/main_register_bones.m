clc;clear all; close all;
restoredefaultpath;
addpath(genpath('..\src'));

%bone 1 gets warped
bone1=['C:\Users\ajoshi\Google Drive\MRI and Ground Truth Images\Volunteer3_GroundTruth.nii.gz'];
bone2=['C:\Users\ajoshi\Google Drive\MRI and Ground Truth Images\Volunteer2_GroundTruth.nii.gz'];
bone1vol=['C:\Users\ajoshi\Google Drive\MRI and Ground Truth Images\Volunteer3_VIBE_we.nii.gz'];
bone2vol=['C:\Users\ajoshi\Google Drive\MRI and Ground Truth Images\Volunteer2_VIBE_we.nii.gz'];
%generate_surfaces(bone1);
%generate_surfaces(bone2);

b1=load_untouch_nii_gz(bone1);
b1=resample_avw(b1,[128,128,128],'nearest');b1v=b1;

b2=load_untouch_nii_gz(bone2);
b2=resample_avw(b2,[128,128,128],'nearest');b2v=b2;

b2vol=load_untouch_nii_gz(bone2vol);
b2vol=resample_avw(b2vol,[128,128,128]);
b1vol=load_untouch_nii_gz(bone1vol);
b1vol=resample_avw(b1vol,[128,128,128]);

bv=b1;
SZ=size(b1.img);
res=b1.hdr.dime.pixdim(2:4);
[X,Y,Z]=ndgrid(1:size(b1.img,1),1:size(b1.img,2),1:size(b1.img,3));
X=(X-1)*res(1);Y=(Y-1)*res(2);Z=(Z-1)*res(3);labs=setdiff(unique(b1.img),0);
sub2bonevert=[];def_sub_atlas=[];
for lab=labs'
    
    b1=readdfs([bone1(1:end-7),sprintf('bone%d.dfs',lab)]);
    b2=readdfs([bone2(1:end-7),sprintf('bone%d.dfs',lab)]);

    tic;    
        w.vertices = register_pointset_icp(b1.vertices,b2.vertices,b2.faces);
    toc
   [k,d]=dsearchn(w.vertices,b1.vertices);
   d=bone1.vertices-w.vertices(k,:);
   d2(:,1)=smooth_surf_function(bone1,d(:,1),.8,.8);
   d2(:,2)=smooth_surf_function(bone1,d(:,2),.8,.8);
   d2(:,3)=smooth_surf_function(bone1,d(:,3),.8,.8);
  
    def_sub_atlas=[def_sub_atlas;(w.vertices-b2.vertices)];
    sub2bonevert=[sub2bonevert;b2.vertices];      

end

def_sub_atlas(:,1)=def_sub_atlas(:,1)/res(1);
def_sub_atlas(:,2)=def_sub_atlas(:,2)/res(2);
def_sub_atlas(:,3)=def_sub_atlas(:,3)/res(3);

sub_ind=sub2ind(SZ,round(sub2bonevert(:,1)/res(1)) +1,round(sub2bonevert(:,2)/res(2)) +1,round(sub2bonevert(:,3)/res(3)) +1);
xmap=zeros(SZ);
diffmap(:,1)=accumarray(sub_ind,def_sub_atlas(:,1), [SZ(1)*SZ(2)*SZ(3),1],@mean);
diffmap(:,2)=accumarray(sub_ind,def_sub_atlas(:,2), [SZ(1)*SZ(2)*SZ(3),1],@mean);
diffmap(:,3)=accumarray(sub_ind,def_sub_atlas(:,3), [SZ(1)*SZ(2)*SZ(3),1],@mean);

known_ind=unique(sub_ind);
diffmapx=diffmap(known_ind,1);
diffmapy=diffmap(known_ind,2);
diffmapz=diffmap(known_ind,3);

unknown_ind=setdiff(1:length(xmap(:)),known_ind);

[~,~,L] = laplacian(SZ,{'NN','NN','NN'});

I=speye(SZ(1)*SZ(2)*SZ(3)); I=I(known_ind,:);
alpha=1.000;
L=[L;alpha*I];
bx=[zeros(SZ(1)*SZ(2)*SZ(3),1);alpha*diffmapx];
by=[zeros(SZ(1)*SZ(2)*SZ(3),1);alpha*diffmapy];
bz=[zeros(SZ(1)*SZ(2)*SZ(3),1);alpha*diffmapz];
clear I X Y Z xmap
diffmap(:,1)=mypcg(L'*L,L'*bx,1e-16,6000,diag(L'*L)+eps,[],'v2');
diffmap(:,2)=mypcg(L'*L,L'*by,1e-16,6000,diag(L'*L)+eps,[],'v2');
diffmap(:,3)=mypcg(L'*L,L'*bz,1e-16,6000,diag(L'*L)+eps,[],'v2');

[X,Y,Z]=meshgrid(1:SZ(1),1:SZ(2),1:SZ(3));bw=b1v;
bw.img=interp3(double(b1v.img),X+reshape(diffmap(:,2),SZ),Y+reshape(diffmap(:,1),SZ),Z+reshape(diffmap(:,3),SZ),'nearest');
save_untouch_nii_gz(bw,[bone1(1:end-4),'_warped','.nii.gz']);
view_nii(bw);
view_nii(b2v)
view_nii(b1v)
save tmp21
bwvol.img=interp3(double(b1vol.img),X+reshape(diffmap(:,2),SZ),Y+reshape(diffmap(:,1),SZ),Z+reshape(diffmap(:,3),SZ));
bwvol.hdr=b2vol.hdr;
save_nii(bwvol,[bone1vol(1:end-4),'_warped','.nii.gz']);

b2volo=load_untouch_nii_gz(bone2vol);b2labo=load_untouch_nii_gz(bone2);
b1volo=load_untouch_nii_gz(bone1vol);b1labo=load_untouch_nii_gz(bone1);

reso=b1volo.hdr.dime.pixdim(2:4);

xmap=resample_vol(X+reshape(diffmap(:,2),SZ),size(b2volo.img));
ymap=resample_vol(Y+reshape(diffmap(:,1),SZ),size(b2volo.img));
zmap=resample_vol(Z+reshape(diffmap(:,3),SZ),size(b2volo.img));
xmap=xmap*size(b1volo.img,2)/SZ(2);
ymap=ymap*size(b1volo.img,1)/SZ(1);
zmap=zmap*size(b1volo.img,3)/SZ(3);


bwvol.img=interp3(double(b1volo.img),xmap,ymap,zmap);
bwvol.hdr=b2volo.hdr;
save_nii(bwvol,[bone1vol(1:end-7),'_warped','.nii.gz']);

bwlab.img=interp3(double(b1labo.img),xmap,ymap,zmap,'nearest');
bwlab.hdr=b2labo.hdr;
save_nii(bwlab,[bone1(1:end-7),'_warped','.nii.gz']);


