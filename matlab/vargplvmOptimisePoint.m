function vardistx = vargplvmOptimisePoint(model, vardistx, y, indexPresent, display, iters);

% VARGPLVMOPTIMISEPOINT Optimise the postion of a latent point.
% FORMAT
% DESC optimises the location of a single point in latent space
% given an initialisation and an observed data point. Note that it
% ignores any dynamics present in the model.
% ARG model : the model for which the point will be optimised.
% ARG x : the initialisation of the point in the latent space.
% ARG y : the observed data point for which the latent point is to
% be optimised.
% ARG display : whether or not to display the iterations of the
% optimisation (default: true)
% ARG iters : maximum number of iterations for the optimisation
% (default 2000).
% RETURN x : the optimised location in the latent space.
%
% COPYRIGHT :  Michalis K. Titsias and Neil D. Lawrence, 2009
%
% SEEALSO : vargplvmCreate, vargplvmOptimiseSequence, vargplvmPointObjective, vargplvmPointGradient

% VARGPLVM

if nargin < 6
  iters = 2000;
  %if nargin < 5
    display = true;
  %end
end

options = optOptions;
if display
  options(1) = 1;
  options(9) = 1;
end
options(14) = iters;


if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('scg');
end

x = vardistExtractParam(vardistx);

if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  x = optim('vargplvmPointObjectiveGradient', x, options, model, y, indexPresent);
else
  % NETLAB style optimization.
  x = optim('vargplvmPointObjective', x,  options, ...
            'vargplvmPointGradient', model, y, indexPresent);
end

vardistx = vardistExpandParam(vardistx,x);
