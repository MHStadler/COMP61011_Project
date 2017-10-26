function rocCurve(result)

probabilities = result.probs;

resultSize = size(result.probs, 1)

for i=1:resultSize
    probabilities(i, 2) = i;
end

P = nnz(result.truelabels(:) == 1);
N = nnz(result.truelabels(:) == 0);

TP = 0;
FP = 0;

prevVal = -1;

%2012a fix - sort by dimension 1, use - to get descending
sortedProbabilities = sortrows(probabilities, -1)

count = 0;

for i=1:resultSize
    val = sortedProbabilities(i, 1);
    
    if(val ~= prevVal)
        count = count + 1;
        
        xVals(count, 1) = FP/N;
        yVals(count, 1) = TP/P;
        
        prevVal = val;
    end
    
    trueLabelIndex = sortedProbabilities(i, 2);
    trueLabel = result.truelabels(trueLabelIndex, 1);
    
    if(trueLabel == 1)
        TP = TP + 1;
    else
        FP = FP + 1;
    end
end

count = count + 1;

xVals(count, 1) = FP/N;
yVals(count, 1) = TP/P;

plot(xVals, yVals);

end