close all; clear all; 
%% Exercise 1
%1.1

x1 = imread('res/building','jpeg');
x2 = imread('res/solarsystem', 'jpeg');
%Converts it to a grey-scale so that we can use the 
%edge function
xb1=rgb2gray(x1);
xb2=rgb2gray(x2);
%First order (could be sobel or prewitt, I test both)
x1s = edge(xb1, 'sobel');
x2s = edge(xb2, 'prewitt');
%Second order
x1p = edge(xb1, 'canny');
x2p = edge(xb2, 'canny');
warning('off','all')
%Displays both results side by side
figure; imshowpair(x1s, x1p,'montage');
title('1st Order                                                  2nd Order');

figure; imshowpair(x2s, x2p,'montage');
title('1st Order                                                  2nd Order');

%1.2

x1n = imnoise(xb1, 'salt & pepper',0.15);
x2n = imnoise(xb2, 'salt & pepper',0.15);

x1ns = edge(x1n , 'sobel');
x2ns = edge(x2n, 'prewitt');
x1nc = edge(x1n, 'canny');
x2nc = edge(x2n, 'canny');

figure; imshowpair(x1ns, x1nc,'montage');
title('1st Order (noise)                                                  2nd Order (noise)');

figure; imshowpair(x2ns, x2nc,'montage');
title('1st Order (noise)                                                2nd Order (noise)');

% @see https://nl.mathworks.com/help/images/noise-removal.html
m1 = 5; n1 = 5;
med2 = medfilt2(x1n,[m1 n1]);
figure; imshow(med2);
%Gets the edges again
x2nsf = edge(med2, 'prewitt');
x2ncf = edge(med2, 'canny');

figure; imshowpair(x2nsf, x2ncf,'montage');
title('1st Order (noise) filter                                                2nd Order (noise) filter');

%% Exercise 2
% Each image is converted from cartesian to polar coodinate system
% Since polar we need to find the center of the image
[r1 c1] = size(x1);
[r2 c2] = size(x2);
x1_row = floor(r1/2);
x1_col = floor(c1/2);

x2_row = floor(r2/2);
x2_col = floor(c2/2);

[X1,Y1] = meshgrid((1:r1)-x1_row, (1:c1)-x1_col);
[X2,Y2] = meshgrid((1:r2)-x2_row, (1:c2)-x2_col);

[theta1,rho1] = cart2pol(X1, Y1);
[theta2,rho2] = cart2pol(X2, Y2);

Z1 = zeros(size(theta1));
Z2 = zeros(size(theta2));

imwarp1 = warp(theta1, rho1, Z1, x1);
imwarp2 = warp(theta2, rho2, Z2, x2);

% https://nl.mathworks.com/help/images/ref/images.geotrans.warper.warp.html
figure; warp(theta1, rho1, Z1, x1);
figure; warp(theta2, rho2, Z2, x2);


%% Exercice 2.3
%Load an image
img_eliott = imread('res/KIRUA','jpg');
imshow(img_eliott)
x_img = rgb2gray(img_eliott);
%First warping
A = [2 2 0; -1 2 0; 0 0 1];
transform = maketform('affine', A);
im_warped = imtransform(img_eliott, transform);
imshow(im_warped)

%Second image warping
out_img=zeros(size(x_img));
%Compute the two midpoints(x, y) of the img
cx=floor((size(x_img,1))/2)
cy=floor((size(x_img,2))/2)
%A matrices
final_x=zeros([size(img_eliott,1) size(img_eliott,2)]); 
final_y=zeros([size(img_eliott,1) size(img_eliott,2)]); 
%Swirl constant
sw_const=10; 
for i=1:size(x_img,1) 
    %Compute the new value of x
    x=i-cx-sw_const; 
    for j=1:size(x_img,2) %Cartesian to Polar co-ordinates 
        %Same as we did earlier
        [theta,rho]=cart2pol(x,j-cy+sw_const);
        phi=theta+(rho/sw_const);
    %Now I reconvert from polar to cartesian to get our final image
    [pol_x,pol_y]=pol2cart(phi,rho);
    %Re compute the x and y value in the cartesian form
    final_x(i,j)=ceil(pol_x)+cx; 
    final_y(i,j)=ceil(pol_y)+cy;
    end
end
% This part here ensure that we get values between 1 and img size
% Make sure that the value is not less that 1
final_x=max(final_x,1);
% And that it is not bigger than img size
final_x=min(final_x,size(x_img,1));
final_y=max(final_y,1); 
final_y=min(final_y,size(x_img,2));
size(final_x);
size(final_y);
%Put all the values to the output image
for i=1:size(x_img,1)
    for j=1:size(x_img,2)
        out_img(i,j,:)=img_eliott(final_x(i,j),final_y(i,j));
    end
end
figure; imagesc(out_img);