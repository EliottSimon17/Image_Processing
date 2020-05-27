close all; clear all; warning('off','all')

% Question 3
x = imread('res/harrypotter','jpg');
xbw = rgb2gray(x); 
xv = xbw;
[r c] = size(xbw);
%Create a kernel 
kern=fspecial('gaussian',[r c], 2);
size(kern)
blurred_img = imfilter(xbw, kern);
%Now let's add some noise which is gaussian distributed
noise = imnoise(blurred_img, 'gaussian');
figure; 
subplot(1,2,2);imshow(noise); title('Noise & Blurr');
subplot(1,2,1);imshow(xbw); title('Original Image');

%Calculate the fourier transform of our kernel function h 
fq_transform = fft2(kern);
figure; imagesc(fftshift(real(fq_transform)));

%2D fft 
powerSpec = log(abs(fftshift(fft2(blurred_img))).^2 );
ft1D = fft(noise);
figure;
subplot(2,2,1); plot(powerSpec); title('Spectrum plot');
subplot(2,2,2); imagesc(powerSpec); title('2D spectrum');
subplot(2,2,3); mesh(powerSpec); title('3D spectrum');
subplot(2,2,4); imshow(log(fftshift(ft1D)), []); title('1D spectrum');

%G  = F + FNOISEBLURR
fnoise = (abs(fftshift(fft2(noise))).^2)./(abs(fftshift(fft2(xbw))).^2);

%Apply the filter on the image F = 1/1+FNOISE
filter = 1./(1+fnoise);
% G = F + FNOISE
g = fftshift(fft2(xbw)) + fftshift(fft2(noise));

%d
exp_vl = 10^(-2);

%expected value
expv = exp_vl / var(im2double(xbw(:)));

wienersolver = deconvwnr(noise, kern ,expv);
figure; 
subplot(1,2,1); imshow(noise); title('noisy img');
subplot(1,2,2); imshow(wienersolver); title('filtered img');

%-------------------------------------
powerSpec = log10(abs(fftshift(fft2(wienersolver))).^2);

figure;
subplot(1,2,1); imshow(fftshift(abs(ifft2(abs(fft2(wienersolver)))))/255); title('Magnitude After Filter');
subplot(1,2,2); mesh(powerSpec);title('Spectrum 3D');

%% Bonus
[j,p] = deconvblind(noise,kern);
figure; 
subplot(1,2,1); imshow(noise); title('noisy img');
subplot(1,2,2); imshow(j); title('filtered img(dcv)');

powerSpec = log10(abs(fftshift(fft2(j))).^2);

figure;
subplot(1,2,1); imshow(fftshift(abs(ifft2(abs(fft2(j)))))/255); title('Magnitude After Filter');
subplot(1,2,2); mesh(powerSpec);title('Spectrum 3D');

