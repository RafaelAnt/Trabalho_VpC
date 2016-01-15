clear;

% Create System objects used for reading video
obj = setupObjects('vids/2_bolas.avi');

% Create an empty array of tracks.
tracks = struct(...
    'id', {}, ...
    'bbox', {}, ...
    'kalmanFilter', {}, ...
    'age', {}, ...
    'totalVisibleCount', {}, ...
    'consecutiveInvisibleCount', {});
    
nextId = 1; % ID of the next track
i=1;
frame = obj.reader.step();  
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
    frame = obj.reader.step();                                              %Read a new frame.
    [centroids, bboxes, mask] = detectObjects(obj,frame);
    tracks = predictNewLocationsOfTracks(tracks);
    [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment(tracks,centroids);

    tracks= updateAssignedTracks(assignments,centroids,bboxes,tracks);
    tracks = updateUnassignedTracks(unassignedTracks,tracks);
    tracks = deleteLostTracks(tracks);
    [nextId,tracks] = createNewTracks(unassignedDetections,centroids,bboxes,nextId,tracks);

    bboxes = displayTrackingResults(frame,mask,tracks,obj,centroids);
    
    %Detetar Colisões:
    
    if ~isempty(centroids) && ~isempty(bboxes)
        
        n=numel(centroids); 
        % Se detetar mais do que um objeto só dá informação para o primeiro
        if n>2 
            %disp('Mais de um Objeto Detetado');
            centroids2=centroids([3:4 1:2]);
            centroids=centroids2;
            
        end
        if numel(bboxes)>4
            bboxes2=bboxes([5:8 1:4]);
            bboxes=bboxes2;
        end
        y = round(centroids(n));
        n = n-1;
        x = round(centroids(n));
        n = n-1;
        
        a=sizebb(bboxes);
        oldAreas(i)=a;
        oldPositionX(i)=x;
        if i==4
            %oldAreas
            meanArea = mean2(oldAreas);
            if oldArea~=-1
                if meanArea>oldArea+stepW
                        if meanArea>width*height*0.8
                            if x>centralX-stepW && x<centralX+stepW && y>centralY-stepH && y<centralY+stepH 
                                disp('Colisão Detetada')
                                %beep
                            end
                        else
                            if onBorder(bboxes,width,height)==0
                                disp('Objeto em Aproximação')
                            end
                        end
                   
                else if meanArea<oldArea-stepW && onBorder(bboxes,width,height)==0 %VER MELHOR
                    disp('Objeto a Afastar-se')

                    end
                end
            end
            meanX = mean2(oldPositionX);
            if oldMeanX~=-1&& onBorder(bboxes,width,height)==0
                
                if meanX>oldMeanX+(stepW/5) 
                    disp('Traslação para a Direita')
                end
                if meanX<oldMeanX-(stepW/5)
                    disp('Traslação para a Esquerda')
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
