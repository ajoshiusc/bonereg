clc;clear all; close all;
restoredefaultpath;
addpath(genpath('..\src'));

bone1vol=['C:\\Users\ajoshi\\Google Drive\\MRI Segmentation Dataset\\Healthy Men\\Volunteer2_OA_Study.nii.gz'];
vatlas=load_nii(bone1vol);
bone1lab=['C:\\Users\ajoshi\\Google Drive\\MRI Segmentation Dataset\\Healthy Men\\Volunteer2_OA_Study_mask.nii.gz'];
vatlas_lab=load_nii(bone1lab);
vatlaso=vatlas;
for jj=3:4
%     bonew=sprintf('C:\\Users\\ajoshi\\Google Drive\\MRI and Ground Truth Images\\Volunteer%d_VIBE_we_warped.nii.gz',jj);
%     bone_lab=sprintf('C:\\Users\\ajoshi\\Google Drive\\MRI and Ground Truth Images\\Volunteer%d_GroundTruth_warped.nii.gz',jj);
% 
%     v=load_nii(bonew);v_lab=load_nii(bone_lab);
%     vatlas.img=vatlas.img+v.img;
%     vatlas_lab.img=vatlas_lab.img+v_lab.img;
    
    bonew=sprintf('C:\\Users\\ajoshi\\Google Drive\\MRI Segmentation Dataset\\Healthy Men\\Volunteer%d_OA_Study.nii.gz',jj);
    vmov=load_nii(bonew);
    Op.Registration='Affine';
    [Ireg,map]=register_demons_hires(vmov,vatlaso,Op);
    Ireg.img(~isfinite(Ireg.img(:)))=0;
    vatlas.img=double(vatlas.img)+double(Ireg.img);
    
    bone_lab=sprintf('C:\\Users\\ajoshi\\Google Drive\\MRI Segmentation Dataset\\Healthy Men\\Volunteer%d_OA_Study_mask.nii.gz',jj);
    vlab=load_nii(bone_lab);
    labs=interp3(vlab.img,map(:,:,:,1),map(:,:,:,2),map(:,:,:,3),'nearest');
    labs(~isfinite(labs(:)))=0;
    vatlas_lab.img=vatlas_lab.img+labs;
    save(sprintf('C:\\Users\\ajoshi\\Google Drive\\MRI and Ground Truth Images\\Volunteer%d_map.mat',jj),'map');
end

view_nii(vatlas);
view_nii(vatlas_lab);

save_nii(vatlas,'C:\\Users\\ajoshi\\Google Drive\\MRI and Ground Truth Images\\avg_atlas_intensity.nii.gz');
save_nii(vatlas_lab,'C:\\Users\\ajoshi\\Google Drive\\MRI and Ground Truth Images\\avg_atlas_labels_intensity.nii.gz');

