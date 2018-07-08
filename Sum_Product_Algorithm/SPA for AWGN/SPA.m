clc
clear all
% T = readtable('PCM_RateHalfIrregular.txt');
T = readtable('PCM_AlmostRegular36.txt');   %Uncomment this for the 'Almost Regular H Matrix'
pos = horzcat(T.Var1,T.Var2);
N = 25;
H = zeros(max(pos));                         %Uncomment this for the 'Almost Regular H Matrix'
H(sub2ind(size(H),pos(:, 1),pos(:, 2))) = 1;
snr = linspace(1,3.5,10);  %10 SNR values from 1 to 3dB
newbitvalues = zeros(size(H));
r = zeros(1,max(pos(:,2)));
tempH = r;
codeWord = zeros(1,size(H,2));            % All Zero codeword
modCodeWord = pskmod(codeWord,2);  %BPSK Modulation
tic
for p = 1 : length(snr)
    p
    frameErrors = 0;
    bitErrors = 0;
    for tx = 1 : N
        recd = awgn(modCodeWord,snr(p),'measured');
        r = 4*db2pow(p)*real(recd);
        M = r .* H;
        for iter = 1 : 100 %Max iterations
            for i = 1 : size(H,1) %Check node update
                tempcol = find(H(i,:) == 1);
                tempH(tempcol) = 1;
                temp1 = tempH;
                for j = tempcol
                    temp1(j) = 0 ;
                    m = temp1 .* M(i,:);
                    newbitvalues(i,j) = tangh(m) ; %check node update
                    temp1 = tempH;
                end
                tempH = zeros(1,max(pos(:,2)));
            end
            %bit node update
            c2b_update = sum(vertcat(r,newbitvalues),1);
            M = c2b_update.*H - newbitvalues;
            temp = c2b_update <  0;
            if (mod(H*temp',2) == 0 )           %iteration termination criterion
                break
            end
        end
        bitErrors = bitErrors + nnz(temp);
%         if (nnz(temp) ~= 0)
%             frameErrors = frameErrors + 1;                           %frame error update
%         end
    end
%     frmErrRate(p) = frameErrors/N;                                  %Frame error rate calculation
    bitErrRate(p) = bitErrors/(N*length(r))
%     frameErrors = 0;
end
toc
% figure(1)
% semilogy(snr,frmErrRate);
% grid on
% xlabel('SNR(dB) --> ')
% ylabel('Frame Error Rate (FER)')
% xlim([1 4])
figure(2)
semilogy(snr,bitErrRate);
grid on
xlabel('SNR(dB) --> ')
ylabel('Bit Error Rate (BER)')
xlim([1 4])