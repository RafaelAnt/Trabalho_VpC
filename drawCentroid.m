function [ out ] = drawCentroid( image,centroid, step, red, green, blue )

% Esta função ainda tem bugs, mas funciona...

[width,height]=size(image);
out=image;
% se tiver elementos
if ~isempty(centroid) 
    n=numel(centroid); 
    while n>1
        y = round(centroid(n));
        n = n-1;
        x = round(centroid(n));
        n = n-1;
        
        if y<0 || x<0 || x>width-1 || y>height-1
            return
        end
        
        %Desenha barra vertical
        i= x-step;
        while i<x+step
            if i<width-1 && i>0
                out(y,i,1)=red;
                out(y,i,2)=green;
                out(y,i,3)=blue;
            end
            i=i+1;
        end
        
        %Desenha barra horizontal
        i = y-step;
        while i< y+step
            if i<height-1 && i>0
                out(i,x,1)=red;
                out(i,x,2)=green;
                out(i,x,3)=blue;
            end
            i=i+1;
        end
    end
end
end

