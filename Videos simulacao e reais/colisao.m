v = VideoReader('Tratado_1.avi');

while hasFrame(v)
frame = readFrame(v);

%com gray
%frame = rgb2gray(frame);

avgInten=mean2(frame);

%bw=im2bw(frame,avgInten/255);
bw=im2bw(frame,35/255);


imshow(bw)

end



%{

Estudar Object Tracking

%}