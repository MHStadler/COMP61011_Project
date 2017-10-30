function [data, labels] = createPopFailure()

load pop_failures.dat;

count = size(pop_failures, 1);

data = zeros(count, 18);
labels = zeros(count, 1);

for i = 1:count
    data(i, :) = pop_failures(i, 3:20);
    
    label = pop_failures(i, 21);
    
    if(label == 0)
        labels(i) = 1;
    else
        labels(i) = 0;
    end
end

end