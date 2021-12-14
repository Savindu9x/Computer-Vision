clc; close all; clear all;

% Loading image
image = imread('mandrill.jpg');
image = double(image);
[row, col, dim] = size(image);

k = 4;
k_means = zeros(k, dim);

% Random Number Generator
rng('shuffle');
row_index = randi([1 row]);
rng('shuffle');
col_index = randi([1 row]);
k_means(1, 1) = image(row_index, col_index, 1);
k_means(1, 2) = image(row_index, col_index, 2);
k_means(1, 3) = image(row_index, col_index, 3);

image_reshaped = reshape(image, [], 3);

% Calculating Euclidean distance between first mean point and every other point
distance = zeros((row*col), k);

for i = 1:(k-1)
    for j = 1:i
        distance(:,j) = sqrt(sum(((image_reshaped - k_means(j,:)).^2),2));
    end
    %minimum ditance value
    minimum_distance = min(distance(:, 1:i), [], 2);
    %probability of selecting the data point 
    probability = (minimum_distance.^2) / sum(minimum_distance.^2);
    %Randomly draw a new mean colour value based on the computed probability distribution.
    dist = cumsum(probability);%cumsum to calculate cumulative probability
    rng('shuffle');%creates a different seed every time 
    %generating random number between 0 and 1 
    rnd = rand();
    %find first element number > cumulative probability
    distance_mean = dist(dist(:, 1) >= rnd); 
    distance_index = find(dist >= distance_mean(1));
    distance_index = distance_index(1);
    k_means(i + 1, :) = image_reshaped(distance_index, :);
end
%---------------------------------------
counter = 0;
previous_mean = zeros(size(k_means));
distance = zeros((row*col), k);
err = 1;
image_new = image;

while (abs(err) > 0.1)
    for n = 1:k
        distance(:,n) = sqrt(sum(((image_reshaped - k_means(n,:)).^2),2));
    end
    
    [minimum_distance, minimum_distance_index] = min(distance');
    colour_index = [image_reshaped minimum_distance_index'];
    previous_mean = k_means;
    
    % dynamic plot
    figure_1 = figure(1);
    for i = 1:k
        rgb = k_means./255; 
        newcolors = [rgb(1,1) rgb(1,2) rgb(1,3); rgb(1,1) rgb(1,2) rgb(1,3); rgb(2,1) rgb(2,2) rgb(2,3); rgb(2,1) rgb(2,2) rgb(2,3); rgb(3,1) rgb(3,2) rgb(3,3); rgb(3,1) rgb(3,2) rgb(3,3); rgb(4,1) rgb(4,2) rgb(4,3); rgb(4,1) rgb(4,2) rgb(4,3)];
        set(groot,'defaultAxesColorOrder', newcolors);
        tmp = image_reshaped(colour_index(:, 4) == i, 1:3);
        tmp_fil = tmp(100:100:end, :);
        figure_1 = plot3(k_means(i, 1), k_means(i, 2), k_means(i, 3), '*', tmp_fil(:, 1), tmp_fil(:, 2), tmp_fil(:, 3), '.', 'MarkerSize', 10);
        hold on;
    end 
    
    hold off;    
    title('Visualising Reuslts')
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');   
    
    for n = 1:k
        k_means(n, :) = mean(colour_index (colour_index(:, 4) == n, 1:3));
    end
    
    image_new = colour_index;
    
    for n = 1:k
        temp = image_new(image_new(:, 4) == n, :);
        image_new(image_new(:, 4) == n, 1:3) = repmat(k_means(n, :), [length(temp) 1]);
    end
    
    image_new = reshape(image_new(:, 1:3), [row col 3]);
    
    counter = counter + 1;
    err = previous_mean - k_means;
    err = sum(err(:)); 
end

figure(2);
imshow(uint8(image_new));
title('New Image')
