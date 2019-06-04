function lena_salt = salt_noise(input_img)
noise_density=input('Enter the noise density of salt and pepper noise (0 to 1): ');
lena_salt = imnoise(input_img,'salt & pepper', noise_density);