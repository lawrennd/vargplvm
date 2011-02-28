function model = vargpTimeDynamicsUpdateStats(model)

model.dynamics.X = model.vardist.means;
model.dynamics.Kt = kernCompute(model.dynamics.kern, model.dynamics.t);

%%%%DEBUG__
         %gDynKernUpStats=[model.dynamics.kern.comp{1}.variance model.dynamics.kern.comp{1}.inverseWidth model.dynamics.kern.comp{2}.variance];
         %gDynKernUpStats
        % fprintf(1,'\nMaxgVarmeansUpStats=%d\n',max(max(model.dynamics.vardist.means))); %%%%%%
%       fprintf(1,'In vargpTimeDynamicsUpdateStats DynKernParams are      %s\n', num2str(kernExtractParam(model.dynamics.kern)));
%      fprintf(1,'In vargpTimeDynamicsUpdateStats KernParams are      %s\n',      num2str(kernExtractParam(model.kern)));
%fprintf(1,'In vargpTimeDynamicsUpdateStats max(abs(params))=%d\n',max(abs(vargplvmExtractParam(model)))); %%%%%%%%% DEBUG

% %%%%_DEBUG


%%%% Update the base model with the original variational parameters.
[model.vardist.means model.vardist.covars] = vargpTimeDynamicsPriorKernGrad(model.dynamics);



function [muqOrig SqOrig] = vargpTimeDynamicsPriorKernGrad(dynModel)
%fprintf(1,'vargpTimeDynamicsVarPriorKernGrad2..\n');%%% DEBUG

muqOrig = dynModel.Kt * dynModel.vardist.means;

SqOrig = zeros(dynModel.N, dynModel.q); % memory preallocation
for q=1:dynModel.q
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
    % Invert Bt_q

    Lbt_q = jitChol(Bt_q)';
    G = repmat(LambdaH_q, 1, dynModel.N).*dynModel.Kt;
    G = Lbt_q \ G; 
    SqOrig(:,q) = diag(dynModel.Kt) - sum(G.*G,1)';
    
end


