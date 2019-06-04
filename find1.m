function out_img = find1(in_image,r2,c2,c1,bit)
%exctracting hidden image from main image after various attacks and
%funcions are applied
out_img=zeros(r2,c2,class(in_image))
x=1
y=1
%extracting appropriate bitplane
image=bitget(in_image,bit)
for i = 1:r2
    for j= 1: c2
        if (y>c1)
            x=x+1;
            y=1;
        end
        if(image(x,y))
            out_img(i,j) = 255;
        end
        y=y+1;
    end
end
