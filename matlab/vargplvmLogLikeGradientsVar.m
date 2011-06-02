% This function is depricated and not used, it has been embeded in
% vargplvmPointLogLikeGradient

function gVar = vargplvmLogLikeGradientsVar(model, includeKL)
% VARGPLVMLOGLIKEGRADIENTSVAR
% VARGPLVM

if ~isfield(model, 'dynamics') || isempty(model.dynamics)
    gVarmeansKL = - model.vardist.means(:)';
    % !!! the covars are optimized in the log space 
    gVarcovsKL = 0.5 - 0.5*model.vardist.covars(:)';
end

% Likelihood terms (coefficients)
gPsi1 = model.beta * model.m * model.B';
    gPsi1 = gPsi1'; % because it is passed to "kernVardistPsi1Gradient" as gPsi1'...
gPsi2 = (model.beta/2) * model.T1;
gPsi0 = -0.5 * model.beta * model.d;
%model.vardist
%model.vardist.means
%model.vardist.covars
%model
%pause

[gKern1, gVarmeans1, gVarcovs1, gInd1] = kernVardistPsi1Gradient(model.kern, model.vardist, model.X_u, gPsi1');
[gKern2, gVarmeans2, gVarcovs2, gInd2] = kernVardistPsi2Gradient(model.kern, model.vardist, model.X_u, gPsi2);
[gKern0, gVarmeans0, gVarcovs0] = kernVardistPsi0Gradient(model.kern, model.vardist, gPsi0);


gVarmeansLik = gVarmeans0 + gVarmeans1 + gVarmeans2;

if isfield(model, 'dynamics') && ~isempty(model.dynamics)
    gVarcovsLik = gVarcovs0 + gVarcovs1 + gVarcovs2;      
    if includeKL
        [gVarmeans gVarcovs gDynKern] = modelPriorReparamGrads(model.dynamics, gVarmeansLik, gVarcovsLik);
    else
         dynModel = model.dynamics;
         gVarmeansLik = reshape(gVarmeansLik,dynModel.N,dynModel.q);
         gVarcovsLik = reshape(gVarcovsLik,dynModel.N,dynModel.q);

        gVarmeans = gVarmeansLik; %dynModel.Kt * (gVarmeansLik - 0*dynModel.vardist.means);

        gVarcovs = zeros(dynModel.N, dynModel.q); % memory preallocation

        for q=1:dynModel.q
            LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
            Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
            % Invert Bt_q
            Lbt_q = jitChol(Bt_q)';
            G1 = Lbt_q \ diag(LambdaH_q);
            G = G1*dynModel.Kt;
    
            % Find Sq
            Sq = dynModel.Kt - G'*G;
            gVarcovs(:,q) = - (Sq .* Sq) * (gVarcovsLik(:,q) + 0*0.5*dynModel.vardist.covars(:,q));
        end

        % Serialize (unfold column-wise) gVarmeans and gVarcovs from NxQ matrices
        % to 1x(NxQ) vectors
        gVarcovs = gVarcovs(:)';
        gVarmeans = gVarmeans(:)';
    end
    
    gVarcovs = (gVarcovs(:).*model.dynamics.vardist.covars(:))';
else % not dynamic
    gVarcovs0 = (gVarcovs0(:).*model.vardist.covars(:))';
    gVarcovs1 = (gVarcovs1(:).*model.vardist.covars(:))';
    gVarcovs2 = (gVarcovs2(:).*model.vardist.covars(:))';
    
    gVarcovsLik = gVarcovs0 + gVarcovs1 + gVarcovs2;
    gVarmeans = gVarmeansLik + gVarmeansKL;
    gVarcovs = gVarcovsLik + gVarcovsKL;
end


%gVarmeans = gVarmeansLik(:)';
gVar = [gVarmeans gVarcovs];





