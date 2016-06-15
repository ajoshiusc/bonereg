% clc;clear all;close all;restoredefaultpath;
% addpath(genpath('C:\Users\ajoshi\Downloads\demon_registration_version_8f'));
% addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\src'));
% addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\3rdParty'));
% addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\MEX_FILES'));
% 
% v_fixed=load_nii_BIG_Lab('E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\R15-562 DFP D01 DiffDTI Seg4NEX2_rotated.pvc.frac.nii.gz');
% 
% v_moving=load_nii_BIG_Lab('C:\Users\ajoshi\Google Drive\Downloads_04_26_2016\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_T2star_v1.01_masked.pvc.frac.nii.gz');%WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_T2star_v1.01_masked.nii.gz');
% %v_labs=load_nii_BIG_Lab('C:\Users\ajoshi\Google Drive\Downloads_04_26_2016\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_atlas_v2_pack\mouse_atlas.nii.gz');

function [Ireg,map]=register_demons_hires(v_moving,v_fixed,Op)

v_moving_orig=v_moving; v_fixed_orig=v_fixed;
v_moving_orig.img=double(v_moving_orig.img);
v_fixed_orig.img=double(v_fixed_orig.img);

v_fixed=resample_avw(v_fixed,[128,128,128]);
v_moving=resample_avw(v_moving,[128,128,128]);
vreg=v_fixed;
v_moving.img=double(v_moving.img);
v_fixed.img=double(v_fixed.img);

tic
%Op.Registration='Affine';
%Op.Alpha
[vreg.img,Bx1,By1,Bz1]=register_volumes(v_moving.img,v_fixed.img,Op);
h=toc;
%save tmp
%vreg.img=movepixels(v_moving.img,Bx1,By1,Bz1);
[X,Y,Z]=meshgrid(1:128,1:128,1:128);
vreg.img=interp3(v_moving.img,X+By1,Y+Bx1,Z+Bz1);
MSz=size(v_moving_orig.img);MSz1=size(v_moving.img);
FSz=size(v_fixed_orig.img);
Bx=resample_vol(Bx1,FSz);By=resample_vol(By1,FSz);Bz=resample_vol(Bz1,FSz);
Bx=Bx*MSz(1)/MSz1(1);By=By*MSz(2)/MSz1(2);Bz=Bz*MSz(3)/MSz1(3);
Ireg=v_fixed_orig;
[X,Y,Z]=meshgrid(1:FSz(2),1:FSz(1),1:FSz(3));X=X*MSz(2)/FSz(2);Y=Y*MSz(1)/FSz(1);Z=Z*MSz(3)/FSz(3);
Ireg.img=interp3(v_moving_orig.img,X+By,Y+Bx,Z+Bz);
% Ireg.img=movepixels(v_moving_orig.img,Bx,By,Bz);%,3);
map(:,:,:,1)=X+By;map(:,:,:,2)=Y+Bx;map(:,:,:,3)=Z+Bz;

%save_untouch_nii_gz(Ireg,'C:\Users\ajoshi\Downloads\CMGI-Joshi\CMGI-Joshi\Rat HighRes\atlas_warped.nii.gz');
%save tmp


