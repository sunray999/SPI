function [ hadamardPattern ] = getHadamardPattern( nPoint, u, v ,initPhase)
%   nPoint=64;u=1;v=1;
    spec = zeros(nPoint, nPoint);
    spec(u, v) = 1;
   hadamardPattern  = 0.5+0.5*IHT(spec);
%     S=ST(64);
%    hadamardPattern  = 0.5+0.5*S'*(spec)*S;
%     imshow(hadamardPattern)
    if initPhase == 2
        hadamardPattern = 1 - hadamardPattern;
    end
end
