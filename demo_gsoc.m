fname = 'GCamp6s-8tones-F5_40um.tif';
info = imfinfo(fname);
num_images = numel(info);

for k=1:num_images
    A = imread(fname,k);
    I_org(:,:,k)=A;
end;

clear A k num_images info fname;

d1 = 934;d2 = 615;d3 = 700;d3_mod = 234;

I1_avg = zeros(d1,d2);

for i=1:d1
	for j=1:d2
		I1_avg(i,j) = sum(I_org(i,j,:))/d3;
	end
end
I1_avg = uint16(I1_avg);

I = I1_avg; clear I1_avg;


%% Water shed using Matlab
I2 = imadjust(imtophat(I, strel('disk', 9)));
level = graythresh(I2);
BW = im2bw(I2,level);
D = -bwdist(~BW,'chessboard');
D(~BW) = -Inf;
L = watershed(D);
imshow(label2rgb(L,'jet','w'))


