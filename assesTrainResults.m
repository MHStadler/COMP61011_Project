function [fAvgErr, fStd, fAvgFm, fStdF, giniAvgErr, giniStd, giniAvgFm, giniStdF, miAvgErr, miStd, miAvgFm, miStdF] = assesTrainResults(fTrainingResults, giniTrainingResults, miTrainingResults)

fErrRates = zeros(4, 1);
giniErrRates = zeros(4, 1);
miErrRates = zeros(4, 1);

fFMeasures = zeros(4, 1);
giniFMeasures = zeros(4, 1);
miFMeasures = zeros(4, 1);

for i=1:4
    fErrRates(i) = fTrainingResults(i, 1).err();
    fFMeasures(i) = calcFMeasureForResult(fTrainingResults(i, 1));
    
    giniErrRates(i) = giniTrainingResults(i, 1).err();
    giniFMeasures(i) = calcFMeasureForResult(giniTrainingResults(i, 1));
    
    miErrRates(i) = miTrainingResults(i, 1).err();
    miFMeasures(i) = calcFMeasureForResult(miTrainingResults(i, 1));
end

fAvgErr = mean(fErrRates);
fStd = std(fErrRates);
fAvgFm = mean(fFMeasures);
fStdF = std(fFMeasures);

giniAvgErr = mean(giniErrRates);
giniStd = std(giniErrRates);
giniAvgFm = mean(giniFMeasures);
giniStdF = std(giniFMeasures);

miAvgErr = mean(miErrRates);
miStd = std(miErrRates);
miAvgFm = mean(miFMeasures);
miStdF = std(miFMeasures);

end