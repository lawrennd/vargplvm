function [gVarmeans gVarcovs gDynKern] = modelPriorReparamGrads(dynModel, gVarmeansLik, gVarcovsLik)


fhandle = str2func([dynModel.type 'PriorReparamGrads']);
[gVarmeans gVarcovs gDynKern] = fhandle(dynModel, gVarmeansLik, gVarcovsLik);