classdef fMeasureCalculator
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        betaFactor = 1;
    end
    
    methods
        function preSplitFMeasure = calculatePreSplitValue(obj, exampleCount, conditionPositive, conditionNegative)
            predictedLabel = 0;
            
            if(conditionPositive > conditionNegative)
                predictedLabel = 1;
            end
            
            
            if(predictedLabel == 0)
                preSplitFMeasure = obj.calculateFMeasure(0, 0);
            else
                preSplitFMeasure = obj.calculateFMeasure(conditionPositive, exampleCount, conditionPositive);
            end
        end
        
        function postSplitFMeasure = getPostSplitValue(obj, leftValues, leftLabels, rightValues, rightLabels)
            classifiedAsPositiveCount = 0;
            correctlyClassifiedAsPositiveCount = 0;
            classPositiveCount = 0;
            
            leftCount = size(leftLabels, 1);
            rightCount = size(rightLabels, 1);
             
            yLeft1 = nnz(leftLabels(:) == 1);
            yLeft0 = leftCount - yLeft1;
            
            yRight1 = nnz(rightLabels(:) == 1);
            yRight0 = rightCount - yRight1;
            
            classPositiveCount = yLeft1 + yRight1;
            
            if(yLeft1 > yLeft0)
                classifiedAsPositiveCount = classifiedAsPositiveCount + leftCount;
                
                correctlyClassifiedAsPositiveCount = correctlyClassifiedAsPositiveCount + nnz(leftLabels(:) == 1); 
            end
            
            if(yRight1 > yRight0)
                classifiedAsPositiveCount = classifiedAsPositiveCount + rightCount;
                
                correctlyClassifiedAsPositiveCount = correctlyClassifiedAsPositiveCount + nnz(rightLabels(:) == 1); 
            end
            
            postSplitFMeasure = obj.calculateFMeasure(correctlyClassifiedAsPositiveCount, classifiedAsPositiveCount, classPositiveCount);
        end
        
        function fMeasure = calculateFMeasure(obj, correctPositive, classifiedAsPositive, classPositiveCount)
            if(classifiedAsPositive == 0)
                fMeasure = 0;
            else
                precision = correctPositive / classifiedAsPositive;
                recall = correctPositive / classPositiveCount;

                if(precision == 0 && recall == 0)
                    fMeasure = 0;
                else
                    fMeasure = (1 + obj.betaFactor^2) * (precision * recall) / (obj.betaFactor^2 * precision + recall);
                end
            end
        end
    end
end

