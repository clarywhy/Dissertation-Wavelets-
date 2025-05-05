% List of restored image file paths
imageFiles = {
    '/MATLAB Drive/Mirage f1_50/00000001.png'
    '/MATLAB Drive/monument_f1_100/00000001.png'
};

imageNames = {'Car', 'Monument'};

% Initialise arrays
niqe_vals = zeros(length(imageFiles),1);
brisque_vals = zeros(length(imageFiles),1);
piqe_vals = zeros(length(imageFiles),1);

% Compute scores
for i = 1:length(imageFiles)
    img = imread(imageFiles{i});
    if size(img,3) == 3
        img = rgb2gray(img);
    end

    niqe_vals(i) = niqe(img);
    brisque_vals(i) = brisque(img);
    piqe_vals(i) = piqe(img);
end

% Display results
fprintf('\nNo-Reference Quality Metrics:\n');
for i = 1:length(imageFiles)
    fprintf('%s:\n', imageNames{i});
    fprintf('  NIQE:    %.2f\n', niqe_vals(i));
    fprintf('  BRISQUE: %.2f\n', brisque_vals(i));
    fprintf('  PIQE:    %.2f\n\n', piqe_vals(i));
end