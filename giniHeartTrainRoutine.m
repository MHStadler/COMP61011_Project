function [trainedModels, trainingResults, bestModel, testResult] = giniHeartTrainRoutine()

load samplers;

[crossFold, test] = heartSampler.split(5, 5);

crossFoldSampler = sampler(crossFold.data, crossFold.labels);

minErrRate = 200;


for i = 1:4
    [tr, te] = crossFoldSampler.split(i, 4);
    
    model = decisionTree().withCalculator(giniImpurityCalculator()).withMinCount(10).train(tr.data, tr.labels);
    res = model.test(te.data, te.labels);
    
    trainedModels(i, 1) = model;
    trainingResults(i, 1) = res;

    errRate = res.err();
    
    if(errRate < minErrRate)
        minErrRate = errRate;
        bestModel = model;
    end
end

testResult = bestModel.test(test.data, test.labels);

end