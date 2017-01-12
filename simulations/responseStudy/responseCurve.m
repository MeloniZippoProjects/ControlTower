function [ lrz_fig ] = responseCurve( rho )
%RESPONSECURVE Summary of this function goes here
%   Detailed explanation goes here
    
    configs = [ string('l5t5p30'); string('l5t5p60'); string('l5t15p30');
        string('l5t15p60');  string('l15t5p30'); string('l15t5p60');
        string('l15t15p30'); string('l15t15p60'); ];
    
    
    rng(7817, 'twister');
    
    
    
    for idx = 1 : length(configs)
        plotCurve(configs(idx,:).char);
    end

end

