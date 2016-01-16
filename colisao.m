clear;

% Create System objects used for reading video
obj = setupObjects('vids/car2.avi');

% Create an empty array of tracks.
tracks = struct(...
    'id', {}, ...
    'bbox', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {});

% Variable Initialization
frame = obj.reader.step();  
nextId = 1; 
i=1;
[height,width,~]=size(frame);
stepW=round(width*0.05);
stepH=round(height*0.05);
centralX=round(width/2);
centralY=round(height/2);
oldMeanX=-1;
oldArea=-1;
a=0;
oldAreas=[];
oldPositionX=[];
meanArea=-1;
meanX=-1;

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    %Read a new frame.
    frame = obj.reader.step();                                              
    [centroids, bboxes, mask] = detectObjects(obj,frame);
    tracks = predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,centroids);

    tracks= updateAssignedTracks(assignments,centroids,bboxes,tracks);
    tracks = updateUnassignedTracks(unassignedTracks,tracks);
    tracks = deleteLostTracks(tracks);
    [nextId,tracks] = createNewTracks(...
        unassignedDetections,...
        centroids,...
        bboxes,...
        nextId,...
        tracks);

    bboxes = displayTrackingResults(frame,mask,tracks,obj,centroids);
    
    %Collision Detection
    
    if ~isempty(centroids) && ~isempty(bboxes)
        
        n=numel(centroids); 
        % If more than one object, the displayed results are for the oldest
        % one. Meaning, the one that has been detected earlier.
        if n>2
            centroids2([1 2])=centroids([end-1 end]);
            centroids=centroids2;
        end
        if numel(bboxes)>4
            bboxes2([1 2 3 4])=bboxes([end-3 end-2 end-1 end]);
            bboxes=bboxes2;
        end
        y = round(centroids(2));
        x = round(centroids(1));

        a=sizebb(bboxes);
        oldAreas(i)=a;
        oldPositionX(i)=x;
        if i==4
            meanArea = mean2(oldAreas);
            if oldArea~=-1 && onBorder(bboxes,width,height)==0
                if meanArea>oldArea+stepW
                        if meanArea>width*height*0.8
                            if x>centralX-stepW && x<centralX+stepW && y>centralY-stepH && y<centralY+stepH 
                                disp('Collision Detected!')
                            end
                        else
                            if onBorder(bboxes,width,height)==0
                                disp('Object Approaching')
                            end
                        end
                   
                else if meanArea<oldArea-stepW  
                    disp('Object Receding')

                    end
                end
            end
            meanX = mean2(oldPositionX);
            if oldMeanX~=-1&& onBorder(bboxes,width,height)==0
                
                if meanX>oldMeanX+(stepW/5) 
                    disp('Movement to the right')
                end
                if meanX<oldMeanX-(stepW/5)
                    disp('Movement to the left')
                end
            end
            i=1;
        else     
            i=i+1;
        end
        oldMeanX=meanX;
        oldy=y;
        oldArea=meanArea;
    end
    
end