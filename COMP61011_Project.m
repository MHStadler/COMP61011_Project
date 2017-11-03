% ------------------------------------------------------------
% 
% This is the code we wrote for our COMP61011 Project: Experimental
% Analysis for Decision Trees that split on the F-Measure
%
% decisionTree is our base decisionTree that splits using different
% criteria, via its calculator object (uses F-Measure implementation by
% default)
% It works like MLOTools models (train & test) - methods withDepth,
% withMinCount are used to set depth and minCount to control the growth of
% the tree - withCalculator is used to override the used calculator and to
% switch to a different implementation
%
% Calculator objects provide 3 methods: calculatePreSplitValue
% getPostSplitValue and assessSplit. The first calculates a value for the
% tree before a split, the second a value for a potential split. The third
% is called by the decisionTree to see whether it should prefer this split
% to any that came before
%
% createPopFailure was used to build a matlab dataset from the UCI machine
% learning repository data in pop_failure
%
% We build our test data via buildTestSamplers and saved in samplers.mat -
% this loads the datasets into samplers, shuffles them and then saves the
% sampler objects.
%
% See *TrainRoutine files & GenerateSolution (we only used MutualInformation
% from this result as Gini had an error - so it was rewritten in the other style
%for our training and test procedures
%
% assessTrainResults calculates the avg error rate for a set of results
% printROCSpace prints some the ROC Space based on the given results
% rocCurve plots ROC Curve for the given classifier results
%
%