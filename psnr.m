function [psnr] = psnr(x,y)

D = abs(x-y).^2;
mse = sum(D(:))/numel(x);

psnr = 10*log10((max(x(:))^2)/mse);

end