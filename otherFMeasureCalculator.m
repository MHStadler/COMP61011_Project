classdef otherFMeasureCalculator
    properties
        betaFactor = 1;
    end
    
    methods
        function calc = withBetaFactor(obj, bFactor)
            obj.betaFactor = bFactor;
            calc = obj;
        end
        
        function preSplitFMeasure = calculatePreSplitValue(obj, exampleCount, conditionPositive, conditionNegative)
            if(conditionPositive > conditionNegative) 
                preSplitFMeasure = obj.calculateFMeasure(conditionPositive, conditionNegative);
            else
                preSplitFMeasure = obj.calculateFMeasure(conditionNegative, conditionPositive);
            end
        end
        
        function postSplitFMeasure = getPostSplitValue(obj, leftLabels, rightLabels)
            leftCount = size(leftLabels, 1);
            rightCount = size(rightLabels, 1);
             
            yLeft1 = nnz(leftLabels(:) == 1);
            yLeft0 = leftCount - yLeft1;
            
            yRight1 = nnz(rightLabels(:) == 1);
            yRight0 = rightCount - yRight1;
            
            count = leftCount + rightCount;
            
            if(yLeft1 > yLeft0)
                fMeasureLeft = obj.calculateFMeasure(yLeft1, yLeft0);
            else
                fMeasureLeft = obj.calculateFMeasure(yLeft0, yLeft1);
            end
            
            if(yRight1 > yRight0)
                fMeasureRight = obj.calculateFMeasure(yRight1, yRight0);
            else
                fMeasureRight = obj.calculateFMeasure(yRight0, yRight1);
            end
            
            postSplitFMeasure = (leftCount / count) * fMeasureLeft + (rightCount / count) * fMeasureRight;
        end
        
        function [shouldSplit, newBestMeasure] = assessSplit(obj, preSplitMeasure, currBestSplitMeasure, newSplitMeasure)
            if(newSplitMeasure > currBestSplitMeasure)
                shouldSplit = true;
                newBestMeasure = newSplitMeasure;
            else
                shouldSplit = false;
                newBestMeasure = currBestSplitMeasure;
            end
        end
        
        function fMeasure = calculateFMeasure(obj, TP, FP)
            if(TP == 0) 
                fMeasure = 0;
            else
                fMeasure = (1 + obj.betaFactor^2) * TP / ((1 + obj.betaFactor^2) * TP + FP);
            end
        end
    end
end