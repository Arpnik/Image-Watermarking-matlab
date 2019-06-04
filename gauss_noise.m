function lena_gauss = gauss_noise(input_img)
noise_density=input('Enter the noise density of gaussian noise(0 to 1): ');
lena_gauss = imnoise(input_img,'gaussian',noise_density);