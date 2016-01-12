function [ out ] = drawCentroid( image,centroid, step, red, green, blue )
    [x,y]=size(image);
    out=image;
    if ~isempty(centroid)
        n=numel(centroid)/2;
        while n>0
            a = round(centroid(n*2-1));
            b = round(centroid(n*2));
            if a<x && b<y
                i= a-step;
                j= b-step;
                while i<a+step
                    if i<x && i>0
                        out(i,b,1)=red;
                        out(i,b,2)=green;
                        out(i,b,3)=blue;
                    end
                    i=i+1;
                end

                 while j<b+step
                     if j<y && j>0
                        out(a,j,1)=red;
                        out(a,j,2)=green;
                        out(a,j,3)=blue;
                     end
                     j=j+1;
                 end
            end
            n=n-1;
        end
    end

end

