clear;

% Create System objects used for reading video
obj = setupObjects();

% Create an empty array of tracks.
tracks = struct(...
    'id', {}, ...
    'bbox', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {});
    
nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    frame = obj.reader.step();                                              %Read a new frame.
    [centroids, bboxes, mask] = detectObjects(obj,frame);
    tracks = predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment(tracks,centroids);

    tracks= updateAssignedTracks(assignments,centroids,bboxes,tracks);
    tracks = updateUnassignedTracks(unassignedTracks,tracks);
    tracks = deleteLostTracks(tracks);
    [nextId,tracks] = createNewTracks(unassignedDetections,centroids,bboxes,nextId,tracks);

    displayTrackingResults(frame,mask,tracks,obj,centroids);
end

%{ 
Nosso Código, Não é usado
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
