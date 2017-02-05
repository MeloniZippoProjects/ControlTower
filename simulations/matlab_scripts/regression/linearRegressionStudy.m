% Fits points [evaluationPoints(i), responses(i)] to a linear model
% and computes confidence bounds and regression coefficients.
% Draws graphs for a posteriori hypothesis checking 

function [ mdl ] = linearRegressionStudy(evaluationPoints, responses, subjectName, rootFolderName)
	mdl = fitlm(evaluationPoints, responses, 'RobustOpts', 'off');
	residuals = mdl.Residuals.Raw;

	% Plot of the regression with confidence bounds
	regrPlotName = 'Linear regression';
	regrPlot = figure('Name', regrPlotName);

	hold on

	plot(evaluationPoints, responses, 'LineStyle', 'none'); %Style?
	plot(mdl);
    title(regrPlotName);

	% Fitting annotation
	r2 = mdl.Rsquared.Ordinary;
	beta = mdl.Coefficients.Estimate;

	dim = [.2 .5 .3 .3];
	str = { ['y = ' num2str(beta(1), 4) ' + ' num2str(beta(2), 4) '*x' ],
			['R^2: ' num2str(r2)] };
	annotation('textbox',dim,'String',str,'FitBoxToText','on');

	hold off

	% QQ plot fitting residuals with normal

	quantiles = ( ( 1:length(residuals) ) - 0.5 ) / length(residuals);
	residualQuantiles = sort(residuals);
	stdNormalQuantiles = 4.91 * ( quantiles.^0.14 - (1 - quantiles).^0.14);

	qqPlotName = 'QQ plot of std normal vs residuals';
	qqPlot = figure('Name', qqPlotName);

	hold on
    title(qqPlotName);
	plot(stdNormalQuantiles, residualQuantiles, 'LineStyle', 'none');
    qqLinearRegression = fitlm(stdNormalQuantiles, residualQuantiles, 'RobustOpts', 'off');
    plot(qqLinearRegression);
    title('QQ Plot: Residuals vs Normal');
    grid on;
    ax = gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    hold off;

	% Residuals vs observation ID

	residualsVsIDPlotName = 'Residuals vs observation ID';
	residualsVsIDPlot = figure('Name', residualsVsIDPlotName);

	hold on
    title(residualsVsIDPlotName);
	IDs = 1:length(residuals);
	plot(IDs, residuals, 'LineStyle', 'none', 'Marker', '*');
	ax = gca;
	ax.XAxisLocation = 'origin';
	ax.YGrid = 'on';
	hold off

	% Residuals vs predicted response

	residualsVsResponsesPlotName = 'Residuals vs predicted response';
	residualsVsResponsesPlot = figure('Name', residualsVsResponsesPlotName);

	hold on
    title(residualsVsResponsesPlotName);
	plot(responses, residuals, 'LineStyle', 'none', 'Marker', '*');
	ax = gca;
	ax.XAxisLocation = 'origin';
	ax.YGrid = 'on';
	hold off

	% Saving figures	

	startcd = cd;
	foldername = fullfile(rootFolderName, 'linearRegression', subjectName);
    warning('off', 'all');
        mkdir(foldername);
    warning('on', 'all');
    cd(foldername)
        print(regrPlot, [ regrPlotName '.png' ] , '-dpng');
        savefig(regrPlot, [ regrPlotName '.fig']);
        print(qqPlot, [ qqPlotName '.png' ] , '-dpng');
        savefig(qqPlot, [ qqPlotName '.fig']);
        print(residualsVsIDPlot, [ residualsVsIDPlotName '.png' ] , '-dpng');
        savefig(residualsVsIDPlot, [ residualsVsIDPlotName '.fig']);
        print(residualsVsResponsesPlot, [ residualsVsResponsesPlotName '.png' ] , '-dpng');
        savefig(residualsVsResponsesPlot, [ residualsVsResponsesPlotName '.fig']);
    cd(startcd)
end