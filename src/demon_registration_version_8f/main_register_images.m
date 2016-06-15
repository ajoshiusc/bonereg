clc;clear all;close all;restoredefaultpath;
addpath(genpath('C:\Users\ajoshi\Downloads\demon_registration_version_8f'));
addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\src'));
addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\3rdParty'));
addpath(genpath('C:\Users\ajoshi\Documents\coding_ground\svreg-matlab\MEX_FILES'));

v1=load_nii_BIG_Lab('E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\subject1.nii.gz');
v1msk=(v1.img>0);v1.img(v1msk)=(v1.img(v1msk)-min(v1.img(v1msk)));
v1.img(v1msk)=128*v1.img(v1msk)/median(v1.img(v1msk));
v1.img(v1msk)=max(v1.img(v1msk))-v1.img(v1msk);
save_untouch_nii_gz(v1,'E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\subject1_inv.nii.gz');


v_fixed=load_nii_BIG_Lab('E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\R15-562 DFP D01 DiffDTI Seg4NEX2_rotated.pvc.label.nii.gz');
v_moving=load_nii_BIG_Lab('E:\sipi_data\mouse_atlas\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_T2star_v1.01_masked2.pvc.label.nii.gz');%WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_T2star_v1.01_masked.nii.gz');

Op.Registration='NonRigid';
%Op.SigmaDiff=1*16;
Op.SigmaFluid=4*8; %4*8 was best
[Ireg,map]=register_demons_hires(v_moving,v_fixed,Op);


%save tmp1
save_untouch_nii_gz(Ireg,'E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\warped_atlas.pvc.frac.nii.gz');

v_moving_lab=load_nii_BIG_Lab('C:\Users\ajoshi\Google Drive\Downloads_04_26_2016\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_atlas_v2_pack\WHS_SD_rat_atlas_v2.nii.gz');

Ireg.img=interp3(double(v_moving_lab.img),map(:,:,:,1),map(:,:,:,2),map(:,:,:,3),'nearest');
Ireg.hdr.dime.bitpix = 16;
Ireg.hdr.dime.datatype = 4;
save_untouch_nii_gz(Ireg,'E:\sipi_data\CMGI-Joshi\CMGI-Joshi\Rat HighRes\warped_atlas.hlabel.nii.gz');
