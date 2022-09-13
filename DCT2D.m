function coefficients = DCT2D(pixel_mat)
% given a block matrix of pixels, this function Returns the DCT coeeficients 
%in a marix of the same size 
[m, n]=size(pixel_mat);
%to track # of FLOPs uncomment all lines with 't_'
% global t_dct;
% t_dct =0; %tracking complexity
% i & j are used to index the dct coefficients 

 for i = 0: m-1 
 for j = 0: n-1 
  
            %if i=j=0 then ci*cj=1/m*n for 8by8 this is euivlent to
            %dividing by 64, if either i or j =0 , ci*cj=2/n*m =/32
            %if neither is 0 , ci*cj= 4/n*m= 1/16
            if (i == 0) 
                ci = 1 / m; 
            else
                ci = 2 / m; 
            end
            if (j == 0) 
                cj = 1 / n; 
            else
                cj = 2 / n; 
            end
           
         
            sum = 0;
            %looping over the pixel mtrix
            for k = 0: m-1 
                for l =0: n-1 
                    %multiplying each pixel with the bases and summing to
                    %find the coefficients (correlation)
      dCt = pixel_mat(k+1,l+1)* cos((2 * k + 1)*i*pi / (2*m)) * cos(((2 * l + 1) * j * pi) / (2*n)); 
        sum = sum + dCt;
        
        %t_dct=t_dct+15;
        
                end
            end
            coefficients(i+1,j+1) = ci * cj * sum; 
            % t_dct=t_dct+2;
     
end
 end
  
end

