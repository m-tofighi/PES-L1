function [out] = PES_L1_Wavelet(Jk, NoisySignal, kk)

for k = 1:kk
    for f = 1:10
        x_dwt1 =  circshift(NoisySignal(:, k), f-1); % Shifting the signal
        [af, sf] = farras; % Wavelet transforms filters
        J = Jk(k); % Decomposition level
        x_dwt = dwt_C(x_dwt1,J,af); % Wavelet decomposition
        
        for q = 1:J+1
            % The high-passed subsignals are obtained here
            x_dwt_mat = cell2mat(x_dwt(q));
            x_dwt_mat = padarray(x_dwt_mat, 1, 'symmetric');
            DecomposedSignal = x_dwt_mat;
            x_hpf_col = [DecomposedSignal; 0];
            
            % Then the PES-L1 is applied to the high-passed subsignals
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
            sol = perform_l1ball_projection([DecomposedSignal; 0], sum(x_pp(1:end-1)));% Projection to L1-ball
            im_den(q) = {sol(2:end-2)};
        end
        
        % Reconstructing the signal from its subsignals
        im_den(J+1) = x_dwt(J+1);
        x_idwt1 = idwt_C(im_den, J, sf);
        x_idwt2(:, f) = circshift(x_idwt1, -f+1); % Shift back
    end
    x_idwt3 = mean(x_idwt2, 2);
    x_idwt(:, k) = x_idwt3;
end

out = x_idwt;
end