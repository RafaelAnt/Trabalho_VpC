function [ out ] = drawCentroid( image,centroid, step, red, green, blue )

[height,width,~]=size(image);
out=image;

% se tiver elementos
if ~isempty(centroid) 
    n=numel(centroid); 
    while n>1
       
        y = round(centroid(n));
        n = n-1;
        x = round(centroid(n));
        n = n-1;
       
        if y<step+3 || x<step+3 || x>width-step-3 || y>height-step-3
            return
        end
      
        %Desenha barra vertical
        i= x-step;
        while i<x+step
            out(y,i,1)=red;
            out(y,i,2)=green;
            out(y,i,3)=blue;
            i=i+1;
        end
        
        %Desenha barra horizontal
        i = y-step;
        while i< y+step
            out(i,x,1)=red;
            out(i,x,2)=green;
            out(i,x,3)=blue;
            i=i+1;
        end
    end
end
end

