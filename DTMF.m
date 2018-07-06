clear all
close all
clc
ph_no = 4696843681;
fr = [697 770 852 941]; %row frequency
fc = [1209 1336 1477];  %column frequency
[no,ndig] = (num2array(ph_no));   %converting the given phone number to array of 10 digits
no=num2str(no);
% no=['*','#'];ndig=2;
x=[];
xn=[];
Fs = 32768;                 %each tone at about 0.5 seconds each
t = 0:1/Fs:0.5;
n=0:1:1490;
fs=1490*2;                  %sampling frequency
ts=1/fs;
figure(5)
o=1:1:10;
for m=1:length(no)
    switch no(m)                                                   %choosing the frequency and generating the tone based on the input digit
        case '1'
            k=1;j=1;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,1)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '2'
            k=1;j=2;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,2)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '3'
            k=1;j=3;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,3)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '4'
            k=2;j=1;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,4)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '5'
            k=2;j=2;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,5)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
            
        case '6'
            k=2;j=3;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,6)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
            
        case '7'
            k=3;j=1;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,7)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '8'
            k=3;j=2;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,8)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '9'
            k=3;j=3;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,9)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '0'
            k=4;j=2;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,10)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
        case '*'
            k=4;j=1;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,10)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
            
            
        case '#'
            k=4;j=3;
            x=[x 0.5*(sin(2*pi*fr(k)*t)+sin(2*pi*fc(j)*t))];
            xn=[xn 0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts))];
            subplot(2,5,10)
            plot(0.5*(sin(2*pi*fr(k)*n*ts)+sin(2*pi*fc(j)*n*ts)))
    end
end
xn=5*xn; % sound(x,Fs);
Y = fftshift(abs(fft(xn)));  %looking at the spectrum of the input signal to observe the frequency peaks
l1=length(n)*ndig;
fshift = (-l1/2:l1/2-1)*(fs/l1);
figure(1)
plot(fshift,Y/l1)
xlabel('f-->')
ylabel('|X(f)-->|')
grid on
for k=1:4
    A(k,:)=[1 -2*0.99*cos(2*pi*fr(k)/fs) 0.99*0.99];         %generating the resonator for all the row and column frequencies
end
for k=5:1:7
    m=mod(k,4);
    A(k,:)=[1 -2*0.99*cos(2*pi*fc(m)/fs) 0.99*0.99];
end
B=[0.1 0.1 0.1 0.1 0.06 0.035 0.0045]; %assuming the gain to achieve |H(wo)| = 1
x1=[1 zeros(1,l1-1)];                 %impulse response
h=0;
figure(2)
for k=1:7
    y1(k,:)=filter(B(k),A(k,:),x1);  %generating the resonator filter
    subplot(4,2,k)
    plot(fshift,fftshift(abs(fft(y1(k,:)))))
    grid on;
    title('Resonator filters at each frequency')
    ylabel('|H(f)-->|')
    xlabel('f-->')
    h=h+y1(k,:);
end
xnoise=conv(xnoise,[1/4 1/4 1/4 1/4],'same'); %moving average filter
figure(3)
plot(fshift,fftshift(abs(fft(h))))                            %spectrum of the filter function
grid on;
xlabel('f-->')
ylabel('|H(f)|-->')
title('Magnitude response of the sum of all filters at every frequency')
 
%CHANNEL
 
noise = 1 + sqrt(1).*randn(1,length(xn));   %initializing random noise
xnoise=xn+noise;                            %simulating the addition of noise in the communication link % figure(4)
 
%RECEIVER
 
Xt=reshape(xnoise,[length(n),ndig]);
Xt=Xt';
afreq=zeros(ndig,10);
dfreq=zeros(ndig,2);
dkeypad=['1' '2' '3' '11'; '4' '5' '6' '12'; '7' '8' '9' '13'; '*' '0' '#' '14'];
figure(4)
for i=1:ndig
    pos=0;
    temp(i,:)=conv(Xt(i,:),h); %looking at the frequency response and detecting values for each key
    lt=length(temp(i,:));
    fshifttemp = (-lt/2:lt/2-1)*(fs/lt);
    Ytemp(i,:) = fftshift(abs(fft(temp(i,:))));
    subplot(2,5,i)
    plot(fshifttemp,Ytemp(i,:)/lt)
    xlabel('f-->')
    ylabel('|Y(f)-->|')
    grid on;
    for j=1:lt
        if ((Ytemp(i,j)/lt) > 0.5)
            if (fshifttemp(j) > 0)
                pos=pos+1;
                afreq(i,pos)=fshifttemp(j); %looking at peaks of the frequency response
            end
        end
    end
    
    %DECODING PROCESS
    
    
    dfreq(i,:) =[ceil(afreq(i,1)) ceil(afreq(i,10))];
    [~,dfreqindex(i,1)]=min(abs(fr-dfreq(i,1)));[~,dfreqindex(i,2)]=min(abs(fc-dfreq(i,2))) ;  %determing the  received frequency closest to the predefined row or column frequencies
    a=dfreqindex(i,1);b=dfreqindex(i,2);
    dkey(i)=dkeypad(a,b);            %decoding the actual key pressed from the keypad
end
dkey

function [s2,ndig] = num2array(s) %function to convert the n-digit phone number into an array of n-individual numbers
k=1;
m=0;
while(m~=1)
    j=10^k;
    s1=mod(s,j);
    if s1>=s
        ndig=k;
        m=1;
    end
    k=k+1;
end
k=1;
for i=ndig:-1:1
    s2(k)=fix(s/10^(i-1));
    s=mod(s,10^(i-1)) ;
k=k+1;
end
end
