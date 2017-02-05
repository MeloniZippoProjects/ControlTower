% Loads the data obtained via simulation and parsed via gawk scripts.
% The data is processed via convertLengthSample to a format easier to work with, that consists in a row for each state change.
% For each row, the first column is the lenght value and the second column is the duration this status has been kept.
% Instantaneous changes, that is states that lasted 0 seconds, are filtered out.
% 
% This script also uses a cache mechanism to speed up file loading times. 
% The .m files generated via gawk, being textual, require some parsing time that slows down the loading.
% To avoid this, once the content is loaded in the workspace the script saves it in binary .mat file which is much faster to load.
% The script then checks if this binary files is present before trying to load the textual file, skipping both parsing and converting phases.
% 
% Like every cache it must be invalidated everytime a .m file is changed by re-executing the simulations.
% This operation must be done manually, deleting the files contained in the cache subfolder.    

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