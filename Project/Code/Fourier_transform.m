Fs = 1000;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(2*pi*50*t) + sin(2*pi*120*t); 
y = x + 2*randn(size(t));     % Sinusoids plus noise

figure(1);
plot(Fs*t(1:50),y(1:50))
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure(2)
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

%%
yy = ifft(Y*L, L);
plot(yy);

%%
x = [0:0.1:10];
yo = sin(x);
y = sin(x) + 0.1*randn(size(x));

fy = fft(y);
yy = ifft(fy);

freq = (0:length(fy)-1)*5;
plot(freq, abs(fy));

fly = fy.*(1 - abs(freq)/400);
yyl = ifft(fly);

close;
plot(real(yyl));
hold on;
plot(y);