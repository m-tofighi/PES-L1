clear all
close all
clc


% Set signal to noise ratio and set rand seed.
snr1 = 3; init = 2055615866;

% Generate original signal and a noisy version adding
% a standard Gaussian white noise.

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
        sigma(m) = 0.1*max(x_orig(:, m));
    end
    x(:, 1) = x_orig(:, 1) + sigma(1)*randn(size(x_orig(:, 1)));
    x(:, 2) = x_orig(:, 2) + sigma(2)*randn(size(x_orig(:, 2)));
    x(:, 3) = x_orig(:, 3) + sigma(3)*randn(size(x_orig(:, 3)));
    x(:, 4) = x_orig(:, 4) + sigma(4)*randn(size(x_orig(:, 4)));
    x(:, 5) = x_orig(:, 5) + sigma(5)*randn(size(x_orig(:, 5)));
    x(:, 6) = x_orig(:, 6) + sigma(6)*randn(size(x_orig(:, 6)));
    
    lev = 5;
    for i = 1:6
        xd(:, i) = wden(x(:, i),'minimaxi','s','sln',lev,'sym8');%sqtwolog,rigrsure,heursure,minimaxi
    end
    
    for d = 1:6
        SNR_in(d) = snr(x_orig(:,d), x(:,d));
        SNR_out(d) = snr(x_orig(:,d), xd(:,d));
    end
    
    SNR_in1(e, :) = SNR_in;
    SNR_out1(e, :) = SNR_out;
end

% Calculating the averaged SNR
SNR_In_Ave = mean(SNR_in1, 1)
SNR_Out_Ave = mean(SNR_out1, 1)
mean(SNR_Out_Ave)