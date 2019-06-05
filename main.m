clc;
clear;
%loading both main and watermark image
main_img=loadimage('content');
watermark_img=loadimage('watermarking');
[r1,c1]=size(main_img);
[r2,c2] = size(watermark_img);
strl=["original image","with Hidden Image"];
str = ["salt and pepper noise","gaussian noise","histogram equalisation","rotation","Reflection","croped","Scaled","translated","Median filter"];

% size of watermarking image should be less than or equal to the main image
if(r1*c1<r2*c2)
    fprintf('watermrk image is larger in size than main image\n');
    return;
end

%converting watermark into a binary image i.e. with level 0 (black) and 1(white)
level=input('Enter the threshold level for converting watermark image from grayscale to binary (0-1): ')
wmark_img = im2bw(watermark_img,level);

%making a matrix to store all the main content images
main_imgs=zeros(r1,c1,11,class(main_img));
main_imgs(:,:,1)=main_img;

bit=input('Enter the bit plane number to which you want to embeedd the watermarking image (usually between 1 to 8): ')
bit_img=bitget(main_img,bit);
x=1;
y=1;

%hidding image
for i = 1:r2
    for j= 1: c2
        if (y>c1)
            x=x+1;
            y=1;
        end 
        if((bit_img(x,y)==0&&wmark_img(i,j)==1)||(bit_img(x,y)==1&&wmark_img(i,j)==0))
            if(wmark_img(i,j)==1)
                main_img(x,y)=main_img(x,y)+pow2(bit-1);
            else
                main_img(x,y)=main_img(x,y)-pow2(bit-1);
            end
        end
        y=y+1;
    end
end

main_imgs(:,:,2)=main_img;
%checking strength of the watermark
main_imgs(:,:,3) = salt_noise(main_imgs(:,:,2));
main_imgs(:,:,4) = gauss_noise(main_imgs(:,:,2));
main_imgs(:,:,5) =hist_eq(main_imgs(:,:,2));
main_imgs(:,:,11) = lena_median(main_imgs(:,:,2));
main_imgs(:,:,7) = flip_image(main_imgs(:,:,2));
main_imgs(:,:,6) = imresize(imrotate(main_imgs(:,:,2),45),[r1 c1]);
main_imgs(:,:,8) = imresize(imcrop(main_imgs(:,:,2),[75 68 130 112]),[r1 c1]);
main_imgs(:,:,9) = imresize(imresize(main_imgs(:,:,2),0.5),[r1 c1]);
main_imgs(:,:,10) = imtranslate(main_imgs(:,:,2), [15,25]);

sgtitle('Main Content Images');
% showing all the various main images with hidden images and testing their
% resistance to various attacks and functions
for i=1:11
    subplot(3,4,i);
    imshow(main_imgs(:,:,i));
    if i<=2
        title(strl(i));
    else
        title(str(i-2));
    end
end

%matrix for storing all the hidden images
h=zeros(r2,c2,11,class(watermark_img));
h(:,:,1)=watermark_img;
h(:,:,11)=im2uint8(wmark_img);
%extracting watermark image
for i=2:10
    h(:,:,i)=find1(main_imgs(:,:,1+i),r2,c2,c1,bit);
end

%showing all the hidden images
figure;
sgtitle('Hidden Images');
for i=1:11
    subplot(3,4,i);
    imshow(h(:,:,i));
    if i==11
        title('Binary hiddden image')
        continue;
    end
    if i>=2
        title(str(i-1));
    else
        title('Original image');
    end     
end

%comparing the robustness of watermarking scheme
peaksnr=zeros;
snr=zeros;
for i=1:9
    [peaksnr(i), snr(i)] = psnr(h(:,:,i+1), h(:,:,11));
end

save final.mat h main_imgs peaksnr snr str;

%========================================================================================================
%now we try to retrive the stored data from the mat file
%accessing the data stored in matfile%
data=load('final.mat');
figure;
saved_hidden=data.h;
sgtitle('saved ones');
for i=1:11
    subplot(3,4,i);
    imshow(saved_hidden(:,:,i));
end

