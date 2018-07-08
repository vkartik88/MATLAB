function [newbitvalues] = checknodehalfiter(H,recdmsg)
tempH = H;
newbitvalues = zeros(size(H,1),size(H,2));
for i = 1 : size(H,1)  % for each checknode
    for j = 1 : size(H,2)
        if (H(i,j) == 1) % for each edge
            tempH(i,j) = 0 ;
            newbitvalues(i,j) = mod(tempH(i,:)*transpose(recdmsg), 2) ;  %Check node update
            tempH = H ;
        end
    end
end
end