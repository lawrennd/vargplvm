function scales = vargplvmShowScales(model, printPlots)


if nargin < 2
    printPlots = true;
end

if printPlots
        if strcmp(model.kern.type, 'rbfardjit')
            scales = model.kern.inputScales;
        else
            scales = model.kern.comp{1}.inputScales;
        end
        bar(scales)
else
        if strcmp(model.kern.type, 'rbfardjit')
            scales = model.kern.inputScales;
        else
            scales = model.kern.comp{1}.inputScales;
        end
        fprintf('# Scales: ')
        fprintf('%.4f  ',scales);
        fprintf('\n');
end
