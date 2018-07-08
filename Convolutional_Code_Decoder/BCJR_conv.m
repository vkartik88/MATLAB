function [LLR] = BCJR_conv(y,trellis,snr,finBit,finState)
N = length(y);
n = log2(trellis.numOutputSymbols);
k = log2(trellis.numInputSymbols);
R = k/n;
LLR = zeros(1, N*R);
Pap = 0.5;
Lc = 4*1*10^(snr/10);
Ck = exp(log(Pap/Pap))/(1+exp(log(Pap/Pap)));
% Ck = 1;
iniState = 1;
y = transpose(reshape(transpose(y),[n , N*R]));
gamma = zeros(trellis.numStates, trellis.numStates, N*R);
finBit = finBit + 1;
finState = finState + 1;
for k = 1 : N*R
    for s = 1 : trellis.numStates
        if ((k == 1))
            for ss = 1 : trellis.numStates
                [flag,in] = ismember(ss - 1, trellis.nextStates(iniState,:));
                if flag == 1
                    flag = 0;
                    temp = 2 * (de2bi(trellis.outputs(iniState,in), n ,'left-msb')) - 1 ;
                    gamma(iniState,ss,k) = Ck * exp((Lc/2) * sum(y(k,:) .* temp)) ;
                end
            end
        elseif (k == 2)
            [check] = ismember(s-1, trellis.nextStates(iniState,:));
            if (check == 1)
                for ss = 1 : trellis.numStates
                    [flag,in] = ismember(ss - 1, trellis.nextStates(s,:));
                    if flag == 1
                        flag = 0;
                        temp = 2 * (de2bi(trellis.outputs(s,in), n ,'left-msb')) - 1 ;
                        gamma(s,ss,k) = Ck * exp((Lc/2) * sum(y(k,:) .* temp)) ;
                    end
                end
            end
        elseif( k == N*R-1 )
            rows = trellis.nextStates(:,finBit(1)) + 1;
            for ss = 1 : trellis.numStates
                [flag,in] = ismember(rows(ss) - 1, trellis.nextStates(s,:));
                if flag == 1
                    flag = 0;
                    temp = 2 * (de2bi(trellis.outputs(s,in), n ,'left-msb')) - 1 ;
                    gamma(s,rows(ss),k) = Ck * exp((Lc/2) * sum(y(k,:) .* temp)) ;
                end
            end
        elseif ( k == N*R )
            [check] = ismember(s - 1, trellis.nextStates(:,finBit(1)));
            if check == 1
                for ss = 1 : trellis.numStates
                    [flag] = ismember(ss - 1, trellis.nextStates(:,finBit(2)));
                    if flag == 1
                        flag = 0;
                        temp = 2 * (de2bi(trellis.outputs(s,finBit(2)), n ,'left-msb')) - 1 ;
                        gamma(s,finState,k) = Ck * exp((Lc/2) * sum(y(k,:) .* temp)) ;
                    end
                end
            end
        else
            for ss = 1 : trellis.numStates
                [flag,in] = ismember(ss - 1, trellis.nextStates(s,:));
                if flag == 1
                    flag = 0;
                    temp = 2 * (de2bi(trellis.outputs(s,in), n ,'left-msb')) - 1 ;
                    gamma(s,ss,k) = Ck * exp((Lc/2) * sum(y(k,:) .* temp)) ;
                end
            end
        end
    end
end
size(gamma)
alpha = zeros(N*R + 1 , trellis.numStates);
alpha(1,1) = 1;
for k = 2 : N*R + 1
    for ss = 1 : trellis.numStates
        for s = 1 : trellis.numStates
            alpha(k,ss) = alpha(k,ss) + gamma(s,ss,k-1) * alpha(k-1,s) ;
        end
    end
    alpha(k,:) = alpha(k,:)/sum(alpha(k,:));
end
beta = zeros(N*R+1 , trellis.numStates);
beta(N*R+1,:) = alpha(N*R+1,:);
for k = N*R + 1: -1 : 2
    for ss = 1: trellis.numStates
        for s = 1: trellis.numStates
            beta(k-1,ss) = beta(k-1,ss) + gamma(ss,s,k -1) * beta(k,s);
        end
    end
    beta(k-1,:) = beta(k-1,:)/sum(beta(k-1,:)) ;
end
numerator = zeros(1,N*R);
denominator = zeros(1,N*R);
for k = 1 : N*R
    for s = 1 : trellis.numStates
        for ss = 1 : trellis.numStates
            [flag,in] = ismember(ss - 1, trellis.nextStates(s,:));
            if (flag == 1 && in == 1)
                denominator(k) = denominator(k) + alpha(k,s) * gamma(s,ss,k) * beta(k+1,ss);
            elseif (flag == 1 && in == 2)
                numerator(k) = numerator(k) + alpha(k,s) * gamma(s,ss,k) * beta(k+1,ss);
            end
        end
    end
    numerator(k) = numerator(k)/(numerator(k) + denominator(k));
    denominator(k) = denominator(k)/(numerator(k) + denominator(k));
    LLR(k) = log(numerator(k)/denominator(k));
end

end
