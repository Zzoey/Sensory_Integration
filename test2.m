th = 0.1*max(I2(:)); % for the worst case 

I2_th = I2;

for i=1:d1
	for j=1:d2
		for k=1:d3_mod
			if I2_th(i,j,k) <= th
				I2_th(i,j,k) = 0;
			end
		end
	end
end

clear i j k;

I1_th = I1;
th2 = 0.1*max(I1(:));

for i=1:d1
	for j=1:d2
		for k=1:d3
			if I1_th(i,j,k) <= th2
				I1_th(i,j,k) = 0;
			end
		end
	end
end

clear i j k;



% Sliding neighbourhood

f = @(x) max(x(:));
temp2 = nlfilter(temp,[3 3],f);
imshow(temp);figure;imshow(temp2);


%Adaptive Histogram Equalization

J = adapthisteq(temp);
imshow(J)
figure, imshow(temp);


%  --- I3 - I1

I3 = I1;

for i=1:700
	I3(:,:,i) = nlfilter(I1(:,:,i),[3 3],f);
end

I3_th = I1_th;

for i=1:700
	I3_th(:,:,i) = nlfilter(I1_th(:,:,i),[3 3],f);
end

% -- I4 - I2

I4 = I2;

for i=1:234
	I4(:,:,i) = nlfilter(I2(:,:,i),[3 3],f);
end

I4_th = I2_th;

for i=1:234
	I4_th(:,:,i) = nlfilter(I2_th(:,:,i),[3 3],f);
end

% I5 - I1 AHE

I5 = I1;

for i=1:700
	I5(:,:,i) = adapthisteq(I1(:,:,i));
end

I5_th = I1_th;

for i=1:700
	I5_th(:,:,i) = adapthisteq(I1_th(:,:,i));
end

% -- I6 - I2 AHE

I6 = I2;

for i=1:234
	I6(:,:,i) = adapthisteq(I2(:,:,i));
end

I6_th = I2_th;

for i=1:234
	I6_th(:,:,i) = adapthisteq(I2_th(:,:,i));
end


%% K Means Movies 

% I1

label_I1_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I1_8(:,:,i),vec_mean] = kmeans_fast_Color(I1(:,:,i),8);
end

label_I1_th_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I1_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I1_th(:,:,i),8);
end

% I3

label_I3_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I3_8(:,:,i),vec_mean] = kmeans_fast_Color(I3(:,:,i),8);
end

label_I3_th_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I3_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I3_th(:,:,i),8);
end

% I5

label_I5_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I5_8(:,:,i),vec_mean] = kmeans_fast_Color(I5(:,:,i),8);
end

label_I5_th_8 = zeros(d1,d2,d3);

for i=1:d3
	[label_I5_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I5_th(:,:,i),8);
end

% I2

label_I2_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I2_8(:,:,i),vec_mean] = kmeans_fast_Color(I2(:,:,i),8);
end

label_I2_th_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I2_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I2_th(:,:,i),8);
end

% I4

label_I4_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I4_8(:,:,i),vec_mean] = kmeans_fast_Color(I4(:,:,i),8);
end

label_I4_th_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I4_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I4_th(:,:,i),8);
end

% I6

label_I6_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I6_8(:,:,i),vec_mean] = kmeans_fast_Color(I6(:,:,i),8);
end

label_I6_th_8 = zeros(d1,d2,d3_mod);

for i=1:d3_mod
	[label_I6_th_8(:,:,i),vec_mean] = kmeans_fast_Color(I6_th(:,:,i),8);
end






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


%% Average Intensities For Segmentation

d1 = 934;d2 = 615;d3 = 700;d3_mod = 234;

I1_avg = zeros(d1,d2);

for i=1:d1
	for j=1:d2
		I1_avg(i,j) = sum(I_org(i,j,:))/d3;
	end
end
I1_avg = uint16(I1_avg);

I = I1_avg; clear I1_avg;

% Texture based Segementation

E = entropyfilt(I);
Eim = mat2gray(E);
imshow(Eim);

BW1 = im2bw(Eim, .27);
imshow(BW1);



% Water Shed
load('seg.mat');
I2 = imadjust(imtophat(I, strel('disk', 9)));
level = graythresh(I2);
BW = im2bw(I2,level);
D = -bwdist(~BW,'chessboard');
D(~BW) = -Inf;
L = watershed(D);
imshow(label2rgb(L,'jet','w'))

% EM-MPM

load('seg.mat');
Is = emmpm(I, 8);
imshow(Is,[]);

% N Cut
% Fuzzy C Means 
% DB Scan - Super Pixels
% Morphological Based Segemntation 
% Mean Shift 
% Block Based Segmentation 
% OtSu Algorithm

% K Spectral Clustering 
% K Shape

%Otsu thresholding, adaptive thresholding, and watershed or random walker segmentation Adaptive Histogram.
% Texture based


load('SegmentDataFull.mat');

X = round(355590*rand(1,300000));

data = zeros(300000,700);

for i=1:300000
data(i,:) = FluoTraces(X(i),:);
end;


% Plotting 



C = {'k','b','r','g','y',[.5 .6 .7],[.8 .2 .6],[.2,.4,.7]};


figure;
CM = jet(16);
X = zeros(1,700);
for i=1:700
	X(i) = i;
end

subplot(4,4,8);
for i=1:10000
	if(mem(i)==8)
	plot(X(1,:),data(i,:),'color',CM(8,:));
	hold on;
	end
end
%hold on;

subplot(4,4,7);
for i=1:10000
	if(mem(i)==7)
	plot(X(1,:),data(i,:),'color',CM(7,:));
	hold on;
	end
end
%hold on;

subplot(4,4,6); % Taken This one
for i=1:10000
	if(mem(i)==6)
	plot(X(1,:),data(i,:),'color',CM(6,:));
	hold on;
	end
end
%hold on;

subplot(4,4,5);
for i=1:10000
	if(mem(i)==5)
	plot(X(1,:),data(i,:),'color',CM(5,:));
	%hold on;
	end
end
%hold on;

subplot(4,4,4);
for i=1:10000
	if(mem(i)==4)
	plot(X(1,:),data(i,:),'color',CM(4,:));
	hold on;
	end
end
%hold on;

subplot(4,4,3);
for i=1:10000
	if(mem(i)==3)
	plot(X(1,:),data(i,:),'color',CM(3,:));
	hold on;
	end
end
%hold on;

subplot(4,4,2);
for i=1:10000
	if(mem(i)==2)
	plot(X(1,:),data(i,:),'color',CM(2,:));
	hold on;
	end
end
%hold on;

subplot(4,4,1);
for i=1:10000
	if(mem(i)==1)
	plot(X(1,:),data(i,:),'color',CM(1,:));
	%hold on;
	end
end

subplot(4,4,9);
for i=1:10000
	if(mem(i)==9)
	plot(X(1,:),data(i,:),'color',CM(9,:));
	hold on;
	end
end

subplot(4,4,10);
for i=1:10000
	if(mem(i)==10)
	plot(X(1,:),data(i,:),'color',CM(10,:));
	
	end
end

subplot(4,4,11);
for i=1:10000
	if(mem(i)==11)
	plot(X(1,:),data(i,:),'color',CM(11,:));
	hold on;
	end
end

subplot(4,4,12);
for i=1:10000
	if(mem(i)==12)
	plot(X(1,:),data(i,:),'color',CM(12,:),'marker','o');
	end
end

subplot(4,4,13);
for i=1:10000
	if(mem(i)==13)
	plot(X(1,:),data(i,:),'color',CM(13,:),'marker','o');
	end
end

subplot(4,4,14);
for i=1:10000
	if(mem(i)==14)
	plot(X(1,:),data(i,:),'color',CM(14,:),'marker','o');
	end
end

subplot(4,4,15); % A bit similar though
for i=1:10000
	if(mem(i)==15)
	plot(X(1,:),data(i,:),'color',CM(15,:),'marker','o');
	end
end

subplot(4,4,16);
for i=1:10000
	if(mem(i)==16)
	plot(X(1,:),data(i,:),'color',CM(16,:),'marker','o');
	end
end


%% Finding Group of properly responding Neurons


newdata = data(find(mem==6),:);
[icasig, A, W] = fastica(newdata);

writerObj = VideoWriter('out.avi'); % Name it.
writerObj.FrameRate = 1; % How many frames per second.
open(writerObj); 

set(gca,'nextplot','replacechildren');

for i=1:144
		pause(0.1);
		plot(X,icasig(i,:));
		frame = getframe(gcf);
		writeVideo(writerObj, frame);
end

hold off
close(writerObj);

%movie2avi(M,'WaveMovie.avi','compression', 'None');

newdata = data(mem==6,:);

newdata = data(mem==11,:);
[mem cent] = ksc_toy(newdata, 6);

subplot(3,2,6);
p = newdata(find(mem==6),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end

subplot(3,2,1);
p = newdata(find(mem==1),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end

subplot(3,2,2);
p = newdata(find(mem==2),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end

subplot(3,2,3);
p = newdata(find(mem==3),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end

subplot(3,2,4);
p = newdata(find(mem==4),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end

subplot(3,2,5);
p = newdata(find(mem==5),:);
[m,n] = size(p);
for i=1:m
	plot(X(1,:),p(i,:));
	hold on;
end


%%  For deltaF/F 

avg_mat = zeros(145,1);

for i=1:145
	avg_mat(i,:) = sum(newdata(i,1:10))/10;
end


subplot(3,2,6);
p = newdata(find(mem==6),:);
k = find(mem==6);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

subplot(3,2,1);
p = newdata(find(mem==1),:);
[m,n] = size(p);
k = find(mem==1);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end
for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

subplot(3,2,2);
p = newdata(find(mem==2),:);
[m,n] = size(p);
k = find(mem==2);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end
for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

subplot(3,2,3);
p = newdata(find(mem==3),:);
[m,n] = size(p);
k = find(mem==3);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end
for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

subplot(3,2,4);
p = newdata(find(mem==4),:);
[m,n] = size(p);
k = find(mem==4);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end
for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

subplot(3,2,5);
p = newdata(find(mem==5),:);
[m,n] = size(p);
k = find(mem==5);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end
for i=1:m
	plot(X(1,:),q(i,:));
	hold on;
end

%% For AVG

avg_mat = zeros(145,1);

for i=1:145
	avg_mat(i,:) = sum(newdata(i,1:10))/10;
end


subplot(3,2,6);
p = newdata(find(mem==6),:);
k = find(mem==6);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

plot(X(1,:),final(1,:));

subplot(3,2,1);
p = newdata(find(mem==1),:);
[m,n] = size(p);
k = find(mem==1);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

plot(X(1,:),final(1,:));

subplot(3,2,2);
p = newdata(find(mem==2),:);
[m,n] = size(p);
k = find(mem==2);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

plot(X(1,:),final(1,:));

subplot(3,2,3);
p = newdata(find(mem==3),:);
[m,n] = size(p);
k = find(mem==3);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

plot(X(1,:),final(1,:));

subplot(3,2,4);
p = newdata(find(mem==4),:);
[m,n] = size(p);
k = find(mem==4);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

plot(X(1,:),final(1,:));

subplot(3,2,5);
p = newdata(find(mem==5),:);
[m,n] = size(p);
k = find(mem==5);
val = avg_mat(k);
[m,n] = size(p);
q = zeros(m,n);

for i=1:m
	q(i,:) = (p(i,:)-val(i))/val(i);
end

final = zeros(1,700);

for i=1:n
	final(:,i) = sum(q(:,i))/m; 
end

	plot(X(1,:),final(1,:));

