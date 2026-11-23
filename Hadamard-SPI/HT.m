function [x] = HT(spec)

x=fwht(fwht(spec).').';%/sqrt(numel(spec));


end

