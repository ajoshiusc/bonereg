function [mRegistered,mER] = register_pointset_icp(mTarget,mTemplate,mTemplateTri)
% This performs iterative closest point-based rigid registration between the two
% 3D datasets whose vertices are specified in mTarget and mTemplate
% mTarget: Target point-set, nx3 dimensions
% mTemplate: Template point-set, nx3 dimensions
% mRegistered: Registered point set, nx3 dimensions
%% Compute rotation and translation matrices using the iterative closest point method
%[mR,mT,mER] = icp(mTarget',mTemplate','Minimize','point','Triangulation',mTemplateTri);
[mR,mT,mER] = icp(mTarget',mTemplate',100);
mRegistered = (mR*mTemplate')';
mRegistered = [mRegistered(:,1)+mT(1)  mRegistered(:,2)+mT(2)  mRegistered(:,3)+mT(3)];

%% Display
figure;plot3(mTarget(:,1),mTarget(:,2),mTarget(:,3),'.b'); title('b:moving, r:target, g:warped');
hold on
plot3(mTemplate(:,1),mTemplate(:,2),mTemplate(:,3),'.r')
plot3(mRegistered(:,1),mRegistered(:,2),mRegistered(:,3),'.g');axis equal;
display(sprintf('The error is %f',mER))