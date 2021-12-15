%Author:  Pasan Wickramarathna
%Last Modified on 11/5/2021

clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.
fontSz = 16;

%Importing the image (Format of NxMx3)
img_1 = imread('im1.jpg');
img_2 = imread('im2.jpg');
img_3 = imread('im3.jpg');
img_4 = imread('im4.jpg');
double_wide = [img_1, img_2];

figure(1);
imshow(double_wide)
title('Double-Wide');
hold on

%%
% Task 02&03 - Visualize SIFT keypoint locations
sift_1 = importdata('im1.sift');
sift_2 = importdata('im2.sift');
sift_3 = importdata('im3.sift');
sift_4 = importdata('im4.sift');

sift_1_x = sift_1(:,1);
sift_1_y = sift_1(:,2);
sift2_x = sift_2(:,1);
sift2_y = sift_2(:,2);

plot(sift_1_x, sift_1_y, 'rx');
plot(sift2_x + 640, sift2_y, 'rx');

%% Task 04 & 05  - Match SIFT keypoints

feature_match(double_wide, sift_1, sift_2);
feature_match(double_wide, sift_1, sift_2);
feature_match(double_wide, sift_1, sift_2);
%% Task 6 - Stereo Reconstruction

%Part_01 & Part_02
[valid_pts1_2, baseline1_2] = triangulte_depth(sift_1,sift_2);
[valid_pts1_3, baseline1_3] = triangulte_depth(sift_1,sift_3);
[valid_pts1_4, baseline1_4] = triangulte_depth(sift_1,sift_4);

figure()
scatter3(valid_pts1_2(:,1),valid_pts1_2(:,2),valid_pts1_2(:,3));
xlabel('x');
ylabel('y');
zlabel('z');
hold on
scatter3(valid_pts1_3(:,1),valid_pts1_3(:,2),valid_pts1_3(:,3));
scatter3(valid_pts1_4(:,1),valid_pts1_4(:,2),valid_pts1_4(:,3));
legend('img_1 - img_2','img_1 - img_3','img_1 - img_4');
title('Reconstructed 3D points');
hold off

function feature_match(double_wide, sift_1, sift_2)

figure();
imshow(double_wide);
title('Green lines joining the matching keypoints with nearest match');
hold on
count = 1;

sift_1_x = sift_1(:,1);
sift_1_y = sift_1(:,2);

sift2_x = sift_2(:,1);
sift2_y = sift_2(:,2);

plot(sift_1_x, sift_1_y, 'rx');
plot(sift2_x + 640, sift2_y, 'rx');

for i = 1 : size(sift_1, 1) %iteration through img1
    descp1 = sift_1(i, 5:end); %descripter vector img 1
    descp2 = sift_2(i, 5:end); %descriptor vector img 2
    d1 = sqrt(sum((descp2 - descp1).^2, 2)); % calculating euclidean distance
    d2 = d1; %assign the value for later use
   for j = 1 : size(sift_2, 1) %iteration through img2
        descp2 = sift_2(j, 5:end);
        d = sqrt(sum((descp2 - descp1).^2, 2)); 
        
        if (d < d1 && d < d2)
           tmp = d1;
           d1 = d;
           d2 = tmp;
           match = [i j];
        elseif(d < d2)
            d2 = d;          
        end
      
   end
   if ((d1/d2) < 0.5) %if match is valid
       indices(count, :) = match;
       count = count + 1;
       hold on;
       plot([sift_1(match(1), 1) sift_2(match(2), 1) + 640], [sift_1(match(1), 2) sift_2(match(2), 2)], 'g-');      
   end
end
hold off

end
