function [coded] = run_length(original)
%the following functions performs r.l.encoding, the coded array follows the
%format [ val1, num of repetitions+0.5,val2,.... so on], when the value is
%repeated only once, we don't write 1 after it, we only write the num of
%repititions for values repeating more than once. the purpose of adding 0.5
%to the # of repetition is to distinguish it from the original array values,
%since we know that all of the values in the array are going to be integers
%for our particular case
%_-----------------------------------------------------


%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_rl; t_rl=0;  % tracking FLOPs
%%*******************
n=1;j=1;i=1;
len=length(original);
while i~=0 
    c=1; %initiliing counts
    for y=j:len-1 %counting repetions of the yth e+lement 
        x=original(y)==original(y+1);
         if x
            c=c+1;
        %t_rl=t_rl+1;
         else
            j=y+1; %t_rl=t_rl+1;
            break
         end
    end
    % if the # of repitions c is > 1, it's added after the value in format
    % c+0.5, else we don't add it
        if c>1  
        coded(n)=original(y);
        coded(n+1)=c+0.5; %t_rl=t_rl+1;
        n=n+2; %t_rl=t_rl+1;
        else
         coded(n)=original(y);
         n=n+1;
        end
        if (y+1==len && ~x ) 
             coded(n)=original(y+1);
        end
        % adding the last element if it is not repeated 
        if y+1>=len
            i=0;
        end

end     
     %   fprintf('FLOPS_run length = %d \n', t_rl);
end
        




