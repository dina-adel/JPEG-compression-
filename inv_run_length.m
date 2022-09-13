function decoded = inv_run_length(coded)
%input: a run length coded array of symbols where elements that represent 
% the count are represented as a double of count+0.5
%output is the original rl decoded array 


%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_inv_rl; t_inv_rl=0; %tracking flops


len=length(coded);
i=1;k=1;
while i<=len
    % checking if the ith array element is an original symbol or a
    % repetition counter for the previous symbol, according to the
    % count+0.5 convention
    if (coded(i)==floor(coded(i)))
       decoded(k)= coded(i);k=k+1; % symbols re copied to the decoded array
   % t_inv_rl=t_inv_rl+1;
    else
       n= coded(i)-0.5; %when the ith element is a repetition 
       decoded(k:k+n-2)=decoded(k-1)*ones(1,n-1);% we repeat the (i-1)th element n times 
       k=k+n-1;
      % t_inv_rl=t_inv_rl+4;
    end
    i=i+1; %t_inv_rl=t_inv_rl+1;
end
%fprintf('FLOPS_inverse run length = %d \n', t_inv_rl);

end