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

restored = imread('/MATLAB Drive/images/dtcwt_denoised.png');
distorted = imread('/MATLAB Drive/images/noisy.png');
reference = imread('/MATLAB Drive/images/original.png');
restored2 = imread('/MATLAB Drive/images/dwt_denoised.png');


% Compute quality metrics
metrics1 = evaluateImageQuality(restored, reference);
metrics2 = evaluateImageQuality(restored2, reference);
metrics3 = evaluateImageQuality(distorted, reference);


% Display results
disp('pepper');
disp('Before denoising:');
disp(metrics3);
disp('After dtcwt:');
disp(metrics1);
disp('After dwt:');
disp(metrics2);


