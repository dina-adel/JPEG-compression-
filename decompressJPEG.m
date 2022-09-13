function decompressed = decompressJPEG(coded_arr,dict,dgree_of_compression,blocksize)
%this function takes as input a JPEG coded stream of bits, the Huffman
%dictionary used when encoding it, a degree of compression 0 for low
%compression &1 for high, and a block size of either 8 or 16, and returns
%a matrix of the original image


%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_decompress t_huff_dec t_inv_rl t_idct; t_decompress=0;
%********


% quantization tables
%------------------------------------------------------------------------------------------
if (blocksize==8)
%table1 for low compression
    qt_low=[1 1 1 1 1 2 2 4; 
            1 1 1 1 1 2 2 4;
            1 1 1 1 2 2 2 4; 
            1 1 1 1 2 2 4 8;
            1 1 2 2 2 2 4 8;
            2 2 2 2 2 4 8 16;
            2 2 2 4 4 8 8 16;
            4 4 4 4 8 8 16 16];
%table 2 for very high compression
  qt_high =[1 2 4 4 8 16 32 128; 
            2 4 4 8 16 32 64 128;
            4 4 8 16 32 64 128 128; 
            8  8 16 32 64 128 128 256;
            16 16 32 64 128 128 256 256;
            32 32 64 128 128 256 256 256;
            64 64 128 128 256 256 256 256;
            128 128 128 256 256 256 256 256];
        
        

elseif(blocksize==16)
      qt_low=[1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 ; 
              1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4;
              1 1 1 1 1 1 1 1 1 1 1 2 2 2 4 4;
              1 1 1 1 1 1 1 1 1 1 1 2 2 4 4 4 ; 
              1 1 1 1 1 1 1 1 1 1 1 2 5 4 4 4;
              1 1 1 1 1 1 1 1 1 2 2 2 4 4 4 4 ;
              1 1 1 1 1 1 1 1 1 2 2 4 4 8 8 8 ;
              1 1 1 1 1 1 1 2 2 2 4 4 4 8 8 8 ;
              1 1 1 1 1 1 2 2 2 2 4 4 4 8 8 8 ;
              1 1 1 1 1 1 2 4 4 4 4 4 8 8 8 8;
              1 1 1 1 1 1 2 4 4 4 4 8 8 8 8 8 ;
              1 1 1 1 1 1 2 4 4 4 4 8 8 8 8 16 ;
              1 1 2 2 4 4 4 4 4 8 8 8 8 8 8 16 ;
              1 1 2 2 4 4 8 8 8 8 8 8 8 16 16 16  ;
              1 2 2 4 4 8 8 8 8 8 8 16 16 16 16 16 ;
              1 2 2 4 4 8 8 8 8 8 16 16 16 16 16 16 ];
%table 2 for 16by16 high compression
 
      qt_high=[1 1 1 1 1 1 1 2 2 4 4 4 8 8 8 8; 
              1 1 1 1 1 1 2 2 2 4 4 4 8 8 8 8;
              1 1 1 1 1 2 4 4 4 4 8 8 8 8 8 8 ;
              1 1 1 1 2 2 2 4 4 8 8 8 8 16 16 32; 
              1 1 1 1 2 2 4 4 4 8 8 16 16 16 16 32;
              1 1 1 2 2 2 2 2 4 4 4 16 16 16 32 32;
              1 1 2 2 2 2 4 4 4 4 8 16 16 32 32 64;
              1 1 2 2 2 2 4 4 4 8 8 16 16 32 32 64;
              1 1 2 2 2 4 4 4 4 8 8 16 32 32 64 64;
              1 2 2 2 2 4 4 4 4 8 8 16 32 32 256 256;
              1 2 2 2 2 4 4 4 4 8 32 32 32 64 256 256;
              1 16 16 16 32 32 32 32 32 32 32 32 32 256 256 256;
              1 16 16 16 4 4 4 16 16 32 32 64 128 256 256 256;
              4 16 32 64 64 64 64 128 128 128 128 128 256 256 256 256  ;
              4 16 32 64 64 64 64 64 128 128 128 256 256 256 256 256  ;
              32 64 64 64 128 256 256 256 256 256 256 256 256 256 256 256 ];
    
    
else
    disp('set blocksize s either 8 or 16');
    return;
end
 

% selection of q table
if (dgree_of_compression==0)
    Qtable= qt_low;
elseif (dgree_of_compression==1)
    Qtable= qt_high;
else 
    disp('error, 2nd argument can only be 0 or 1, please type 0 for low compression, or 1 for high compression');
return 
end

%-----------------------------------------------------------
h_decoded=Huff_decode(coded_arr,dict); % huffmn decoding the bit stream 

%t_decompress=t_decompress+ t_huff_dec; 

rl_decoded= inv_run_length(h_decoded); % R. length decoding the symbol stream 

%t_decompress=t_decompress+t_inv_rl;

%---------------------------------------
%retrieving the Originl imge from coded stream :

starti=1; Endi=blocksize;
startj=1; Endj=blocksize; 
n=floor(sqrt(length(rl_decoded))/blocksize); % the number of 8by8 blocks the imge can be divided into

decompressed=uint8(zeros(blocksize*n)); %to store the decompressed matrix
strt_arr=1; end_arr=blocksize^2; 

%t_decompress=t_decompress+4;

%looping over the imge, performing idct & de-quantization on each block
for i=1:n
    for j=1:n  
quan_block =inv_zigzag(rl_decoded(strt_arr:end_arr)); %array portion to block matrix
  
dctt= quan_block.*Qtable;  % dequantization
  

  orig8= Idct_2(dctt); % inverse dct
  
  
 decompressed(starti:Endi, startj:Endj)=orig8; %reforming matrix
 
startj=Endj+1; Endj=startj+blocksize-1;

%t_decompress=t_decompress+7+t_idct+blocksize^2;

strt_arr=end_arr+1; end_arr=(strt_arr+blocksize^2)-1;
    end
    starti=Endi+1; Endi=starti+blocksize-1; 
    startj=1; Endj=blocksize;
    
%t_decompress=t_decompress+3;

end

%fprintf('FLOPS_decompressJPEG = %d \n', t_decompress);

end

