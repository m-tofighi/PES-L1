clear all
close all
clc

% Loading the signals
x_orig = zeros(1024,6);
load ex4mwden
clear x
whos

for e = 1:1
    % loading the signals
    x_orig(:, 5) = load_signal('Piece-Regular', 1024);
    x_orig(:, 6) = load_signal('cusp', 1024);
    kp = 0;
    kk = 6;
    amp_perc = 0.2;% Noise power
    % noise added here
    for m = 1:kk
        sigma(m) = amp_perc*max(x_orig(:, m));
        NoisySignal(:, m) = x_orig(:, m) + sigma(m)*randn(size(x_orig(:, m)));
    end
    
    
    if amp_perc == 0.1
        iter = [5 5 5 5 5 150];
    elseif amp_perc == 0.2
        iter = [5 30 10 10 10 300];
    elseif amp_perc == 0.3
        iter = [10 25 10 15 15 350];
    end
    
    %PES-L1 algorithm is applied inside this function
    DenoisedSignal = PES_L1_Pyramid(iter, NoisySignal, kk);
    
    for d = 1:kk
        SNR_in(d) = snr(x_orig(:,d), NoisySignal(:,d));
        SNR_out(d) = snr(x_orig(:,d), DenoisedSignal(:,d));
    end
    
    SNR_in1(e, :) = SNR_in;
    SNR_out1(e, :) = SNR_out;
end

% Plotting the original, noisy, and denoised signals
kp = 0;
figure(2)
for f = 1:kk
    subplot(kk,3,kp+1), plot(x_orig(:,f)); axis tight;
    title(['Original signal ',num2str(f)])
    subplot(kk,3,kp+2), plot(NoisySignal(:,f)); axis tight;
    title(['Observed signal ',num2str(f)])
    subplot(kk,3,kp+3), plot(DenoisedSignal(:,f)); axis tight;
    title(['Denoised signal ',num2str(f)])
    kp = kp + 3;
end

% Calculating the averaged SNR
SNR_In_Ave = mean(SNR_in1, 1)
SNR_Out_Ave = mean(SNR_out1, 1)

% The average SNR for all 6 signals
mean(SNR_Out_Ave)