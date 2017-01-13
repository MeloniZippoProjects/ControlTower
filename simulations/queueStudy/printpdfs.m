cd poissonian


timeConfigs = [string('landingQueue_queueTime') 5; string('takeoffQueue_queueTime') 20; ];
%timeConfigs = [];
%lengthConfigs = [ string('landingQueue_queueLength'); string('takeoffQueue_queueLength')];
lengthConfigs = [];

for idx = 1 : length(lengthConfigs)
   config = lengthConfigs(idx).char;
    
   pdffig = lengthPDF(config);
   print(pdffig, config, '-dpng');
end

for idx = 1 : length(timeConfigs)
   config = timeConfigs(idx, 1).char;
   width = str2num( timeConfigs(idx, 2).char );
    
   pdffig = timePDF(config, width);
   print(pdffig, config, '-dpng');
end

cd ..