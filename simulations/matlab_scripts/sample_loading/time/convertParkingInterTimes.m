function [ arrivals, leavings ] = convertParkingInterTimes( sample )
%LOADPARKINGINTERTIMES Summary of this function goes here
%   Detailed explanation goes here

    currentTimes = [0, 0];
    
    %time elapsed since [ arrival, leaving ] 
    currentValue = sample(1,1);
    canProcess = [0 0];
    arrivals = [];
    leavings = [];
    
    for idx = 2 : length(sample)
        if(sample(idx,1) > currentValue) %arrival
            if(canProcess(1))
                arrivals = [ arrivals; currentTimes(1) ];
            else
                canProcess(1) = 1;
            end
            
            currentTimes(1) = 0;
        else %leaving
            if(canProcess(2))
                leavings = [ leavings; currentTimes(2) ];
            else
                canProcess(2) = 1;
            end
            
            currentTimes(2) = 0;
        end

        currentTimes = currentTimes + sample(idx,2);
        currentValue = sample(idx,1);
    end
end

