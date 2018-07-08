function[y] = tangh(x)
x(x == 0) = Inf;
y = 2*atanh(prod(tanh(x/2)));
end