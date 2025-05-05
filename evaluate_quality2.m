function metrics = evaluateImageQuality(restored, reference)
% EVALUATEIMAGEQUALITY Computes PSNR, SSIM, and RMSE between two images.
%
% Inputs:
%   - restored: restored image (grayscale or RGB, uint8 or double)
%   - reference: ground truth image (same size)
%
% Output:
%   - metrics: struct with PSNR, SSIM, RMSE

    % Convert to grayscale if RGB
    if size(restored, 3) == 3
        restored = rgb2gray(restored);
    end
    if size(reference, 3) == 3
        reference = rgb2gray(reference);
    end

    % Convert to double for RMSE
    restored = double(restored);
    reference = double(reference);

    % Check size match
    % Resize reference to match restored if needed
    if ~isequal(size(restored), size(reference))
        reference = imresize(reference, size(restored));
    end

    % PSNR and SSIM
    metrics.PSNR = psnr(uint8(restored), uint8(reference));
    metrics.SSIM = ssim(uint8(restored), uint8(reference));

    % RMSE
    diff = restored - reference;
    mse = mean(diff(:).^2);
    metrics.RMSE = sqrt(mse);

end

restored = imread('/MATLAB Drive/results/carback_corrected.png');
distorted = imread('/MATLAB Drive/frames6/ezgif-frame-001.png');
reference = imread('/MATLAB Drive/images/references/carback.png');

restored2 = imread('/MATLAB Drive/results/barcode_corrected.png');
distorted2 = imread('/MATLAB Drive/frames8/ezgif-frame-001.png');
reference2 = imread('/MATLAB Drive/images/references/barcode.png');

restored3 = imread('/MATLAB Drive/results/books_corrected.png');
distorted3 = imread('/MATLAB Drive/frames7/ezgif-frame-001.png');
reference3 = imread('/MATLAB Drive/images/references/book.png');


% Compute quality metrics
metrics1_dist = evaluateImageQuality(distorted, reference);
metrics1_rest = evaluateImageQuality(restored, reference);

metrics2_dist = evaluateImageQuality(distorted2, reference2);
metrics2_rest = evaluateImageQuality(restored2, reference2);

metrics3_dist = evaluateImageQuality(distorted3, reference3);
metrics3_rest = evaluateImageQuality(restored3, reference3);

% Display results
disp('Number Plate:');
disp('Before correction:');
disp(metrics1_dist);
disp('After correction:');
disp(metrics1_rest);

disp('Barcode:');
disp('Before correction:');
disp(metrics2_dist);
disp('After correction:');
disp(metrics2_rest);


disp('Book:');
disp('Before correction:');
disp(metrics3_dist);
disp('After correction:');
disp(metrics3_rest);

