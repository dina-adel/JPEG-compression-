clc;clear;
M =[ 17    17    59    1;
     17    59    51    2 ;
     17    70    10    4 ;
     12    22    14    8];
 
[s c p]= symbol_freq(ZigZag(M));
dict= huff_dict(s,p);