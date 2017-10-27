function printROCSpace(results, resultLabels)
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
    
    rocPointsX(i, 1) = FP / N;
    rocPointsY(i, 1) = TP / P;
end

scatter(rocPointsX, rocPointsY, 16);
hold on;
plot([0, 1], [0, 1]);
axis([0, 1, 0, 1]);

for i=1:resultsSize
    text(rocPointsX(i) + 0.01, rocPointsY(i) + 0.01, resultLabels(i));
end

hold off;

end
