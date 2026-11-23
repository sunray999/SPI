function [img, spec] = getHSPIReconstruction( dataMat ,B,D)
        n=size(dataMat,1);
        % spec = (dataMat(:,:,1) - dataMat(:,:,2))/n;
        spec=(2*dataMat(:,:,1)-2*B)/n;
        
        img  = IHT(spec)/n;
%             S=ST(64);
%             img=S'*(spec)*S;
end
