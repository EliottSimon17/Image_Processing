close all; clear all; warning('off','all')
%% Data and Visualizations
signal = @(x, y) exp(-1i*(10*x+10*y));
%Visualize the signal
[X,Y] = meshgrid(-30:30);
%figure(1);meshc(X, Y, real(signal(X,Y)));title('Signal in 3d');

%% 1A.2

%Here we are discretizing the signal 
%Sampling the continuous time space into intervals
fx = 100; fy = 100;        

%Since f = 1/T
dt1 = 1/fx; dt2 = 1/fy; 
ceil = 1; % ceiling of interval

%We take some interval until we reach the ceiling
[t1, t2] = ndgrid(0:dt1:ceil-dt1, 0:dt2:ceil-dt2);

%Once we have our interval we can apply them to our signal
x = (exp(-1i*(10*t1 + 10*t2)));


%Shows the signal
figure(2); subplot(2,2,1); imshow(real(x)); title('2D signal');
%------------------------------------------------
%Results 
%Phase Spectrum
phase = imresize(angle(fftshift(fft2(x))),5);
subplot(2,2,2); imshow(phase); title('phase angle');

%Magnitude 
powerSpec = log10(abs(fftshift(fft2(x))).^2 );
subplot(2,2,3); imagesc(abs(fftshift(fft2(x)))); title('magnitude');

%% Ex 1.2
%Image with repeated patterns

x = imread('res/img_rep_pat','jpg');
%Calculates the 2D FFT of the image
fft2x = fft2(rgb2gray(x));
fftShift = fftshift(fft2x);
[r c] = size(fft2x);
figure(3); 

subplot(2,2,1); imshow(rgb2gray(x));title('real image');
subplot(2,2,2); imshow(fftshift(abs(ifft2(abs(fft2x))))/255);title('magnitude');
subplot(2,2,3); imshow(fftshift(abs(ifft2(angle(fft2x))))*255);title('phase angle');

%Highest freq 
shift = fftshift(fft2x);
shift(r/2,c/2)=0;
fft2fin = ifftshift(shift);
figure(4); imshow(fftshift(abs(ifft2(abs(fft2x))))/255);title('magnitude');
%subplot(2,2,3); imshow(fftshift(abs(ifft2(angle(fft2x))))*255);title('phase angle');
