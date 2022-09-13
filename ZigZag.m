function array = ZigZag(matrix)
%input: square matrix
%output: array retrieved by serpentine pattern

%creating a matrix with the indices of the originl mtrix elements(ordered column_wise)
indices = reshape(1:numel(matrix), size(matrix)); 
%flipping the matrix before extracting the diagonals in order to extract
%the antidiagonals of the unflipped matrix
m=spdiags( fliplr(indices));
%re-flipping the matrix to the correct order
indices = fliplr(m);     
%flipping upside down every other column
indices(:,1:2:end) = flipud( indices(:,1:2:end) );  
%removing the zeros from the indices matrix
indices(indices==0) = [];                           

for i=1 :numel(matrix)
array(i)=matrix(indices(i)); 
end
