v = VideoReader('car.avi');

while hasFrame(v)
frame = readFrame(v);

%com gray
%frame = rgb2gray(frame);

avgInten=mean2(frame);

bw=im2bw(frame,avgInten/255);


imshow(bw)

end