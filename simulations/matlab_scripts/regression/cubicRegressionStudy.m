function [ mdl ] = cubicRegressionStudy(evaluationPoints, responses, subjectName, rootFolderName)
	%Filtering null or negative values
	positiveEvaluationPoints = evaluationPoints(responses > 0);
    positiveResponses = responses(responses > 0);

    % Transform and linear regression
    transformedPoints = positiveEvaluationPoints.^3;
	foldername = fullfile(rootFolderName, 'cubicRegression', subjectName);
	mdl = linearRegressionStudy(transformedPoints, positiveResponses, subjectName, foldername);
	
	% Anti-transform
	beta = mdl.Coefficients.Estimate;
    syms x;
	cubicRegression = beta(1) + beta(2)*(x^3);
    
	regrPlotName = 'Cubic regression';
	regrPlot = figure('Name', regrPlotName);
	hold on
	title(regrPlotName);
	plot(positiveEvaluationPoints, positiveResponses, 'Marker', 'x', 'LineStyle', 'none');
	target_ylim = ylim;
	target_xlim = xlim;
	fplot(cubicRegression);
	ylim(target_ylim);
	xlim(target_xlim);

	% Fitting annotation
	formula = char(cubicRegression);
	r2 = mdl.Rsquared.Ordinary;
	dim = [.2 .5 .3 .3];
	str = { formula , ['R^2: ' num2str(r2)] };
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