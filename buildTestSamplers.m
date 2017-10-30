function [breastSampler, heartSampler, popFailureSampler] = buildTestSamplers()

load breast;
breastSampler = sampler(data, labels).randomize(); 

load heart;
heartSampler = sampler(data, labels).randomize();

load popfailures
popFailureSampler = sampler(data, labels).randomize();

end