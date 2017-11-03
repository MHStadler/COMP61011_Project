function printROCSpace(results, resultLabels, markers)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

resultsSize = size(results, 2);

rocPointsX = zeros(resultsSize, 1);
rocPointsY = zeros(resultsSize, 1);

for i=1:resultsSize
    result = results(i);
    
    TP = 0;
    FP = 0;
    
    P = nnz(result.truelabels(:) == 1);
    N = nnz(result.truelabels(:) == 0);
    
    labelsSize = size(result.truelabels, 1);
    
    for j=1:labelsSize
        if(result.labels(j, 1) == 1)
            if(result.truelabels(j, 1) == 1) 
                TP = TP + 1;
            else
                FP = FP + 1;
            end
        end
    end
    
    FPRate = FP/N;
    TPRate = TP/P;
    
    rocPointsX(i, 1) = FPRate;
    rocPointsY(i, 1) = TPRate;
    
    scatter(FPRate, TPRate, 140, markers(i));
    
    ar{i} = resultLabels(i);
    
    hold all;
end

plot([0, 1], [0, 1]);
axis([0, 1, 0, 1]);

legend(ar, 'Location', 'southeast');

xlabel('FP-rate');
ylabel('TP-rate');

grid;

hold off;

end

