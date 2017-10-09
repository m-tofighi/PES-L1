function [out] = PES_L1_Pyramid(iter, NoisySignal, kk)

for k = 1:kk
        % The high-pass filter
        FilterCoef = firpm(6,[0 0 .45 .5]*2,[0 0 1 1]);
        r = round(size(FilterCoef, 2)/2);
        Signal = NoisySignal(:,k);
        
        for j = 1:iter(k)
            % The high-pass filter is applied here
            Signal = padarray(Signal, r-1, 'symmetric');
            x_hpf = conv(Signal, FilterCoef, 'same'); %high-passed signal
            x_or = Signal; %main signal
            x_hpf_col = [x_hpf; 0];
            
            % Then the PES-L1 is applied to the high-passed signal
            for i = 1:1
                x_sgn = [sign(x_hpf_col(1:end-1)); -1];
                x_sgn(x_sgn==0) = 1;
                xxp = [x_hpf_col(1:end-1); 0];
                x_in = (xxp'*x_sgn)/numel(xxp);
                x_p = xxp - x_in.*x_sgn;
                x_pp = x_p.*x_sgn;
                x_hpf_col = [x_p(1:end-1); sum(x_pp(1:end-1))];
                
                
                x_sgn_new = sign(x_hpf_col);
                arg = x_sgn_new-x_sgn;
                [ind1 val1] = find(arg == 2);
                [ind2 val2] = find(arg == -2);
                x_hpf_col(ind1) = 0;
                x_hpf_col(ind2) = 0;
                
            end
            sol = perform_l1ball_projection([x_hpf;0], sum(x_pp(1:end-1))); % Projecting to L1-ball
            x_lpf = x_or - x_hpf; % low-passed signal
            x_lpf = [x_lpf; 0];
            xl = sol;
            xl = xl + x_lpf; % mixing high and low passed part of signals
            
            Signal = xl(r:end-r);
        end
        DenoisedSignal(:,k) = Signal;
end

out = DenoisedSignal;
end

