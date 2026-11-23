function [x] = IHT(spec)

x=ifwht(ifwht(spec).').';%/sqrt(numel(spec));


end

