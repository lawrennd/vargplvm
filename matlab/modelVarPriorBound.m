function ll = modelVarPriorBound(model)


fhandle = str2func([model.dynamics.type 'VarPriorBound']);
ll = fhandle(model.dynamics);