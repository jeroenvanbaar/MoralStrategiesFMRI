function contrastVector = contrastParser(inputString)

inputString(ismember(inputString,' ,.:;!')) = [];
inputString(ismember(inputString,'?')) = '-';

%Find operators and get number positions
operatorBoolean = ismember(inputString,'-+');
operatorIndices = find(operatorBoolean);
if operatorBoolean(1) == 1
    numberStarts = operatorIndices+1;
    numberEnds = [operatorIndices(2:end)-1 numel(operatorBoolean)];
else
    numberStarts = [1 operatorIndices+1];
    numberEnds = [operatorIndices-1 numel(operatorBoolean)];
end

%Use numbers to fill in contrast vector
contrastVector = zeros(1,1000);
numbers = zeros(1,length(numberStarts));
for i = 1:length(numberStarts)
    number = str2double(inputString(numberStarts(i):numberEnds(i)));
    if numberStarts(i) > 1
        if strcmp(inputString(numberStarts(i)-1),'-')
            contrastVector(number) = -1;
        else
            contrastVector(number) = 1;
        end
    else
        contrastVector(number) = 1;
    end
    numbers(i) = number;
end

%Truncate contrast vector
contrastVector(max(numbers)+1:end) = [];

end