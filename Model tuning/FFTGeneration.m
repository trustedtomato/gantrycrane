
load("GraneResponses.mat");
load("IIRAngleFilterObject.mat")

data = angleResponse.Data; % Data
t = angleResponse.Time;        % Time vector
T = t(2) - t(1);             % Sampling period       
Fs = 1/T;            % Sampling frequency                    
N = length(t);             % Length of signal


fourierData = fft(data);
P2 = abs(fourierData/N);
P1 = P2(1:floor(N/2)+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(N/2))/N;
plot(f,P1) 
title("Single-Sided Amplitude Spectrum of X(t)")
xlabel("f (Hz)")
ylabel("|P1(f)|")
