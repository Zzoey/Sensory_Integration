load('SegmentDataFull.mat');

data = FluoTraces(3:355590,:);
clearvars -except data;
[m n] = size(data);
haar = zeros(m,n);
s = 2;

for i=1:m
	haar(i,:) = pm_haar(data(i,:),s);
end

for j=1:9
	for i=1:700
		y
	end
end
