clear

v = VideoReader('vids/car.avi');

while hasFrame(v)
frame = readFrame(v);

%com gray
%frame = rgb2gray(frame);

%avgInten=mean2(frame);

%bw=im2bw(frame,avgInten/255);
%bw=im2bw(frame,35/255);


imshow(frame)

end



%{

Estudar Object Tracking
Cam Shift
CAMSHIFT algorithm
Motion Analysis

Ver:
http://www.mathworks.com/help/vision/examples/motion-based-multiple-object-tracking.html
http://www.mathworks.com/products/computer-vision/
Ver Slides object tracking na BB...

Ajuda MatLab:
helpview(fullfile(docroot,'toolbox','matlab','matlab_prog','matlab_prog.map'),'nested_functions')

%}
