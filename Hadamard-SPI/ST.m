function As1 = ST(N)
    % 确保N是2的幂次方
    %%if ~ispow2(N)
        %5error('N must be a power of 2');
    %end
    
    % 递归生成斜矩阵SN
    SN = generateSMatrix(N);
    
    % 计算斜变换矩阵As1
    As1 = (1/sqrt(N)) * SN;
end

function SN = generateSMatrix(N)
    if N == 2
        SN = [1 1; 1 -1];
    else if N==4
         SN=[1,1,1,1;
             3/5^0.5,1/5^0.5,-1/5^0.5,-3/5^0.5;
             1,-1,-1,1;
             1/5^0.5,-3/5^0.5,3/5^0.5,-1/5^0.5];
    else
        aN = sqrt((3 * N^2) / (4 * (N^2 - 1)));
        bN = sqrt((N^2 - 4) / (4 * (N^2 - 1)));
        
        SN_half = generateSMatrix(N/2);
        I_half_minus_2 = eye(N/2 - 2);
        o=zeros(1,N/2-2);
        M=zeros(1,N);
        K=zeros(N/2,N/2);
        H=zeros(N/2-2,2);
        SN = [
            1         0     o       1    0  o;
            aN       bN     o        -aN bN  o;
           H I_half_minus_2 H I_half_minus_2;
            0         1     o    0    -1 o;
            -bN       aN    o        bN aN o;
            H       I_half_minus_2  H  -I_half_minus_2
        ]*[ SN_half K;K SN_half];
    end
    end 
end
