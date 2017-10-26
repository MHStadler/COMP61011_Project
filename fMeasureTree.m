classdef fMeasureTree
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        calculator = fMeasureCalculator();
        
        %max amount of tree levels
        depth = 10;
        %mininum count of items a leaf can have
        minCount = 20;
        %beta Value that indicates how much recall should be valued over
        %precision
        betaFactor = 1;
        
        %training data on this branch
        trainingData = [];
        %true labels of the training data
        trainingLabels = [];
        
        %Amount of examples on this branch
        exampleCount = 0;
        %Amount of features in the training data
        featureCount = 0;
        
        %Amount of positives in the training data on this branch
        classPositiveCount = 0;
        %Amount of negatives in the training data on this branch
        classNegativeCount = 0;
        
        %The feature this branch splits on
        splitFeature;
        %The value that this branch splits on
        splitValue;
        
        %The FMeasure for this branch before it is split - used as base to
        %calculate the value in a specific split -> increase in FMeasure
        preSplitFMeasure = 0;
        
        %Data & Labels to the left, after a split
        leftData = [];
        leftLabels = [];
        
        %Data & Labels to the right, after a split
        rightData = [];
        rightLabels = [];
        
        %Model used to evaluate data that falls to the left of the split,
        %where x <= splitValue
        leftModel;
        %Model used to evaluate data that falls to the right of the split,
        %where x > splitValue
        rightModel;
        
        %Predicted label for this branch
        predictedLabel = -1;
        %Flag indiciating whether this item is a leaf -> bottom of the tree
        isLeaf = false;
    end
    
    methods
        function model = withDepth(obj, depth)
            obj.depth = depth;
            model = obj;
        end
        
        function model = withMinCount(obj, minCount)
            obj.minCount = minCount;
            model = obj;
        end
        
        function model = withCalculator(obj, calc)
            obj.calculator = calc;
            model = obj;
        end
        
        function newModel = train(obj, data, labels)
            obj.trainingData = data;
            obj.trainingLabels = labels;
            obj.exampleCount = size(data, 1);
            obj.featureCount = size(data, 2);
            
            obj = doTraining(obj);
            
            newModel = obj;
        end
        
        function trainedModel = doTraining(obj)
            obj.classPositiveCount = nnz(obj.trainingLabels(:) == 1);
            obj.classNegativeCount = nnz(obj.trainingLabels(:) == 0);
            
            if(obj.classPositiveCount > obj.classNegativeCount)
                obj.predictedLabel = 1;
            else
                obj.predictedLabel = 0;
            end
            
            if(obj.classNegativeCount == 0)
                obj.isLeaf = true;
            elseif(obj.classPositiveCount == 0)
                obj.isLeaf = true;
            elseif(obj.exampleCount <= obj.minCount || obj.depth == 0)
                obj.isLeaf = true;
            else
                obj = obj.findBestSplit();
            end
            
            trainedModel = obj;
        end
        
        
        
        function trainedModel = findBestSplit(obj)
            calc = obj.calculator;
            obj.preSplitFMeasure = calc.calculatePreSplitValue(obj.exampleCount, obj.classPositiveCount, obj.classNegativeCount);
            
            maxFMeasureIncrease = 0;
            
            %Check every feature for bestSplitValues
            for feature=1:obj.featureCount
                featureVector = obj.trainingData(:, feature);
                
                for example=1:obj.exampleCount
                    testSplitValue = featureVector(example);

                    [fMeasure, leftValues, leftValuesLabels, rightValues, rightValuesLabels] = obj.splitOnVal(featureVector, testSplitValue);
                
                    fMeasureIncrease = abs(fMeasure - obj.preSplitFMeasure);
                    
                    newSplit = false;
                    
                    if(fMeasureIncrease > maxFMeasureIncrease)
                        newSplit = true;
                    elseif(fMeasureIncrease == maxFMeasureIncrease && isempty(obj.leftData) || isempty(obj.rightData))
                        newSplit = true;
                    end
                    
                    if(newSplit)
                        maxFMeasureIncrease = fMeasureIncrease;
                        
                        obj.splitValue = testSplitValue;
                        obj.splitFeature = feature;
        
                        obj.leftData = leftValues;
                        obj.leftLabels = leftValuesLabels;
                        
                        obj.rightData = rightValues;
                        obj.rightLabels = rightValuesLabels;
                    end
                end
            end
            
            if(~isempty(obj.leftData) && ~isempty(obj.rightData))
                obj.leftModel = fMeasureTree().withMinCount(obj.minCount).withDepth(obj.depth - 1).train(obj.leftData, obj.leftLabels);
                obj.rightModel = fMeasureTree().withMinCount(obj.minCount).withDepth(obj.depth - 1).train(obj.rightData, obj.rightLabels);
            else
                obj.isLeaf = true;
            end
            
            trainedModel = obj;
        end
        
        function [fMeasure, leftValues, leftLabels, rightValues, rightLabels] = splitOnVal(obj, featureVector, testSplitValue)
            leftValues = [];
            leftValuesLabels = [];
            rightValues = [];
            rightValuesLabels = [];
            
            %Count of items classified as positive (y=1)
            classifiedAsPositiveCount = 0;
            %Count of items correctly classified as positive
            %(y=1=testLabel)
            correctlyClassifiedAsPositiveCount = 0;
            
            yRight0 = 0;
            yRight1 = 0;
            
            yLeft0 = 0;
            yLeft1 = 0;
            
            rightCount = 0;
            leftCount = 0;
            
            [leftValues, leftLabels, rightValues, rightLabels] = obj.splitOnValue(featureVector, testSplitValue);
            
            fMeasure = obj.calculator.getPostSplitValue(leftValues, leftLabels, rightValues, rightLabels);  
        end
        
        
        function [leftValues, leftLabels, rightValues, rightLabels] = splitOnValue(obj, featureVector, testSplitValue)
            leftValues = [];
            leftLabels = [];
            rightValues = [];
            rightLabels = [];
            
            rightCount = 0;
            leftCount = 0;
            
            for i=1:obj.exampleCount
                if(featureVector(i) > testSplitValue)
                    rightCount = rightCount + 1;
                    
                    rightValues(rightCount, :) = obj.trainingData(i, :);
                    rightLabels(rightCount, 1) = obj.trainingLabels(i);
                else
                    leftCount = leftCount + 1;
                    
                    leftValues(leftCount, :) = obj.trainingData(i, :);
                    leftLabels(leftCount, 1) = obj.trainingLabels(i);
                end
            end
        end
        
        function result = test(obj, data, labels)
            dataSize = size(data, 1);
            
            predictedLabels = zeros(dataSize, 1);
            positivePredictionRatios = zeros(dataSize, 1);
            
            for i = 1:dataSize
                [predLabel, positivePredictionRatio] = obj.predictLabel(data(i, :));
                
                predictedLabels(i, 1) = predLabel;
                positivePredictionRatios(i, 1) = positivePredictionRatio;
            end
            
            result = results(predictedLabels);
            result.addposteriors(positivePredictionRatios);
            
            if exist('labels','var') 
                result.addtruelabels(labels);
            end
        end
        
        function [predictedLabel, positiveDecisionRatio] = predictLabel(obj, val)
            if(obj.isLeaf == 1)
                predictedLabel = obj.predictedLabel;
                
                positiveDecisionRatio = obj.getLaplaceCorrectedProbalityForPositive();
            else
                testValue = val(obj.splitFeature);
                
                if(testValue > obj.splitValue)
                    [predictedLabel, positiveDecisionRatio] = obj.rightModel.predictLabel(val);
                else
                    [predictedLabel, positiveDecisionRatio] = obj.leftModel.predictLabel(val);
                end
            end
        end
        
        function preSplitFMeasure = calculatepreSplitFMeasure(obj)
            if(obj.predictedLabel == 0)
                preSplitFMeasure = obj.calculateFMeasure(0, 0);
            else
                preSplitFMeasure = obj.calculateFMeasure(obj.classPositiveCount, obj.exampleCount);
            end
        end
        
        function fMeasure = calculateFMeasure(obj, correctPositive, classifiedAsPositive)
            if(classifiedAsPositive == 0)
                fMeasure = 0;
            else
                precision = correctPositive / classifiedAsPositive;
                recall = correctPositive / obj.classPositiveCount;

                if(precision == 0 && recall == 0)
                    fMeasure = 0;
                else
                    fMeasure = (1 + obj.betaFactor^2) * (precision * recall) / (obj.betaFactor^2 * precision + recall);
                end
            end
        end
        
        function prob = getLaplaceCorrectedProbalityForPositive(obj)
            %Laplace corrected Probability = (k+1)/N+C where k is the
            %amount of examples that we predict to be class 1, N the total number of examles and C the amount of classes (Provost & Domingos, 2001) 
            prob = (obj.classPositiveCount + 1) / (obj.exampleCount + 2);
        end
    end
end

