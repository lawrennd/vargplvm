function [X, varX, model] = vargplvmOptimisePoint(model, vardistx, y, display, iters);

% VARGPLVMOPTIMISEPOINT Optimise the postion of one or more latent points.
% FORMAT
% DESC optimises the location of a group of points in latent space
% given an initialisation and the corresponding observed data point. 
% ARG model : the model for which the point will be optimised.
% ARG vardistx : the initialisation of the points in the latent space.
% ARG y : the observed data points for which the latent points are to
% be optimised.
% ARG display : whether or not to display the iterations of the
% optimisation (default: true)
% ARG iters : maximum number of iterations for the optimisation
% (default 2000).
% RETURN x : the optimised means in the latent space.
% RETURN varx : the optimised variances in the latent space.
% RETURN model: the model which is augmented to also include the new test
% points and the quantities that change because of these, as there is
% coupling in the dynamics case.

%
% COPYRIGHT :  Michalis K. Titsias and Neil D. Lawrence, 2009-2011
%
% SEEALSO : vargplvmCreate, vargplvmOptimiseSequence, vargplvmPointObjective, vargplvmPointGradient

% VARGPLVM

if nargin < 5
  iters = 2000;
  %if nargin < 5
    display = true;
  %end
end

options = optOptions;
if display
  options(1) = 1;
  %options(9) = 1;
end
options(14) = iters;


if isfield(model, 'optimiser')
  optim = str2func(model.optimiser);
else
  optim = str2func('scg');
end


if isfield(model, 'dynamics') && ~isempty(model.dynamics)
   % augment the training and testing variational distributions
   vardist = vardistCreate(zeros(model.N+size(y,1), model.q), model.q, 'gaussian');
   vardist.means = [model.dynamics.vardist.means; vardistx.means];
   vardist.covars = [model.dynamics.vardist.covars; vardistx.covars]; 
   vardist.numData = size(vardist.means,1);
   vardist.nParams = 2*prod(size(vardist.means));
   x = modelExtractParam(vardist);
else
   x = vardistExtractParam(vardistx);
end


if strcmp(func2str(optim), 'optimiMinimize')
  % Carl Rasmussen's minimize function 
  x = optim('vargplvmPointObjectiveGradient', x, options, model, y);
else
  % NETLAB style optimization.
  x = optim('vargplvmPointObjective', x,  options, ...
            'vargplvmPointGradient', model, y);
end

if isfield(model, 'dynamics') && ~isempty(model.dynamics)
   % now separate the variational disribution into the training part and the
   % testing part and update the original training model (only with the new training 
   % variational distribution) and the test variational distribution
   % this is doing the expand 
   x = reshape(x, vardist.numData, model.dynamics.q*2);
   xtrain = x(1:model.N,:);
   xtest = x(model.N+1:end,:);
   model.dynamics.vardist = vardistExpandParam(model.dynamics.vardist, xtrain); 
   vardistx = vardistExpandParam(model.vardistx, xtest);
else
   vardistx = vardistExpandParam(vardistx,x);
end

X = vardistx.means;
varX = vardistx.covars;
