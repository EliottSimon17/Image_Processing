% Exercise 2
close all; clear all; warning('off','all')

%% DATA 
%Loads the image
x = imread('res/olaf','jpg');
%Converts it to gray scale
xbw = rgb2gray(x);
xbwcopy = xbw;
%gets rows and cols of im
[r c] = size(xbw);

%% ADDING NOISE
% Add periodic noise using cos functions
%Amplitude, Period
w = 0.3; T = 40;
noiseVec = w*(cos(2*pi*((1:r)')/T))/2+ (1-w);
%Make a copy of the noised rows generated to all the columns
noise = repmat(noiseVec, [1,c]);
%Multiply our previous values with the new noise generated
xbwtp = xbw;
xbw = noise .* double(xbw);
%shows the noisy image
%calculate its 2D FFT and shift zero freq towards the center
fft2init = fft2(double(xbw));
fourier_transform = fftshift(fft2(double(xbw)));

figure;
subplot(1,2,1); imshow(xbwcopy); title('original image');
subplot(1,2,2); imshow(xbw/255); title('noisy image');

%-----------------------------------------------
%Shows log magnitude in 2D and 3D and 1D 
%1D FT
ft1D = fft(xbw);

powerSpec = log10(abs(fftshift(fft2(xbw))).^2 );
figure; 
subplot(2,3,1); imshow(xbw, [0 255]); title('noised image')
subplot(2,3,2); imshow(fftshift(abs(ifft2(abs(fft2init))))/255); title('magnitude');
subplot(2,3,4); imshow(log(fftshift(fft2init)), []);title('Spectrum 2D');
subplot(2,3,5); mesh(powerSpec);title('Spectrum 3D');
subplot(2,3,3); imshow(log(fftshift(ft1D)), []);title('Spectrum 1D');

%------------------------------------------------
%% Filtering (notch filter)
%Center points
xc=(r+(length(xbw)/2))/2;yc=(c-(length(xbw)/2))/2;
%radius for the filter
% Equivalent to ROI
r= 285;r1 = 10;
%we will iterate for some t-values
t = 0:pi/100:2*pi;
xp = r*cos(t)+xc;xp1 = r1*cos(t)+xc;
yp =  r*sin(t)+yc;yp1 =  r1*sin(t)+yc;

%This part sets all the pixels inside the filter to 1 and the other to 0
filter = poly2mask(double(xp),double(yp), r,c);
filter_mask = poly2mask(double(xp1),double(yp1), r,c);
filter(filter_mask)=0;
%Get in the frequency domain to set the values that have been filtered to 0
new_ft=fourier_transform;new_ft(filter)=1;
new_inverse_ft = ifft2(ifftshift(new_ft));
figure; 
subplot(1,2,1); imshow(xbw/255) ;title('image with noise');
subplot(1,2,2); imshow(real(new_inverse_ft),[]);title('image after band pass filtering');

%% This was for verification
filter2 = Bnotchfilter(40, r, c, 2, 30);
noisybi = pnoise(30 , r, c);
%newNoise = double(xbwtp).*double(noisybi);
%size(noisybi)
%fourier_transform = fftshift(fft2(double(noisybi'*double(xbwtp))));


%%filtered_im = fourier_transform.*filter2;
%inversed_image = ifft2(filtered_im);

%Show spectrum of resulting image
%Shows log magnitude in 2D and 3D
%fft2_new_image = fft2(inversed_image);
powerSpec = log10(abs(fftshift(fft2(real(new_inverse_ft)))).^2 );

figure;
subplot(2,2,1); imshow(fftshift(abs(ifft2(abs(fft2init))))/255); title('magnitude');
subplot(2,2,2); imshow(fftshift(abs(ifft2(abs(fft2(real(new_inverse_ft))))))/255); title('Magnitude After Filter');
subplot(2,2,3); mesh(powerSpec);title('Spectrum 3D');


