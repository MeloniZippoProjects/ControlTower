function [ instants_samples ] = loadInstantsSamples( vector, scenario )
%LOADTakeoffINTERTIMESSAMPLE Summary of this function goes here
%   Detailed explanation goes here

	cd( [ string(scenario).char, '/results' ]);
        filename = [ vector '.mat'];
        if exist(fullfile(cd, filename), 'file')
            load(filename);
        else
            run(strcat(vector, '.m'));
            instants_samples = struct();
            for idx = 1 : vectors.size
                vector_name = strcat(vector, '_', string(idx-1).char);
                x = vectors.(vector_name);
                sample = convertInstantsSample(x);            
                instants_samples.(strcat('v', string(idx).char)) = sample;
            end
            instants_samples.size = vectors.size;
            save(filename, 'instants_samples');
        end
    cd ../..
end