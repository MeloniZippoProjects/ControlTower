cd poissonian

configs = [string('landingQueue_queueTime') 5; string('landingQueue_queueLength') 1; string('takeoffQueue_queueTime') 20; string('takeoffQueue_queueLength') 1];
%configs = [ string('landingQueue_queueTime') 5; string('takeoffQueue_queueTime') 20];
for idx = 1 : length(configs)
   config = configs(idx, 1).char;
   width = str2num( configs(idx, 2).char );
    
   pdffig = pdffunction(config, width);
   print(pdffig, config, '-dpng');
end