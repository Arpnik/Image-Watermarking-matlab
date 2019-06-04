function lena_ref = flip_image(input_img)
in=input('Enter the direction in which you want to flip (1 for up-down and 2 for left-right):');
if(in==1)
    lena_ref = flipud(input_img);
else
    lena_ref=fliplr(input_img);
end