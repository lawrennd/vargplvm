function model = vargplvmAddDynamics(model, type, varargin)

% VARGPLVMADDDYNAMICS Add a dynamics kernel to the model.
%
%	Description:
%
%	VARGPLVMADDDYNAMICS(MODEL, TYPE, ...) adds a dynamics model to the
%	VARGPLVM.
%	 Arguments:
%	  MODEL - the model to add dynamics to.
%	  TYPE - the type of dynamics model to add in.
%	  ... - additional arguments to be passed on creation of the
%	   dynamics model.
%	
%	
%	
%
%	See also
%	MODELCREATE


%	Based on FGPLVMADDDYNAMICS

type = [type 'Dynamics'];
model.dynamics = modelCreate(type, model.q, model.q, model.X, varargin{:}); % e.g. vargpTimeDynamicsCreate
params = vargplvmExtractParam(model);
model.dynamics.nParams = length(modelExtractParam(model.dynamics));
model.nParams = model.nParams + model.dynamics.nParams;
model = vargplvmExpandParam(model, params);
