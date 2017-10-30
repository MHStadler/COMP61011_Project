function [trainedModels, trainingResults, bestModel, testResult] = fMeasureBreastTrainRoutine()

load samplers;

[crossFold, test] = breastSampler.split(5, 5);

crossFoldSampler = sampler(crossFold.data, crossFold.labels);

minErrRate = 200;


for i = 1:4
    [tr, te] = crossFoldSampler.split(i, 4);
    
    model = decisionTree().withMinCount(20).train(tr.data, tr.labels);
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