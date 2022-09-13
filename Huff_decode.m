function decoded = Huff_decode(coded_arr,dict)
%input: array of strings, representing the huffman coded stream of symbols
% and the huff dictionary. 
%output original stream of symbols (array)

%tracking flops:
%global t_huff_dec;t_huff_dec=0;
 %tracking complexity : no flops , assignment and search only
 
 %forming an array of strings with codewords for each symbol in the exact
 %same indexed order as it was in the dict
cellz=struct2cell(dict);
 c= cellz(2,:);
codes = strings(size(c));
[codes{:}] = c{:};

%looping over the coded array, comparing each coded elemnt with the codewords in the previous string array
%then replacing the coded element with the symbol that has the same index
%as the matching codeword
for i= 1: length(coded_arr)
j= find(codes==coded_arr(i));
decoded(i)= double(dict(j).symbol); 
end
end

