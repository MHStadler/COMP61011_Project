classdef mutualInformationCalculator
    properties
    end
    
    methods
        function preSplitEntropy = calculatePreSplitValue(obj, exampleCount, conditionPositive, conditionNegative)
            preSplitEntropy = obj.calculateEntropy(exampleCount, conditionPositive, conditionNegative);
        end
        
        function postSplitEntropy = getPostSplitValue(obj, leftLabels, rightLabels)
            leftCount = size(leftLabels, 1);
            rightCount = size(rightLabels, 1);
             
            count = leftCount + rightCount;
            
            yLeft1 = nnz(leftLabels(:) == 1);
            yLeft0 = leftCount - yLeft1;
            
            yRight1 = nnz(rightLabels(:) == 1);
            yRight0 = rightCount - yRight1;
			
			leftEntropy = obj.calculateEntropy(leftCount, yLeft1, yLeft0);
			rightEntropy = obj.calculateEntropy(rightCount, yRight1, yRight0);
            
			postSplitEntropy = (leftCount/count) * leftEntropy + (rightCount/count)  * rightEntropy;
        end
        
        function entropy = calculateEntropy(obj, count, conditionPositive, conditionNegative)
			oddsPositive = conditionPositive / count;
			oddsNegative = conditionNegative / count;
		
			entropy = -1 * (log2(oddsPositive) * oddsPositive + log2(oddsNegative) * oddsNegative);
		end
    end
end

