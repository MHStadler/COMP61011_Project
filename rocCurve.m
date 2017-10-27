function area = rocCurve(result)

probabilities = result.probs;

resultSize = size(result.probs, 1)

for i=1:resultSize
    probabilities(i, 2) = i;
end

P = nnz(result.truelabels(:) == 1);
N = nnz(result.truelabels(:) == 0);

TPPrev = 0;
FPPrev = 0;

TP = 0;
FP = 0;

prevVal = -1;

%2012a fix - sort by dimension 1, use - to get descending
sortedProbabilities = sortrows(probabilities, -1)

count = 0;

A = 0;

for i=1:resultSize
    val = sortedProbabilities(i, 1);
    
    if(val ~= prevVal)
        count = count + 1;
        
        xVals(count, 1) = FP/N;
        yVals(count, 1) = TP/P;
        
        A = A + calcTrapezoidArea(FP, FPPrev, TP, TPPrev);
        
        TPPrev = TP;
        FPPrev = FP;
        
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

A = A + calcTrapezoidArea(N, FPPrev, N, TPPrev);

A = A / (N * P);

plot(xVals, yVals);

area = A;

end

function area = calcTrapezoidArea(X1, X2, Y1, Y2)

base = abs(X1 - X2);
height = (Y1 + Y2) / 2;

area = base * height;

end