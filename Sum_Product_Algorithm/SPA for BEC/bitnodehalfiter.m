function [recdmsg] = bitnodehalfiter(H,recdmsg,newbitvalues)
nZeros = 0; nOnes = 0;
for i = 1 : size(H,2)           %for every bit node
    for j = 1 : size(H,1)           %for every check node
        if ( H(j,i) && newbitvalues(j,i))     %Calculating the number of zeroes and number of ones in every edge connected to a bit node
            nOnes = nOnes + 1;
        elseif ( H(j,i) && ~newbitvalues(j,i))
            nZeros = nZeros + 1;
        end
    end
    if ((recdmsg(i)  && nZeros > nOnes) || (~recdmsg(i) && nZeros < nOnes)) % Bit Flipping based on Majority Logic decision
        recdmsg(i) = ~recdmsg(i) ;
    end
    nZeros = 0; nOnes = 0;
end
end