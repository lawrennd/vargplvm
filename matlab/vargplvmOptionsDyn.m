function optionsDyn = vargplvmOptionsDyn(optionsDyn)
% VARGPLVMOPTIONSDYN Fill in an options structure with default parameters
% FORMAT
% DESC takes an VARGPLVM options structure amends it with default values
% wherever the field is empty.
% ARG optionsDyn : the VARGPLVM structure to fill in with default values.
% 
%
% COPYRIGHT : Michalis K. Titsias, 2011
% COPYRIGHT : Neil D. Lawrence, 2011
% COPYRIGHT : Andreas C. Damianou, 2011
% 
% SEEALSO : vargplvmInitDynamics, vargplvmAddDynamics

% VARGPLVM


if isfield(optionsDyn, 'type') && ~isempty(optionsDyn.type)
    optionsDyn.type = 'vargpTime';
end


if strcmp(optionsDyn.type, 'vargpTime')
    optionsDyn.initX = 'ppca';
    
    % Create time vector for each dimension; if t is not given, assume an
    % equally spaced time vector.
    if  ~isfield(optionsDyn, 't') || isempty(optionsDyn.t)
        fprintf(1, '# Time vector unknown; creating random, equally spaced time vector\n');
        t = linspace(0, 2*pi, size(model.X, 1)+1)';
        t = t(1:end-1, 1);
        optionsDyn.t = t;
    else
        t=optionsDyn.t;
    end
    
    
    % A better way to initialize the  kernel hyperparameter,
    % especially lengthscale, should be to learn it by running few iterations of
    % GP regression marginal likelihood maximization given as data the PCA output
    % (the default value is jsut reasonable and it sets the inverse lenthscale to quite
    % small value so the GP dynamic prior is weaker (less smoothed) at
    % initializations
    if  ~isfield(optionsDyn, 'kern') || isempty(optionsDyn.kern)
       % kern = kernCreate(t, {'rbf','white'});
        kern = kernCreate(t, {'rbf','white', 'bias'});
        kern.comp{2}.variance = 1e-3; % 1e-1
        
        if  isfield(optionsDyn, 'inverseWidth')
            invWidth=optionsDyn.inverseWidth;
        else
            invWidth=5;
        end
        
        % The following is related to the expected number of zero-crossings.
        kern.comp{1}.inverseWidth = invWidth./(((max(t)-min(t))).^2);
        kern.comp{1}.variance = 1;
        
        optionsDyn.kern = kern;
    end
    
    
    if ~isfield(optionsDyn,'seq')
        optionsDyn.seq=[];
    end
end

