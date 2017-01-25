function [ mdl ] = exponentialRegressionStudy(evaluationPoints, responses, subjectName, rootFolderName)
	%Filtering null or negative values
	positiveEvaluationPoints = evaluationPoints(responses > 0);
    positiveResponses = responses(responses > 0);
    
    % Transform and linear regression
    transformedResponses = log(positiveResponses);
	foldername = fullfile(rootFolderName, 'exponentialRegression', subjectName);
	mdl = linearRegressionStudy(positiveEvaluationPoints, transformedResponses, subjectName, foldername);
	
	% Anti-transform
	beta = mdl.Coefficients.Estimate;
    syms x;
	exponentialRegression = exp(beta(1))*exp(beta(2)*x);
    
	regrPlotName = 'Exponential regression';
	regrPlot = figure('Name', regrPlotName);
	hold on
	title(regrPlotName);
	plot(positiveEvaluationPoints, positiveResponses, 'Marker', 'x', 'LineStyle', 'none');
	target_ylim = ylim;
	target_xlim = xlim;
	fplot(exponentialRegression);
	ylim(target_ylim);
	xlim(target_xlim);

	% Fitting annotation
	r2 = mdl.Rsquared.Ordinary;
	dim = [.2 .5 .3 .3];
	str = { ['y = ' num2str(exp(beta(1)), 4) '*e^{' num2str(beta(2), 4) '*x}' ] ,
			['R^2: ' num2str(r2)] };
	annotation('textbox',dim,'String',str,'FitBoxToText','on');

	hold off

	% Saving figure

	startcd = cd;
    warning('off', 'all');
        mkdir(foldername);
    warning('on', 'all');
    cd(foldername)
        print(regrPlot, [ regrPlotName '.png' ] , '-dpng');
        savefig(regrPlot, [ regrPlotName '.fig']);
    cd(startcd)
end