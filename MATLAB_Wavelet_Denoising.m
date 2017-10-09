clear all
close all
clc

x_orig = zeros(1024,8);
load ex4mwden
clear x
whos
for e = 1:1
    x_orig(:, 5) = load_signal('Piece-Regular', 1024);
    x_orig(:, 6) = load_signal('cusp', 1024);
    kp = 0;
    kk = 6;
    for m = 1:kk
        sigma(m) = 0.2*max(x_orig(:, m));
    end
    x(:, 1) = x_orig(:, 1) + sigma(1)*randn(size(x_orig(:, 1)));
    x(:, 2) = x_orig(:, 2) + sigma(2)*randn(size(x_orig(:, 2)));
    x(:, 3) = x_orig(:, 3) + sigma(3)*randn(size(x_orig(:, 3)));
    x(:, 4) = x_orig(:, 4) + sigma(4)*randn(size(x_orig(:, 4)));
    x(:, 5) = x_orig(:, 5) + sigma(5)*randn(size(x_orig(:, 5)));
    x(:, 6) = x_orig(:, 6) + sigma(6)*randn(size(x_orig(:, 6)));
    
    %%
    level = 5;
    wname = 'sym4';
    tptr  = 'sqtwolog';
    sorh  = 's';
    
    %%
    npc_app1 = 'none';
    npc_fin1 = 'none';
    
    for l = 1:kk
        x_den1(:, l) = wmulden(x(:,l), level, wname, npc_app1, npc_fin1, tptr, sorh);
    end
    
    %%
    for n = 1:kk
        SNR_out1(n) = snr(x_orig(:,n), x_den1(:,n));
    end
    SNR_out111(e, :) = SNR_out1;
end


% Plotting the original, noisy, and denoised signals
kp = 0;
figure(3)
for k = 1:kk
    subplot(kk,3,kp+1), plot(x_orig(:,k)); axis tight;
    title(['Original signal ',num2str(k)])
    subplot(kk,3,kp+2), plot(x(:,k)); axis tight;
    title(['Observed signal ',num2str(k)])
    subplot(kk,3,kp+3), plot(x_den1(:,k)); axis tight;
    title(['Denoised signal ',num2str(k)])
    kp = kp + 3;
end

% Calculating the averaged SNR
SNR_Out_Ave = mean(SNR_out111, 1)
mean(SNR_Out_Ave)