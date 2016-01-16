function [bboxes] = displayTrackingResults(frame,mask,tracks,obj,centroids)
    % Convert the frame and the mask to uint8 RGB.
    frame = im2uint8(frame);
    mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
    bboxes=[];
    minVisibleCount = 8;
    
    if ~isempty(tracks)
        % Noisy detections tend to result in short-lived tracks.
        % Only display tracks that have been visible for more than a
        % minimum number of frames.
        reliableTrackInds= [tracks(:).totalVisibleCount] > minVisibleCount;
        reliableTracks = tracks(reliableTrackInds);

        % Display the objects. If an object has not been detected in this
        % frame, display its predicted bounding box.
        if ~isempty(reliableTracks)
            % Get bounding boxes.
            bboxes = cat(1, reliableTracks.bbox);

            % Get ids.
            ids = int32([reliableTracks(:).id]);

            % Create labels for objects indicating the ones for which we 
            % display the predicted rather than the actual location.
            labels = cellstr(int2str(ids'));
            predictedTrackInds = ...
                [reliableTracks(:).consecutiveInvisibleCount] > 0;
            isPredicted = cell(size(labels));
            isPredicted(predictedTrackInds) = {' predicted'};
            labels = strcat(labels, isPredicted);

            % Draw the objects on the frame.
            frame = insertObjectAnnotation(...
                frame,...
                'rectangle',...
                bboxes,...
                labels);

            % Draw the objects on the mask.
            mask = insertObjectAnnotation(...
                mask,...
                'rectangle',...
                bboxes,...
                labels);
        end
    end
    
    % Draw Centroid receives an image, coordinates of the centroids, 
    % centroids’ size and red, green, blue components.
    try
        mask2=drawCentroid(mask,centroids,7,0,0,255);
        frame2=drawCentroid(frame,centroids,7,0,0,255);
        % Display the mask and the frame.
        obj.maskPlayer.step(mask2);
        obj.videoPlayer.step(frame2);
    catch
        % Display the mask and the frame.
        obj.maskPlayer.step(mask);
        obj.videoPlayer.step(frame);
    end
    
    
    
    
   
end