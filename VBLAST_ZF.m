clc
clear 
N = 10^3;
M = 2;
nTx = 2;
nRx = 2;
ip = randi([0 M-1], 1 , N);
sMod = pskmod(ip,M);
sMod = reshape(sMod,nTx,N/nTx);
sMod = kron(sMod , [ones(1,nTx)]);
for i = 1 : (nTx*nRx)
    h(i,:) = 1/sqrt(2)*(randn(1, N/nTx) + 1i*randn(1,N/nTx));
end
H = reshape(h,nRx,N);
y = reshape(sum(H.*sMod,1),nRx,N/nRx);
H = reshape(h,nTx,nRx,N/nTx);
EbN0 = 1:25;
ser = zeros(1,length(EbN0));
for snr = 1:length(EbN0)
    N1 = 1/sqrt(2)*(randn(1,N) + 1i*randn(1,N));
    N1 = reshape(N1,nRx,N/nRx);
    ynoisy = y + 10^(-(EbN0(snr)-10*log10(16))/20)*N1;
    ynoisy = reshape(ynoisy , nRx , 1 , N/nRx);
    iphat = [];
    for i = 1: N/nRx
        C1 = zeros(nRx,1);
        r = ynoisy(:,:,i);
        hSort = transpose(H(:,:,i));
        for k = 1 : nRx
            W = pinv(hSort);
            S1 = sum((abs(W.*W)),2) + C1;
            [~, minEl(k)] = min(S1);
            C1(minEl(k)) = NaN;
            temp = pskdemod(W(minEl(k),:)*r, M);
            yk(minEl(k)) = temp;
            r = r - pskmod(temp,M) * hSort(:,minEl(k));
            hSort(:,minEl(k)) = 0;
        end
        iphat = [iphat , yk];
    end
    [~, ser(snr)] = symerr(ip,iphat);
end
semilogy(EbN0,ser,'g-*');
xlim([EbN0(1), EbN0(end)])
ylim([10^-4, 10^0])
grid on;hold on;
title('Symbol error rate for Uncoded 2x2 ( BPSK ) System');
xlabel('SNR(dB) --->');
ylabel('Symbol Error rate (SER) --->');