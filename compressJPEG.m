function  [h, d]=compressJPEG(imagematrix,dgree_of_compression,blocksize)
% this function performs JPEG compression. Input arguments are: image
% matrix (that you'd like to compress), degree of compression, 0 for low
% compression &1 for high compression, blocksize is either 8 or 16, it
% outputs : h is the final coded array & d is the huffman dictionary used
% in huffman coding
%*************************************************************************
%tracking folps: the global variables were used to count floating point
%operations(Flop). I have commented all the FLOP calculation bits of code
%because they increase run time, if you would like to count the Flops while running,
% just decomment any line with "t_" in it. 
%global t_compress t_dct t_huff_enc t_rl; t_compress=0;
%**************************************************************************


% quantization tables
%------------------------------------------------------------------------------------------
%table1 for 8by8 low compression
if (blocksize==8)
    qt_low=[1 1 1 1 1 2 2 4; 
            1 1 1 1 1 2 2 4;
            1 1 1 1 2 2 2 4; 
            1 1 1 1 2 2 4 8;
            1 1 2 2 2 2 4 8;
            2 2 2 2 2 4 8 16;
            2 2 2 4 4 8 8 16;
            4 4 4 4 8 8 16 16];
%table 2 for 8by8 high compression
  qt_high =[1 2 4 4 8 16 32 128; 
            2 4 4 8 16 32 64 128;
            4 4 8 16 32 64 128 128; 
            8  8 16 32 64 128 128 256;
            16 16 32 64 128 128 256 256;
            32 32 64 128 128 256 256 256;
            64 64 128 128 256 256 256 256;
            128 128 128 256 256 256 256 256];
% table3 for 16 by 16 kow compression
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
%table 4 for 16by16 high compression
 
      qt_high=[1 1 2 4 4 4 8 8 8 8 8 8 16 32 32 32; 
              1 1 2 4 4 4 8 8 8 8 8 8 16 32 32 64;
              1 2 2 4 4 4 8 8 8 8 16 32 32 64 64 64;
              1 4 4 4 8 8 8 8 16 16 64 64 64 64 64 64; 
              1 4 4 4 8 8 8 8 16 16 64 64 64 64 64 64;
              2 2 4 4 8 8 16 16 16 32 32 64 64 64 128 128;
              2 2 4 4 8 8 16 16 16 32 32 64 64 64 128 128;
              2 2 4 4 8 8 16 16 16 32 32 64 64 64 128 128;
              2 2 4 4 8 8 16 16 16 32 32 64 64 64 128 128;
              1 16 16 16 32 32 32 32 32 32 64 128 128 256 256 256;
              1 16 16 16 32 32 32 32 32 32 64 128 128 256 256 256;
              1 16 16 16 32 32 32 32 32 32 64 128 128 256 256 256;
              1 16 16 16 32 32 32 32 32 32 64 128 128 256 256 256;
              4 16 32 64 256 256 265 256 256 256 256 256 256 256 256 256  ;
              4 16 32 64 256 256 265 256 256 256 256 256 256 256 256 256  ;
              128 128 256 256 256 256 256 256 256 256 256 256 256 256 256 256 ];   
 
else
    disp('set blocksize s either 8 or 16');
    return;
end

% selection of q table
if(dgree_of_compression==0)
    Qtable= qt_low;
elseif (dgree_of_compression==1)
    Qtable= qt_high;
else 
    disp('error, 2nd argument can only be 0 or 1, please type 0 for low compression, or 1 for high compression');
return 
end



%---------------------------------------------------------------------------
%the following code segment  performs dct on every 
%block seperately,divides it by the quantization table,ZigZags it to a 1d array then combines 
%all of them into one array of the same size as the image,ready for RL & Huffman encoding

[x, y]= size (imagematrix); 
n=floor(min([x y])/blocksize);  % the number of blocks the imge can be divided into

%t_compress=t_compress+1;

%initiliing indices 
starti=1; Endi=blocksize; 
startj=1; Endj=blocksize;  

strt_arr=1; end_arr=blocksize^2; 

%t_compress=t_compress+1;

%looping over the imge, performing dct,& quantization on each block
for i=1:n
    for j=1:n
        format long g;
block= imagematrix(starti:Endi, startj:Endj);
Dct_coeff_block= DCT2D(double(block)); %calling my dct2 function

%t_compress=t_compress+ t_dct;

 quan_block= round(Dct_coeff_block./ Qtable); %quantization
 
 %t_compress=t_compress+blocksize^2; 
 
num_stream(strt_arr:end_arr)= ZigZag(quan_block); %forming quantized array
  
startj=Endj+1; Endj=startj+blocksize-1;
strt_arr=end_arr+1; end_arr=strt_arr+(blocksize^2)-1; 

%t_compress=t_compress+7;
    end
    starti=Endi+1; Endi=starti+blocksize-1; 
%t_compress=t_compress+3;
    startj=1; Endj=blocksize;
end
%-----------------------------------------------
%the following code segment R.L encodes the array , then haffman encodes it 

r= run_length(num_stream); % rl encoding

%t_compress=t_compress+ t_rl;

[h, d]=Huff_encode(r);  %huffmn encoding

%t_compress=t_compress+t_huff_enc;


%saving coded stream and huff dict to binary file
num_h = bin2dec(h);

cellz=struct2cell(d);
 c= cellz(2,:);
codes = strings(size(c));
[codes{:}] = c{:};
 codes= bin2dec(codes);
cellz=struct2cell(d);
symbols=double(cell2mat(cellz(1,:)));


fileID = fopen('compressed.bin','w');
fileid= fopen('huff_dict.txt','w');
fwrite(fileID,num_h);
fwrite(fileid,codes); fwrite(fileid,symbols);

%fprintf('FLOPS_compressJPEG = %d \n', t_compress);
end

