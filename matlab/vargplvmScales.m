function ret = vargplvmScales(method, model, varargin)




if strcmp(method, 'get')
    if strcmp(model.kern.type, 'rbfardjit')
        scales = model.kern.inputScales;
    else
        scales = model.kern.comp{1}.inputScales;
    end
    
    ret = scales;
elseif strcmp(method, 'set')
    if nargin < 2
        error('Function requires at least 3 arguments with the set method')
    end
    scales = varargin{1};
    if length(scales) == 1
        scales = repmat(median(scales{1}), 1, model.q);
    end
    
    if strcmp(model.kern.type, 'rbfardjit')
        model.kern.inputScales = scales;
    else
        model.kern.comp{1}.inputScales = scales;
    end
    
    ret = model;
end