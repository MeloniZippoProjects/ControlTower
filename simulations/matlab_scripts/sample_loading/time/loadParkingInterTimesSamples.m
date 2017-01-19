function [ arrivals, leavings ] = loadParkingInterTimesSamples( samples )
%LOADPARKINGINTERTIMESSAMPLE Summary of this function goes here
%   Detailed explanation goes here

    arrivals = struct();
    leavings = struct();
    
    for idx = 1 : samples.size
       [arr_tmp, leave_tmp] = convertParkingInterTimes( samples.(['v' string(idx).char]) );
       
       arrivals.(['v' string(idx).char ]) = arr_tmp;
       leavings.(['v' string(idx).char ]) = leave_tmp;
       
    end

    arrivals.size = samples.size;
    leavings.size = samples.size;
    
end

