rhoes = [0.1; 0.15; 0.2; 0.25; 0.3; 0.35; 0.4; 0.45; 0.5; 0.55; 0.6; 0.65; 0.7; 0.75; 0.8; 0.85; 0.9];

load('quantileTimeMean.mat', quantileTimeMean);
load('quantileLengthMean.mat', quantileLengthMean);

foldername = fullfile('graphs', 'quantileFigures');
    
disp 'Regression for landingQueue_queueTime'
    cutIdx = 1;
    linearRegressionStudy(rhoes(cutIdx:size(rhoes, 1)), quantileTimeMean(cutIdx:size(rhoes, 1), 1), 'landingQueue_queueTime', foldername);
disp 'Regression for takeoffQueue_queueLength'
    cutIdx = 8;
    exponentialRegressionStudy(rhoes(cutIdx:size(rhoes, 1)), quantileLengthMean(cutIdx:size(rhoes, 1), 2), 'takeoffQueue_queueLength', foldername);