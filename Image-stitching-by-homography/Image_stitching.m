%Author:  Pasan Wickramarathna
%Last Modified on 27/4/2021

clc;  % Clear command window.
clear;  % Delete all variables.
close all;  % Close all figure windows except those created by imtool.
imtool close all;  % Close all figure windows created by imtool.
workspace;  % Make sure the workspace panel is showing.
fontSz = 16;

%Importing the image (Format of NxMx3)
left_img = imread('left.jpg');
right_img = imread('right.jpg');

points4left = [338,197,1; 
               468,290,1; 
               253,170,1; 
               263,256,1; 
               242,136,1];

figure, imshow(left_img);
axis on
title('Left Image with Test Points');
for i = 1: size(points4left, 1)
    hold on
   plot(points4left(i,1),points4left(i,2), 'rx','MarkerSize', 12, 'LineWidth', 2);
end
        
%%
%Task 02

%defining homography
H= [1.6010,-0.0300,-317.9341;
    0.1279,1.5325,-22.5847;
    0.0007,0,1.2865];

%H is 3x3 matrix, transpose of points4left is 3x5, transpose of final
%matrix is 5x3
points4right = (H*(points4left)')';

%Normalizing the resulting points
points4right = points4right(:,1:3)./points4right(:,3);

figure, imshow(right_img);
axis on
title('Right Image with Test points');
for i = 1: size(points4right, 1)
    hold on
   plot(points4right(i,1),points4right(i,2), 'rx','MarkerSize', 10, 'LineWidth', 2);
end     


%%
%Task 03 - Bilinear interpolation
%Perform Bilinear interpolation of right image
for i=1: size(points4right, 1)
    intensity= bilinear(points4right(i,1:2), right_img);
    fprintf("point %d intensity value: %d\n\n",i,intensity);
end

 
%%
%Task 04 - Image Stiching
%Create new image
new_img = zeros(384, 1024);
new_img(1:size(left_img,1), 1:size(left_img,2)) = left_img; %Filling LHS with left image


for i = 1: 384
    for j = 1:1024
        trans_cord  = (H*[j,i,1]')';
        trans_cord(1:3)= trans_cord(1:3)/trans_cord(3); %Normalization
        new_cord(j,:) = trans_cord;

       %check if transformed coordinates exist in right image
       if((trans_cord(1)>=1 && trans_cord(1)<=512) && (trans_cord(2)>= 1 && trans_cord(2)<= 384) )
           %if exist, perform bilinear interpolation
           new_img(i,j)= bilinear(trans_cord(1:2),right_img);
       elseif(j<=512)
           %if doesn't exist, but still in the range of left image
           new_img(i,j) = left_img(i,j);
       else 
           %If size larger than left image, replace it with zero
           new_img(i,j) = 0;
       end
    end
end


figure,imshow(uint8(new_img));
title('Final Image after stitching');

%%
%Task 05 - Improving the visual Quality

%Adjust the width to remove the black pixels from the image
break_ = 0;
for i = 1:1024
    if(new_img(1,i)== 0)
        break_ = i;
        break;
    end
end

enhanced_img = new_img(:,1:break_);
figure,imshow(uint8(enhanced_img));
title('Image after removing black pixels');
%Scaling it from factor of 1.2
enhanced_img = enhanced_img*1.3;
figure,imshow(uint8(enhanced_img));
title('Image after Increasing the brightness of factor 1.3');
%Applying alpha blending near the seam
[row,~] = size(enhanced_img);

max_iter = 3;
for iter = 1:max_iter
    for i=1:row
            alpha=1;
            for j=1:size(left_img,2)
              alpha = alpha - (1/(size(left_img,2)));
              enhanced_img(i,j)= alpha*left_img(i,j) + (1-alpha)*enhanced_img(i,j); 
            end
    end
end

figure,imshow(uint8(enhanced_img));
title('Image after three iteration of alpha blending');

