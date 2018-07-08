clc
clear all
% T = readtable('PCM_RateHalfIrregular.txt');
T = readtable('PCM_AlmostRegular36.txt');   %Uncomment this for the 'Almost Regular H Matrix'
pos = horzcat(T.Var1,T.Var2);
N = 30;
% b = zeros(512,896);
b = zeros(512,1024);                         %Uncomment this for the 'Almost Regular H Matrix'
b(sub2ind(size(b),pos(:, 1),pos(:, 2))) = 1;
LDPC.H = (b);
prob = linspace(0.15,0.005,5);  %5 probability values betwwen 0.01 and 0
newbitvalues = zeros(size(LDPC.H));
for p = 1 : length(prob)
    frameErrors = 0;
    for tx = 1 : N
        codeWord = zeros(1,size(LDPC.H,2));            % All Zero codeword
        LDPC.recdmsg = bsc(codeWord, prob(p));   %Binary Symmetric Channel with the crossover probabilities
        for i = 1 : size(LDPC.H,2)                    %LLR calculation 0/+ve , 1/-ve
            r(i) = ((-1)^LDPC.recdmsg(i))*log((1-0.15)/0.15);
        end
        M = r.*LDPC.H;
        for iter = 1 : 100 %Max iterations
            tempH = LDPC.H;
            %Check node update
            for i = 1 : size(LDPC.H,1)  % for each checknode      
                for j = 1 : size(LDPC.H,2)
                    if (LDPC.H(i,j) == 1) % for each edge
                        tempH(i,j) = 0;
                        newbitvalues(i,j) = tangh(tempH(i,:) .* M(i,:)) ; %phi(x) update
                        tempH = LDPC.H ;
                    end
                end
            end
            %bit node update
            c2b_update = sum(vertcat(r,newbitvalues),1);
            temp = c2b_update < 0;
            if (mod(LDPC.H * transpose(temp),2) == 0)            %iteration termination criterion
                break;
            end
            M = c2b_update.*LDPC.H - newbitvalues;
        end
        if (nnz(temp) ~= 0)
            frameErrors = frameErrors + 1;                           %frame error update
        end
    end
    frmErrRate(p) = frameErrors/N;                                  %Frame error rate calculation
    frameErrors = 0;
end
figure(1)
semilogy(prob,frmErrRate);
grid on
xlabel('Cross Over probability')
ylabel('Frame Error Rate (FER)')
set(gca, 'XDir','reverse')