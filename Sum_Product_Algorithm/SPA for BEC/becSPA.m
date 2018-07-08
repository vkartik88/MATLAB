clc
clear all
% T = readtable('PCM_RateHalfIrregular.txt');
T = readtable('PCM_AlmostRegular36.txt');   %Uncomment this for the 'Almost Regular H Matrix'
pos = horzcat(T.Var1,T.Var2);
N = 50;
b = zeros(512,896);
%b = zeros(512,1024);                         %Uncomment this for the 'Almost Regular H Matrix'
nZeros = 0; nOnes = 0;
b(sub2ind(size(b),pos(:, 1),pos(:, 2))) = 1;
LDPC.H = (b);
prob = linspace(0.01,0,5);  %5 probability values betwwen 0.01 and 0
for p = 1 : length(prob)
    bitErrors = 0;
    frameErrors = 0;
    for tx = 1 : N
        codeWord = zeros(1,size(LDPC.H,2));            % All Zero codeword
        LDPC.recdmsg = bsc(codeWord, prob(p));   %Binary Symmetric Channel with the crossover probabilities
        for iter = 1 : 100 %Max_iteration number
            b2c_update = checknodehalfiter(LDPC.H,LDPC.recdmsg);      %check node half iteration
            c2b_update = bitnodehalfiter(LDPC.H,LDPC.recdmsg,b2c_update);      %bit node half iteration
            LDPC.recdmsg = c2b_update;
            if (LDPC.H * transpose(LDPC.recdmsg) == 0)              %stopping criterion
                iter
                break;
            end
        end
        bitErrors = bitErrors + nnz(LDPC.recdmsg);                   %bit errors update
        if (nnz(LDPC.recdmsg) ~= 0)
            frameErrors = frameErrors + 1;                           %frame error update
        end
    end
    bitErrRate(p) = bitErrors/(N*896);                              %Bit Error Rate calculation 
    frmErrRate(p) = frameErrors/N;                                  %Frame error rate calculation
    bitErrors = 0;
    frameErrors = 0;
end
figure(1)
semilogy(prob,frmErrRate); 
grid on
xlabel('Cross Over probability')
ylabel('Frame Error Rate (FER)')
set(gca, 'XDir','reverse')
figure(2)
semilogy(prob,bitErrRate)
grid on
xlabel('Cross Over probability')
ylabel('Bit Error Rate (BER)')
set(gca, 'XDir','reverse')