% ECE4076 - Lab 02
% Image Segmentation through K means clustering
%
% Author: Pasan Wickramarathna
% ID : 28979095
% Last Modified on: 9/4/2021
%
clc; %clear command window
close all; % close all the active windows
clear; %clean the workspace
workspace;  % Make sure the workspace panel is showing.
fontsz = 16; %define constant variables

%1.1 - Importing the RGB Image
I = imread('mandrill.jpg');
Img = double(I); % Convert for easier of mathematical calculations
%Preview the Original Image
figure, imshow(I, []);
title('Original Image', 'FontSize', fontsz);

%Prompt user to specify number of clusters
%Initial k value needs to be set to four as we are asked to select four
%random pixels
k = input('Enter the number of k clusters: ');

%Reshaping the Image matrix into easily processable matrix shape
%where rows of X are number of pixels and three columns corresponds to
%R,G,B values
s = size(Img);
if length(s) == 3 %check it is RGB image
    x = reshape(Img, s(1)*s(2), 3); % 512x512 rows and 3 columns
else %Error:enter RGB
    print('Please enter RGB Image');
end
%Total number of pixels
N = size(x,1);
%{
%Extra - Visualizing the Pixels in RGB 3D space
X = x(:,1);
Y = x(:,2);
Z = x(:,3);
figure, scatter3(X,Y,Z,'filled');
xlabel('R');
ylabel('G');
zlabel('B');
view(-30,10)
%}

%Creating randomly generated k number of cluster means
%randperm(n,k) returns row vector containing k unique solutions randomly selected from 1 to n.
seed = 29;
rng(seed)
idx = randperm(N, k);
%Assign the image pixel indices to form k number of mean values
mean_val = x(idx,:);

%Initialize Iterations to assign each pixel to its closet mean
temp=0;
str = 'Y';
while str=='Y'
    %Pre allocate two matrices to store distance and cluster groups
    d = zeros(N, k);
    cluster_grp = zeros(N, k);
    tic
    for i = 1:N %Loop through each pixel to calculate distance
        for j  = 1:k
            d(i,j) = (x(i,:)- mean_val(j,:))*(x(i,:) - mean_val(j,:))'; 
            %An 1xk array of distances between eachcluster means and each pixel
        end
        %End of each pixel, retriete minimum value
        [min, Idxmin] = max(-d(i,:)); %let's take index for minimum distance
        cluster_grp(i, Idxmin) = 1; %While other indices remain zero
    end
    
    %Define cost function to update k number of means,
    cost_f = 0;
    cluster_sum = zeros(1,k); %Stores summation of pixels in each cluster
    for i = 1:N
        for j = 1:k
            cost_f = cost_f + cluster_grp(i,j)*d(i,j); %create a cost function
        end
        cluster_sum = cluster_sum + cluster_grp(i,:); 
        %Cluster sum is useful to update the mean values
    end
    
    %Two steps cluster means update
    for i=1:N
        for j =1:k
            cond = cluster_grp(i,j)*x(i,:);
            if (cond == zeros(1,3)) %If cluster summation is zero, do nothing
            else
                mean_val(j,:) = mean_val(j,:)+cond; 
                %Update the means - first step - Summation of  N of pixel values
                %Sigma(coressponding cluster grp * pixel rgb value)until N
            end 
        end
    end
    
    for i =1:k
        if cluster_sum(i) ~=0 %To avoid infinity problem (otherwise summation goes to infinty)
            mean_val(i,:) = mean_val(i,:)/cluster_sum(i); 
            %Update the means - second step - divide by total sum
            %new_mean_val = Sigma(coressponding cluster grp * pixel rgb value)/Sigma(cluster sum)
        end
    end
    
    %Visualize the RESULTS in 3D Space
    % plot the data with the current means
%     figure;
%     scatter3(x(:,1),x(:,2),x(:,3),'.','b');
%     xlabel('R');
%     ylabel('G');
%     zlabel('B');
% 
%     hold on
%     scatter3(mean_val(:,1),mean_val(:,2),mean_val(:,3),'filled','r');

    % plot pixels allocated to the means in different colors
    figure;
    for i = 1:k
    scatter3(x(find(cluster_grp(:,i)),1),x(find(cluster_grp(:,i)),2),x(find(cluster_grp(:,i)),3),'*');
    hold on
    end
    hold on 
    scatter3(mean_val(:,1),mean_val(:,2),mean_val(:,3),'filled','k');
    xlabel('R');
    ylabel('G');
    zlabel('B');
    title('cluster distribution');
    %Create Color coded image
    output = zeros(s(1),s(2),3);
    p=0;q=1;
    for i = 1:N
      [~,Idxcluster] = max(cluster_grp(i,:)); %Finding corresponding cluster value in cluster group
      output(i-p,q,1) = mean_val(Idxcluster,1);
      output(i-p,q,2) = mean_val(Idxcluster,2);
      output(i-p,q,3) = mean_val(Idxcluster,3);
      if i-p == s(1) %Proceeds to next array of pixels
        p = p + s(1);
        q = q + 1;
      end
    end
    
    %Show color coded final image
    figure, imshow(uint8(output));
    title('Color coded Image', 'FontSize', fontsz);
    
    %Prompt user to continue iteration
    prompt = 'Do you want to repeat the process [Y/N]: ';
    str = input(prompt, 's');
    toc
end






