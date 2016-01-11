clear;
%{ Nosso Código, Não é usado...
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
%}

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    frame = obj.reader.step();                                              %Read a new frame.
    [centroids, bboxes, mask] = detectObjects(obj,frame);
    predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment(tracks,centroids);

    updateAssignedTracks(assignments);
    updateUnassignedTracks(unassignedTracks);
    deleteLostTracks(tracks);
    nextId = createNewTracks(unassignedDetections,centroids,bboxes,nextId,tracks);

    displayTrackingResults(frame,mask,tracks,obj);
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
