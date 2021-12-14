%Created by Pasan Savindu Wickramarathna
%Last Modified on 13/3/2021

clc;close all;clear all;

%Importing the sample Image
I = imread('test00.png');
img = double(I);
imshow(uint8(img))

%%
%Task 01 - implementing Gausssian Blur

%Defining 5x5 gaussian kernal
kernel = (1/159)*[2 4 5 4 2; 4 9 12 9 4; 5 12 15 12 5;4 9 12 9 4;2 4 5 4 2];
%Performing Convolution manually
c = conv2(kernel, img)
%c = convolve(img, kernel);
figure, imshow(c, [0, 255])
title('After Gaussian Kernel','FontSize', 11);

%%
%Task 02 - Calculate image gradient

deriv_x = [-1 0 1; -2 0 2; -1 0 1]; %horizantal sobel kernel
deriv_y = deriv_x'; %Transpose sobel kernal

%Perform convolution in X and Y direction
G_x = convolve(img, deriv_x);
G_y = convolve(img, deriv_y);
figure, imshow(G_x, [])
axis on;
title('After horizantal kernel','FontSize', 11);
figure, imshow(G_y, [])
axis on;
title('After vertical sobel kernel','FontSize', 11);

%%
%Task 03 - Calculate the Gradient Magnitude
G_mag = sqrt(G_x.^2 + G_y.^2);
figure, imshow(G_mag,[]) %displaying
title('Gradient Magnitude','FontSize', 11);

%%
%Task 04 - Gradient Orientation
grad_ = rad2deg(atan2d(G_y, G_x));
grad_ = wrapTo360(grad_); %make all 0 to 360
%round up to neareast 45 degrees
G_grad = round((grad_)./45).* 45;
figure, imagesc(G_grad)
title('Gradient orientation with color coding','FontSize', 11);

%%
%Task 05 - Non-Maxima Suppression and threshodling
%For edge thinging, we use Gradient magnitude thresholding
%so it compares the edge strength with the nearby pixel

%Initialize the Final Output
[raw,col] = size(G_mag)
G_Final = G_mag;

for i = 2 : (raw-1)
    for h = 2 : (col-1)
        if (G_grad(i,h)== 0 || G_grad(i,h)==180 || G_grad(i,h)==360)
            if (G_mag(i,h) <= G_mag(i,(h+1)) || G_mag(i,h) <= G_mag(i,(h-1)))
                G_Final(i,h) = 0;
            end
        elseif (G_grad(i, h) ==45 || G_grad(i, h)==225)
            if (G_mag(i,h) <= G_mag((i-1),(h+1)) || G_mag(i,h) <= G_mag((i+1), (h-1)))
                G_Final(i,h)= 0;
            end
        elseif (G_grad(i, h) ==90 || G_grad(i, h)==270)
            if (G_mag(i,h) <= G_mag((i-1),(h)) || G_mag(i,h) <= G_mag((i+1), (h)))
                G_Final(i,h)= 0;
            end 
        elseif (G_grad(i, h) ==135 || G_grad(i, h)==315)
            if (G_mag(i,h) <= G_mag((i-1),(h-1)) || G_mag(i,h) <= G_mag((i+1), (h+1)))
                G_Final(i,h)= 0;
            end 
        end
    end
end

figure, imshow(G_Final, [])
title('Non-maxima Suppression','FontSize', 11);
%Threshold the values
G_Final(G_Final<50) =0;
G_Final(G_Final>=50) =1;

figure, imshow(G_Final)
title('Double Suppression','FontSize', 11);

