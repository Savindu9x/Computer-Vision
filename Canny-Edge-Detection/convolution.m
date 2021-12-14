function C = convolve(image, kernel)

%extracting image rows and coloumns 
[i_r,i_c] = size(image);      
[k_r,k_c] = size(kernel);   

C = zeros(i_r, i_c);    

t = 0;

for n = 1:(i_r-k_r+1)
    for k = 1:(i_c-k_c+1)
        tempIm = image(n:n + k_r - 1, k: k + k_c - 1);
        for m = 1: (k_r * k_c)
            t = t + tempIm(m) * kernel(m);
        end
        C(n+1,k+1)= t;
        t = 0;
    end
end

end


 

        