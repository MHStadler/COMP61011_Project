classdef giniImpurityCalculator
    properties
    end
    
    methods
        function preSplitGiIndex = calculatePreSplitValue(obj, exampleCount, conditionPositive, conditionNegative)
            preSplitGiIndex = obj.calculateGIndex(exampleCount, conditionPositive, conditionNegative);
        end
        
        function postSplitGiIndex = getPostSplitValue(obj, leftLabels, rightLabels)
            leftCount = size(leftLabels, 1);
            rightCount = size(rightLabels, 1);
             
            count = leftCount + rightCount;
            
            yLeft1 = nnz(leftLabels(:) == 1);
            yLeft0 = leftCount - yLeft1;
            
            yRight1 = nnz(rightLabels(:) == 1);
            yRight0 = rightCount - yRight1;
			
			leftGiIndex = obj.calculateGIndex(leftCount, yLeft1, yLeft0);
			rightGiIndex = obj.calculateGIndex(rightCount, yRight1, yRight0);
            
			postSplitGiIndex = (leftCount/count) * leftGiIndex + (rightCount/count)  * rightGiIndex;
        end
        
        function [shouldSplit, newBestMeasure] = assessSplit(obj, preSplitMeasure, currBestSplitMeasure, newSplitMeasure)
            measureDifference = preSplitMeasure - newSplitMeasure;
            
            if(measureDifference > currBestSplitMeasure) 
                shouldSplit = true;
                newBestMeasure = measureDifference;
            else
                shouldSplit = false;
                newBestMeasure = measureDifference;
            end
        end
        
        function gIndex = calculateGIndex(obj, count, conditionPositive, conditionNegative)
            oddsPositive = conditionPositive / count;
			oddsNegative = conditionNegative / count;
            
            gIndex = 1 - (oddsPositive^2 + oddsNegative^2);
            
        end
    end
end

