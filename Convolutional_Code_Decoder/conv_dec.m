clc
clear all
trellis = poly2trellis(3,[7 5]);
N = 10^2;
msg = [round(rand(N,1)) 0 0];
[codedBits,finState] = convenc(msg,trellis,1);
qpskMod = comm.QPSKModulator('BitInput',true);
demodLLR = comm.QPSKDemodulator('BitOutput',true,...
    'DecisionMethod','Log-likelihood ratio');
modlBits = qpskMod(codedBits);
ber = zeros(1,10);
for snr = 1:10
    recdBits = awgn(modlBits,snr,'measured');
    r = demodLLR(recdBits);
    decData = BCJR_conv(transpose(-r),trellis,snr,[0 0],finState);
    d = (decData > 0);
    ber(snr) = biterr(transpose(msg),d);
end
semilogy([1:1:10],ber/N,'-r*')
grid on;