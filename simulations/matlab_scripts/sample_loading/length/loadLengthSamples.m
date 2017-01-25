function [ samples ] = loadLengthSamples( vector, scenario )
    cd(strcat( string(scenario).char, '/results'))
        filename = fullfile(cd, 'cache', [ vector '.mat']);
        if exist( filename, 'file')
            load(filename);
        else
            run(strcat(vector, '.m'));
            samples = struct();
            for idx = 1 : vectors.size
                vector_name = strcat(vector, '_', string(idx-1).char);
                x = vectors.(vector_name);
                sample = convertLengthSample(x);            
                samples.(strcat('v', string(idx).char)) = sample;
            end
            samples.size = vectors.size;
            
            warning('off', 'all');
                mkdir('cache');
            warning('on', 'all');
            save(filename, 'samples');
        end
    cd ../..
end

