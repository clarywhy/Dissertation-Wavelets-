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
    if ~isequal(size(restored), size(reference))
        error('Images must be the same size for quality comparison.');
    end

    % PSNR and SSIM
    metrics.PSNR = psnr(uint8(restored), uint8(reference));
    metrics.SSIM = ssim(uint8(restored), uint8(reference));

    % RMSE
    diff = restored - reference;
    mse = mean(diff(:).^2);
    metrics.RMSE = sqrt(mse);

end

restored = imread('/MATLAB Drive/results/cameraman_corrected3.png');
distorted = imread('/MATLAB Drive/frames/frame000.png');
reference = imread('/MATLAB Drive/images/references/cameraman.tif');

restored2 = imread('/MATLAB Drive/results/lena_corrected2.png');
distorted2 = imread('/MATLAB Drive/frames2/frame000.png');
reference2 = imread('/MATLAB Drive/images/references/lena_gray_512.tif');

restored3 = imread('/MATLAB Drive/results/lake_corrected.png');
distorted3 = imread('/MATLAB Drive/frames3/frame000.png');
reference3 = imread('/MATLAB Drive/images/references/lake.png');

restored4 = imread('/MATLAB Drive/results/plane_corrected2.png');
distorted4 = imread('/MATLAB Drive/frames4/frame000.png');
reference4 = imread('/MATLAB Drive/images/references/jetplane.png');

restored5 = imread('/MATLAB Drive/results/mandril_corrected.png');
distorted5 = imread('/MATLAB Drive/frames5/frame000.png');
reference5 = imread('/MATLAB Drive/images/references/mandril_gray.png');

% Compute quality metrics
metrics1_dist = evaluateImageQuality(distorted, reference);
metrics1_rest = evaluateImageQuality(restored, reference);

metrics2_dist = evaluateImageQuality(distorted2, reference2);
metrics2_rest = evaluateImageQuality(restored2, reference2);

metrics3_dist = evaluateImageQuality(distorted3, reference3);
metrics3_rest = evaluateImageQuality(restored3, reference3);

metrics4_dist = evaluateImageQuality(distorted4, reference4);
metrics4_rest = evaluateImageQuality(restored4, reference4);

metrics5_dist = evaluateImageQuality(distorted5, reference5);
metrics5_rest = evaluateImageQuality(restored5, reference5);

% Display results
disp('Camera image:');
disp('Before correction:');
disp(metrics1_dist);
disp('After correction:');
disp(metrics1_rest);

disp('Lena image:');
disp('Before correction:');
disp(metrics2_dist);
disp('After correction:');
disp(metrics2_rest);

disp('Plane image:');
disp('Before correction:');
disp(metrics4_dist);
disp('After correction:');
disp(metrics4_rest);
