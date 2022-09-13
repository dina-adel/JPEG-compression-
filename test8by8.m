clear;
clc;
close all;
blocksize=8;
matrix =imread('testimage.jpg'); %reading the image
[r, c]= size(matrix); 
orig_size=(floor(min([r c])/blocksize)*blocksize)^2; 
%size of image that fits 8by8 or 16 by16 division

%% testing the low compression 8by8 quan_table

[h, d]= compressJPEG(matrix,0,blocksize);
decomp= decompressJPEG(h,d,0,blocksize);

subplot(1,2,1);
imshow(matrix);title('before compression');
subplot(1,2,2); 
 imshow(decomp);title('after compression');
 
 sgt = sgtitle('low compression,8by8block-wise','Color','red');
imwrite(decomp, 'low_comp 8by8.jpg','jpeg');
%compression ration from array length reduction
c_ratio_low_8by8= ((orig_size-length(h))/orig_size)*100;

[r, c]=size(decomp);
% calculating mean absolute error
error8by8_low= (1/numel(decomp))*sum(sum(abs(decomp-matrix(1:r,1:c))));
 %% testing the high compression quan_table
figure;

[h2, d2]= compressJPEG(matrix,1,blocksize);
decomp= decompressJPEG(h2,d2,1,blocksize);

subplot(1,2,1);
imshow(matrix);title('before compression');
subplot(1,2,2); 
 imshow(decomp);title('after compression');
 
 sgt2 = sgtitle('high compression,8by8block-wise','Color','red');
 imwrite(decomp, 'high_comp 8by8.jpg','jpeg');
 
 c_ratio_high_8by8= ((orig_size-length(h2))/orig_size)*100;
 
 [r, c]=size(decomp);
error8by8_high= (1/numel(decomp))*sum(sum(abs(decomp-matrix(1:r,1:c))));
%-------------------------------------------------------------------------------------------------------
