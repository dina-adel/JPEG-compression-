function pixelarray = Idct_2(coefficients)
%given a block matrix of dct coefficients , returns a matrix with
% the inverse dct (pixel values)

%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_idct; t_idct=0; %trackning FLOPS

[m n]=size(coefficients);
% i & j are used to index the retrieved pixel mtrix 
for i = 0: m-1
    for j = 0: n-1 
        sum = 0.0; 
        % looping over the coefficients mtrix
        for u = 0:m-1
            for v = 0:n-1
                
            
            % multiplying the bases by their coefficents and summing to get
            % each pixel 
            L = coefficients(u+1,v+1);
            idct = (L * cos(((2 * i + 1) * u * pi )/ (2*m)) *cos(((2 * j + 1) * v * pi )/ (2*n)));
            sum =sum+ idct; %t_idct=t_idct+15;
            end              
            end

        pixelarray(i+1,j+1) =  sum;
                 
    end
end
%fprintf('FLOPS_DCT = %d \n', t_idct);

end

