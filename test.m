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

% temp = I_mod(:,:,1);
% X = zeros(d1*d2,1);
%  
% for i=1:d1
%  	for j=1:d2
%  		p = temp(i,j);
%  		X(i*j,1) = p;
%  	end
% end
% 
% clear i j p temp;


load('All2.mat');
temp = I_mod(:,:,1);


% Performing Sliding Neighborhood Filtering

f = @(x) max(x(:));
temp2 = nlfilter(temp,[3 3],f);
imshow(temp);figure;imshow(temp2);

%Adaptive Histogram Equalization

J = adapthisteq(temp);
imshow(J)
figure, imshow(temp);

% Clustering

% Clusters - 3,4,5,6,7,8

% 1. Original
% 2. Original - AHE
% 3. Original - Sliding Neighbourhood Filering 
% 4. Thresholded 
% 5. Thresholded - AHE
% 6. Thresholded - Sliding Neighbourhood Filering 

% For Movies 

% -- For Dim Reduced 
% -- Direct Images


% K Means


[label,vec_mean] = kmeans_fast_Color(J,8);

M = zeros(934,615,3);

for i=1:934
	for j=1:615
 		if label(i,j)==1
			M(i,j,:) = [0 1 1]; % green
 		end
 		if label(i,j)==2
 			M(i,j,:) = [1 0 0]; %red
 		end
 		if label(i,j)==3
 			M(i,j,:) = [0 0 1]; % blue
		end
  		if label(i,j)==4
   			M(i,j,:) = [0,0,0]; %black
		end
		if label(i,j)==5
   			M(i,j,:) = [1,1,0]; 
		end
		if label(i,j)==6
   			M(i,j,:) = [1,0,1]; 
		end
		if label(i,j)==7
   			M(i,j,:) = [0,1,0]; 
		end
		if label(i,j)==8
   			M(i,j,:) = [1,1,1]; 
  		end
	end
end
imshow(M);



% Mean Shift 



























 
 



