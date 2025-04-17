% Read the grayscale image
I = imread('cameraman.tif');  % or any other grayscale image
I = im2double(I);             % convert to double for processing

% Perform 1-level 2D DWT using Haar (or any wavelet you prefer)
[LL, LH, HL, HH] = dwt2(I, 'db1');  % 'db1' = Haar wavelet

% Keep only the high-frequency detail subbands
horizontal_edges = LH;
vertical_edges   = HL;
diagonal_edges   = HH;

% Optionally display them
figure;
subplot(1,3,1); imshow(horizontal_edges, []); title('LH (Horizontal edges)');
subplot(1,3,2); imshow(vertical_edges, []);   title('HL (Vertical edges)');
subplot(1,3,3); imshow(diagonal_edges, []);   title('HH (Diagonal edges)');