function matrix = inv_zigzag(array)
%output: square matrix
%input: array retrieved by serpentine pattern

matrix= zeros(sqrt(numel(array))); % initiliing the matrix, assuming a square matrix
%getting the indices matrix, exactly like the zigzag function 
indices = reshape(1:numel(matrix), size(matrix));         
indices = fliplr( spdiags( fliplr(indices) ) );     
indices(:,1:2:end) = flipud( indices(:,1:2:end) );  
indices(indices==0) = [];  
%constructing the matrix
for i=1:numel(array)
    matrix(indices(i))= array(i);
end
end

%%no floating point operations , assignment, reversal & reshaping only 