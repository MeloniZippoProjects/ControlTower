function [ samples ] = loadTimeSamples( vector, scenario )
    cd( [ string(scenario).char, '/results' ]);
        filename = [ vector '.mat'];
        if exist(fullfile(cd, 'cache', filename), 'file')
            load(filename);
        else
            run(strcat(vector, '.m'));
            samples = struct();
            for idx = 1 : vectors.size
                vector_name = strcat(vector, '_', string(idx-1).char);
                x = vectors.(vector_name);
                sample = convertTimeSample(x);            
                samples.(strcat('v', string(idx).char)) = sample;
            end
            samples.size = vectors.size;
            save(fullfile('cache', filename), 'samples');
        end
    cd ../..
end

