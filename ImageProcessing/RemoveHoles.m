clear; clc;

original = imread("demo.jpg");
im = im2gray(original);
im = imbinarize(im, 'global');
im = ~im;

high = 500; 
low = 100; 

% Isolate target spots
small_objects_mask = bwpropfilt(im, 'Area', [low, high - 1]);

% --- BLURRING KERNEL INPAINTING BLOCK ---
bg_mask = ~small_objects_mask;
kernel_size = 50; % Adjust based on the width of your largest spot
h_filter = fspecial('gaussian', [kernel_size, kernel_size], kernel_size/6);

original_d = double(original);
isolated_bg = original_d .* double(bg_mask);

blurred_bg = imfilter(isolated_bg, h_filter, 'replicate');
blurred_mask = imfilter(double(bg_mask), h_filter, 'replicate');

filled_background = blurred_bg ./ max(blurred_mask, 1e-5);
output = original_d;
for c = 1:3
    % 1. Extract the current 2D channel data from the output image
    channel_data = output(:, :, c);
    
    % 2. Extract the corresponding 2D channel data from the blurred background
    blur_channel = filled_background(:, :, c); 
    
    % 3. Safely map 2D mask elements to 2D array elements (No dimension mismatches!)
    channel_data(small_objects_mask) = blur_channel(small_objects_mask);
    
    % 4. Assign the modified slice back to the output image
    output(:, :, c) = channel_data;
end
output = uint8(output);

% -----------------------------------------

imshow(output);