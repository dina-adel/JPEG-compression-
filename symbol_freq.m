function [symbols,counts, probabilities] = symbol_freq(vector)
% this function tkes as input a stream of data represented by a group of
% symbols, extracts the unique symbols, the count of ech symbol & the
% probbility of ech of them. exmple: input vector = [0,0,1,5,5,7],
% return will be symbols =[0,1,5,7], counts=[2,1,2,1] prob=[ 0.33,0.167,0.33,0.167]
    

%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_sym_freq; t_sym_freq=0; %tracking Flops;


symbols = double(unique(vector)); 
num_sym=numel(symbols);
counts= zeros(1,num_sym);

%calculating counts
for k =1:num_sym
    for i=1 :length(vector)
    if (symbols(k)==vector(i))      
        counts(k)= counts(k)+1; %t_sym_freq=t_sym_freq+1;
    
    end
  
    end
end
%calculating probabilities
for  k=1:num_sym
    probabilities(k)= counts(k)/sum(counts); %t_sym_freq=t_sym_freq+1;
end 
end

