% Vinay Chandragiri, Summer 2015, SBMS, UQ
tic;
clear all;
clc;

%% Acquiring Images

fname = 'GCamp6s-8tones-F5_40um.tif';
info = imfinfo(fname);
num_images = numel(info);

for k=1:num_images
    A = imread(fname,k);
    I_org(:,:,k)=A;
end;

clear A k num_images info fname;

[d1,d2,d3] = size(I_org);

%% Image Selection due to Delay in Calicium Imaging 200ms ~ 1sec equivalent to 5 frames
% Reduced the temporal dimension by 3 times by considering the spiked
% neuron once and ingoring the exponential decay in it.


I_mod = I_org(:,:,1:3:d3);

[d1,d2,d3_mod] = size(I_mod);

%% Equalizing the _delta_F for each Neuron that cannot be considered as a spike - Removed not suitable neurons
% At maximum - The first ignored frame's spiked neurons need to be
% considered in the fourth frame as a spike. So therefore the threshold
% would be "_delta2f - _delta5f " - Any amount of pixel value greater than
% this threshold can be considered as a spike.

% Assuming The Peak Decreases exponentially - Approximation https://github.com/alimuldal/PyFNND/blob/master/pyfnnd/_fnndeconv.py
% Spike value ~= th after fourth
% making all pixel value zero <= th  ---> Threshold

th = 0.1*max(I_mod(:)); % for the worst case 

I2_mod = I_mod;

for i=1:d1
	for j=1:d2
		for k=1:d3_mod
			if I2_mod(i,j,k) <= th
				I2_mod(i,j,k) = 0;
			end
		end
	end
end

clear i j k;

I2_org = I_org;
th2 = 0.1*max(I_org(:));

for i=1:d1
	for j=1:d2
		for k=1:d3
			if I2_org(i,j,k) <= th2
				I2_org(i,j,k) = 0;
			end
		end
	end
end

clear i j k;

%% Clustering these Viable Neurons in that Image

temp = I_mod(:,:,1);
X = zeros(d1*d2,3);

for i=1:d1
	for j=1:d2
		p = temp(i,j);
		X(i*j,:) = [i,j,p];
	end
end

clear i j p temp;



























 
 



