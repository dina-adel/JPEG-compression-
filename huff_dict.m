function dict = huff_dict(s,p)
%input: s: array of unique symbols, p: their corresponding probabilities 
%with matching indices, 
%output: a huffman dictionary: an array of structs, each containing 2
%datafields: the sumbol, and the codeword


%to track # of FLOPs uncomment all lines with 't_'
%tracking flops:
%global t_huffd;t_huffd=0; %tracking flops

n=length(p);
codeword=cell(1,n);%Where codewords are going to be stored
track_done=zeros(n,n);%This matrix helps us track which elemnts we have worked on
temp=p;%to manipulate probabilities

for i=1:n-1
    [~ ,l]=sort(temp); % keeping track of the original positions of the rearranged elements
    track_done(l(1),i)=10;
    track_done(l(2),i)=11;
    temp(l(2))=temp(l(2))+temp(l(1));
    %t_huffd=t_huffd+1;
    temp(l(1))=100; % to make sure it's always @the very end of the list (as if we've removed it)
end
i=n-1;
rows=find(track_done(:,i)==10);
codeword(rows)=strcat(codeword(rows),'1');
rows=find(track_done(:,i)==11);
codeword(rows)=strcat(codeword(rows),'0');
for i=n-2:-1:1
    row11=find(track_done(:,i)==11);
    row10=find(track_done(:,i)==10);
    codeword(row10)=strcat(codeword(row11),'1');
    codeword(row11)=strcat(codeword(row11),'0');
end
for i=1:length(p)
dict(i)=struct('symbol',s(i),'code', codeword(i));
end


end

    