function model = vargplvmDynamicsUpdateStats(model)

fhandle = str2func([model.dynamics.type 'UpdateStats']);
model = fhandle(model);