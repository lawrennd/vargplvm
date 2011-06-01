%%%% !!!!! This has gone straight to vargpTimeDynamicsUpdateStats. This function will no longer be
%%%% used and will be depricated.

function [muqOrig SqOrig] = vargpTimeDynamicsPriorKernGrad(dynModel)
% VARGPTIMEDYNAMICSPRIORKERNGRAD Compute the original variational
% parameters of the dynamical varGP-LVM
% FORMAT
% DESC returns the original variational parameters of the dynamical
% varGP-LVM
% ARG dynModel : the VARGPLVM dynamics structure containing the parameters.
% RETURN muqOrig : the original Q, N-dimensional variational means in a matrix (NxQ).
% RETURN SqOrig : the original Q, N-dimensional diagonals of the variational 
% NxN covariances in a matrix (NxQ).

[muqOrig SqOrig]=vargpTimeDynamicsPriorKernGrad2(dynModel);


function [muqOrig SqOrig] = vargpTimeDynamicsPriorKernGrad1(dynModel)
fprintf(1,'vargpTimeDynamicsVarPriorKernGrad1..\n');%%% DEBUG

muqOrig = dynModel.Kt * dynModel.vardist.means;

SqOrig = zeros(dynModel.N, dynModel.q); % memory preallocation
for q=1:dynModel.q
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    LbtInv_q = Lbt_q \ eye(dynModel.N);
    
    % Find Sq
    GG = LbtInv_q.*repmat(LambdaH_q', dynModel.N, 1);

    GG = GG*dynModel.Kt;
    SqOrig(:,q) = diag(dynModel.Kt) - sum(GG.*GG,1)';
end

%%%%%%%%%%%%% 2n Version %%%%%%%%%%%%%%%%%

function [muqOrig SqOrig] = vargpTimeDynamicsPriorKernGrad2(dynModel)
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


%%%%%%%%%%%  Old version %%%%%%%%%%
function [muqOrig SqOrig] = vargpTimeDynamicsPriorKernGrad3(dynModel)
fprintf(1,'vargpTimeDynamicsVarPriorKernGradOld..\n');%%% DEBUG

muqOrig = dynModel.Kt * dynModel.vardist.means;

SqOrig = zeros(dynModel.N, dynModel.q); % memory preallocation
for q=1:dynModel.q
%    LambdaH_q = diag(dynModel.vardist.covars(:,q))^(0.5); % SLOW
    LambdaH_q = diag(dynModel.vardist.covars(:,q).^0.5);
    %Bt_q = eye(dynModel.N) + LambdaH_q * dynModel.Kt * LambdaH_q;
    Bt_q = eye(dynModel.N) + (diag(LambdaH_q)*diag(LambdaH_q)').*dynModel.Kt;
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    LbtInv_q = Lbt_q \ eye(dynModel.N);
    BtInv_q = LbtInv_q' * LbtInv_q;
    
    % Bhat_q = LambdaH_q * BtInv_q * LambdaH_q;   %SLOW
    
    % Since LambdaH_q is diagonal, we can use the property
    % D*M*D=diag(D)*diag(D)'.*M, D diag.matrix, M symmetric.
    Bhat_q = diag(LambdaH_q)*diag(LambdaH_q)'.*BtInv_q; % No diag needed, I already have lambda's
    
    % Find Sq
    Sq = dynModel.Kt - dynModel.Kt * Bhat_q * dynModel.Kt;
    % Store its diagonal only
    SqOrig(:,q) = diag(Sq); 
end