function vargplvmShowScales(model, printPlots)


if nargin < 2
    printPlots = true;
end

if printPlots
        if strcmp(model.kern.type, 'rbfardjit')
            bar(model.kern.inputScales)
        else
            bar(model.kern.comp{1}.inputScales)
        end
else
        if strcmp(model.kern.type, 'rbfardjit')
            fprintf('# Scales of model %d: ', i)
            fprintf('%.4f  ',model.kern.inputScales);
            fprintf('\n');
        else
            fprintf('# Scales of model %d: ', i)
            fprintf('%.4f  ',model.kern.comp{1}.inputScales);
            fprintf('\n');
        end
end
