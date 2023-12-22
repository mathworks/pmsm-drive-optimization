function resp = combinefreqresp( resp1, resp2 )
%COMBINEFREQRESPONSE Combine the frequency responses provided as inputs.

% Copyright 2022 The MathWorks, Inc. 

arguments
    resp1 (1,1) frd
    resp2 (1,1) frd
end

freq1 = resp1.Frequency;
freq2 = resp2.Frequency;
data1 = resp1.ResponseData;
data2 = resp2.ResponseData;
N1 = numel(data1);
N2 = numel(data2);

% Concatenate responses
freq = [ freq1; freq2 ];
data = zeros(1,1,N1+N2);
data(1,1,1:N1) = data1;
data(1,1,N1+1:N1+N2) = data2;

% Reorder frequencies in increasing order
[freq,I] = sort(freq);
data = data(I);

% Remove any frequency duplicates
[freq,I] = unique(freq);
data = data(I);

% Create new frequency-response data model
resp = frd( data, freq );

end

