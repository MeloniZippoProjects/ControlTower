function [ samples ] = extractLengthSamples( config, rho )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    cd(strcat('rho', string(rho).char, '/results'))
        run(strcat(config, '.m'));
        samples = struct();
        for idx = 1 : vectors.size
            vector_name = strcat(config, '_', string(idx-1).char);
            x = vectors.(vector_name);
            sample = convertLengthSample(x);            
            samples.(strcat('v', string(idx).char)) = sample;
        end
        samples.size = vectors.size;
    cd ../..
end

