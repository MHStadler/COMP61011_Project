function fMeasure = calcFMeasureForResult(res)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

Y = nnz(res.labels(:) == 1)
P = nnz(res.truelabels(:) == 1)
TP = nnz(res.truelabels(:) == 1 & res.labels(:) == 1)

fMeasure = 2 * (TP/P * TP/Y) / (TP/P + TP/Y);

end

