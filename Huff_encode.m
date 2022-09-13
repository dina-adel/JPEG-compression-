function [coded_arr ,dict]= Huff_encode(in_arr)
%given an input stream of symbols,and a huffman dictionary
 %the function huffman encodes the array and returns an array of strings each element 
% is the binary huffman encoded version (represented as a string) of its corresponding symbol 


%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
% global t_huff_enc  t_sym_freq t_huffd; t_huff_enc=0;


% step1 : extracting symbols and their probabilities
[s ,c, p] = symbol_freq(in_arr); %t_huff_enc=t_huff_enc+ t_sym_freq; 
%step2 :generating a huffman dictionary
dict= huff_dict(s,p); %t_huff_enc = t_huff_enc+ t_huffd;

for i= 1: length(in_arr)
k= find(s==in_arr(i));
coded_arr(i)=string(dict(k).code);

end
end
