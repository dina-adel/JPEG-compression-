clear;
clc;
close all;
blocksize=16;
matrix =imread('testimage.jpg'); %reading the image
[r, c]= size(matrix); orig_size=(floor(min([r c])/blocksize)*blocksize)^2;
%size of image that fits 8by8 or 16 by16 division
 

%% testing the low compression 16by16 quan_table
 figure;
[h1, d1]= compressJPEG(matrix,0,blocksize);
decomp= decompressJPEG(h1,d1,0,blocksize);

subplot(1,2,1);
imshow(matrix);title('before compression');
subplot(1,2,2); 
 imshow(decomp);title('after compression');
 
 sgt3 = sgtitle('low compression,16by16block-wise','Color','red');
 
imwrite(decomp, 'low_comp_16by16.jpg','jpeg');
%compression ration per array lengths
c_ratio_low_16by16= ((orig_size-length(h1))/orig_size)*100;
[r, c]=size(decomp);
%mean absolute error
error16by16_low= (1/numel(decomp))*sum(sum(abs(decomp-matrix(1:r,1:c))));
%-----------------------------------------------------------------------
%% testing the high compression quan_table
figure;

[h4, d4]= compressJPEG(matrix,1,blocksize);
decomp= decompressJPEG(h4,d4,1,blocksize);

subplot(1,2,1);
imshow(matrix);title('before compression');
subplot(1,2,2); 
 imshow(decomp);title('after compression');
 
 sgt4 = sgtitle('high compression,16by16block-wise','Color','red');
 imwrite(decomp, 'high_comp 16by16.jpg','jpeg');
 c_ratio_high_16by16= ((orig_size-length(h4))/orig_size)*100;
 
 [r, c]=size(decomp);
error16by16_high= (1/numel(decomp))*sum(sum(abs(decomp-matrix(1:r,1:c))));