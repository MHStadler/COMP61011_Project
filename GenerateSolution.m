clear

load samplers

modellist = [];
%modellist = [modellist; struct('name','ofm','calculator',otherFMeasureCalculator)];
modellist = [modellist; struct('name','mi','calculator',mutualInformationCalculator)];
modellist = [modellist; struct('name','gi','calculator',giniImpurityCalculator)];

datalist = [];
datalist = [datalist; struct('name','breast','sampler',breastSampler,'minCount',20)];
datalist = [datalist; struct('name','heart','sampler',heartSampler,'minCount',10)];
datalist = [datalist; struct('name','popFailure','sampler',popFailureSampler,'minCount',5)];

% Loop through every dataset
for i = 1:size(datalist,1)
    datalist(i).name

    [nx,nf,pr,corr,mi] = evaluateDataset(datalist(i).sampler.data,datalist(i).sampler.labels);
    datalist(i).('properties') = struct('exampleCount',nx,'featureCount',nf,'positiveRatio',pr,'pearson',corr,'mutualInformation',mi);

    % Split into cross validation and testing data
    % use 4 folds of cross validation and save the final 5th for
    % testing when we compare different models
    [xvalidationdata, modeltestdata] = datalist(i).sampler.split(5,5);

    crossvalidation(1:4) = struct();
    for x = 1:4
        [crossvalidation(x).('tr'), crossvalidation(x).('te')] = xvalidationdata.split(x,4);
    end

    % Build trained models for each model type
    for modelindex = 1:size(modellist,1)
        modellist(modelindex).name

        % keep track of the errors so we can calculate the std
        modelerrors = zeros(4,1);
        % for each cross validation fold
        for x = 1:4
            % build the model
            model = decisionTree().withDepth(10).withMinCount(datalist(i).minCount).withCalculator(modellist(modelindex).calculator);
            % train it on the training data for this fold
            model = model.train(crossvalidation(x).tr.data, crossvalidation(x).tr.labels);
            % test it on the testing data for this fold
            res = model.test(crossvalidation(x).te.data, crossvalidation(x).te.labels);
            % store the model and its performance
            modelerrors(x) = res.err();
            crossvalidation(x).(modellist(modelindex).name) = struct('model',model,'res',res);
            % remember this model if it's the first / best model so far
            % for ths model type
            if ~exist('bestFoldModel','var') || res.err() < bestErr
                bestFoldModel = model;
                bestErr = res.err();
            end
            
            clear model res
        end

        % perform the final test and store the best model and its final
        % test result in the struct for this data
        finalRes = bestFoldModel.test(modeltestdata.data,modeltestdata.labels);
        datalist(i).(modellist(modelindex).name) = struct('model',bestFoldModel,'res',finalRes,'errors',modelerrors);
        
        clear modelerrors bestFoldModel bestErr finalRes
    end
    
    datalist(i).('crossValidationResults') = crossvalidation;
    
    % Reset for the next dataset
    clear data labels nx nf pr corr mi xvalidationdata modeltestdata crossvalidation
end