function [ bollean ] = onBorder( bbox ,width, height)
% 0 is not on border
% 1 is on border
if bbox(1)>0 && bbox(2)>0 && bbox(1)+bbox(3)<width && bbox(2)+bbox(4)<height
    bollean = 0;
else
    bollean = 1;
end

end

