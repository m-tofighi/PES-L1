clear all
close all
clc

% Please add this toolbox: "A Numerical Tour of Signal Processing" by Gabriel Peyre
f0 = zeros(1024,8);
load ex4mwden
clear x
whos
f0 = x_orig;

for i = 1:1
    f0(:, 5) = load_signal('Piece-Regular', 1024);
    f0(:, 6) = load_signal('cusp', 1024);
    kp = 0;
    kk = 6;
    for m = 1:kk
        sigma(m) = 0.2*max(f0(:, m));
    end
    f(:, 1) = f0(:, 1) + sigma(1)*randn(size(f0(:, 1)));
    f(:, 2) = f0(:, 2) + sigma(2)*randn(size(f0(:, 2)));
    f(:, 3) = f0(:, 3) + sigma(3)*randn(size(f0(:, 3)));
    f(:, 4) = f0(:, 4) + sigma(4)*randn(size(f0(:, 4)));
    f(:, 5) = f0(:, 5) + sigma(5)*randn(size(f0(:, 5)));
    f(:, 6) = f0(:, 6) + sigma(6)*randn(size(f0(:, 6)));
    
    for j = 1:6
    Theta0 = @(x,T)x .* (abs(x)>T);
    Theta1 = @(x,T)max(0, 1-T./max(abs(x),1e-9)) .* x;
    options.ti = 0; Jmin = 4;
    W  = @(f) perform_wavelet_transf(f,Jmin,+1,options);
    Wi = @(fw)perform_wavelet_transf(fw,Jmin,-1,options);
    fi = W(f(:, j));
    x1 = Theta0(fi, 3*sigma(j));
    f1(:, j) = Wi(x1);
    SNR_in(j) = snr(f0(:,j), f(:, j));
    SNRo(j) = snr(f0(:, j), f1(:, j));
    end
    SNR_in1(i, :) = SNR_in;
    SNRo_f(i, :) = SNRo;
end

SNR_In_Ave = mean(SNR_in1, 1)
SNR_Out_Ave = mean(SNRo_f, 1)
mean(SNR_Out_Ave)