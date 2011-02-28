function [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads(dynModel, gVarmeansLik, gVarcovsLik)


[gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads1(dynModel, gVarmeansLik, gVarcovsLik);

%{
%[gVarmeans gVarcovs gDynKern] =
%vargpTimeDynamicsPriorReparamGradsTEMP(dynModel, gVarmeansLik, gVarcovsLik);
%%%%%%% COMPARISON
% tStart=tic;
% [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads1(dynModel, gVarmeansLik, gVarcovsLik);
% tElapsed1=toc(tStart);
% 
% tStart=tic;
% [gVarmeans2 gVarcovs2 gDynKern2] = vargpTimeDynamicsPriorReparamGrads2(dynModel, gVarmeansLik, gVarcovsLik);
% tElapsed2=toc(tStart);
% 
% fprintf(1,'max(abs(gVarmeans-gVarmeans2))=%.10d\n',max(abs(gVarmeans-gVarmeans2)));
% fprintf(1,'max(abs(gVarcovs-gVarcovs2))=%.10d\n',max(abs(gVarcovs-gVarcovs2)));
% fprintf(1,'max(abs(gDynKern-gDynKern2))=%.10d\n',max(abs(gDynKern-gDynKern2)));
% 
% 
% fprintf(1,'tElapsed1=%d\ntElapsed2=%d\n',tElapsed1,tElapsed2);
%}

%-------------
function [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads1(dynModel, gVarmeansLik, gVarcovsLik)

% gVarmeansLik and gVarcovsLik are serialized into 1x(NxQ) vectors.
% Convert them to NxQ matrices, i.e. fold them column-wise.
gVarmeansLik = reshape(gVarmeansLik,dynModel.N,dynModel.q);
gVarcovsLik = reshape(gVarcovsLik,dynModel.N,dynModel.q);

gVarmeans = dynModel.Kt * (gVarmeansLik - dynModel.vardist.means);

gVarcovs = zeros(dynModel.N, dynModel.q); % memory preallocation
sumTrGradKL = 0;

for q=1:dynModel.q
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    G1 = Lbt_q \ diag(LambdaH_q);
    G = G1*dynModel.Kt;
   
    % Find Sq
    Sq = dynModel.Kt - G'*G;
    
    gVarcovs(:,q) = - (Sq .* Sq) * (gVarcovsLik(:,q) + 0.5*dynModel.vardist.covars(:,q));

    % Find the coefficient for the grad. wrt theta_t (params of Kt)
    G1T=G1';
    Bhat=G1T*G1;
    BhatKt=G1T*G;
    
    trGradKL = -0.5*(BhatKt*Bhat + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
    
    IBK = eye(dynModel.N) - BhatKt;
    diagVarcovs = repmat(gVarcovsLik(:,q)', dynModel.N,1);   
    trGradKL = trGradKL + IBK .*  diagVarcovs * IBK';   
    trGradKL = trGradKL + dynModel.vardist.means(:,q) * gVarmeansLik(:,q)';
    
    sumTrGradKL = sumTrGradKL + trGradKL;
end
 gDynKern = kernGradient(dynModel.kern, dynModel.t, sumTrGradKL);

% Serialize (unfold column-wise) gVarmeans and gVarcovs from NxQ matrices
% to 1x(NxQ) vectors
gVarcovs = gVarcovs(:)';
gVarmeans = gVarmeans(:)';

%%%%% DEBUG_
% gDynKern %%%%%%DEBUG (they seem ok...)
%  fprintf(1,'In ReparamGrads, params=%d %d %d\n',gDynKern(1),gDynKern(2),gDynKern(3));
%  fprintf(1,'In ReparamGrads,MaxgVarmeans=%d\n',max(max(gVarmeans))); %%%%%%
%  fprintf(1,'In ReparamGrads,MaxgVarcovs=%d\n',max(max(gVarcovs))); %%%%%%
%%%%%%_DEBUG

function [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads2(dynModel, gVarmeansLik, gVarcovsLik)

%fprintf(1,'vargpTimeDynamicsVarReparamGrads1..\n');%%% DEBUG

% gVarmeansLik and gVarcovsLik are serialized into 1x(NxQ) vectors.
% Convert them to NxQ matrices, i.e. fold them column-wise.
gVarmeansLik = reshape(gVarmeansLik,dynModel.N,dynModel.q);
gVarcovsLik = reshape(gVarcovsLik,dynModel.N,dynModel.q);

%%% TODO: check that the following is true for each q (compare with report)
gVarmeans = dynModel.Kt * (gVarmeansLik - dynModel.vardist.means);

gVarcovs = zeros(dynModel.N, dynModel.q); % memory preallocation
% gDynKern = 0;
 gMeanPart = 0;
sumTrGradKL = 0;


for q=1:dynModel.q

    
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    G1 = Lbt_q \ diag(LambdaH_q);
    G = G1*dynModel.Kt;
   
    % Find Sq
    Sq = dynModel.Kt - G'*G;
    
    gVarcovs(:,q) = - (Sq .* Sq) * (gVarcovsLik(:,q) + 0.5*dynModel.vardist.covars(:,q));
  
    
    Bhat = diag(LambdaH_q) * inv(Bt_q) * diag(LambdaH_q);
    BhatKt = Bhat * dynModel.Kt;
    trGradKL = -0.5*(BhatKt*Bhat + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
   
    %%%%%%% 1st way %%%
    %IBK = eye(dynModel.N) - BhatKt;
    %trGradKL = trGradKL + IBK' * diag(gVarcovsLik(:,q)) * IBK;
    %------------------
    
    %%%%%%% 2nd way %%%%
    Lt=jitChol(dynModel.Kt)'; invLt = Lt \ eye(dynModel.N); invKt = invLt' * invLt;
    %trGradKL = trGradKL + (Sq * invKt) * diag(gVarcovsLik(:,q)) * (invKt*Sq);
    trGradKL = trGradKL + (invKt*Sq) * diag(gVarcovsLik(:,q)) * (Sq*invKt);
    %trGradKL = trGradKL + (Sq * invKt) * diag(gVarcovsLik(:,q)) * (invKt*Sq);

    %------------------
   
    trGradKL = trGradKL + dynModel.vardist.means(:,q) * gVarmeansLik(:,q)';
     sumTrGradKL = sumTrGradKL + trGradKL;
%     %gMeanPart = gMeanPart + dynModel.vardist.means(:,q) * gVarmeansLik(:,q)';
end
 gDynKern = kernGradient(dynModel.kern, dynModel.t, sumTrGradKL);
 %gKernMu = dynModel.vardist.means * gVarmeansLik';%%%
 %gDynKern = gDynKern + kernGradient(dynModel.kern, dynModel.t, gMeanPart); %%%
 


    %gKern = kernGradient(dynModel.kern, dynModel.t, trGradKL);
    %gDynKern = gDynKern + gKern;
%%%%%%%%%%%%%%%%%
    
%     G1T=G1';
%     A1=G1T*G1;
%     A2=G1T*G;  
%     
%     %-- Calculate the trace term-by-term
%     trGradKL = -0.5*(A2*A1 + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
%     IBK = eye(dynModel.N) - A2;
%     diagVarcovs = repmat(gVarcovsLik(:,q)', dynModel.N,1);
%     trGradKL = trGradKL + IBK' .*  diagVarcovs * IBK; 
%    %     trGradKL = trGradKL + IBK' * diag(gVarcovsLik(:,q)) * IBK;
%     gKern = kernGradient(dynModel.kern, dynModel.t, trGradKL);
%     gDynKern = gDynKern + gKern;
%     
%     %-- Calculate the means term
%     % The following might be the other way around (because
%     % kernGradient traces the result -it should be correct even in that case thought-)
%     gMeanPart = gMeanPart + gVarmeansLik(:,q)' * dynModel.vardist.means(:,q);
% end


%gDynKern = gDynKern + kernGradient(dynModel.kern, dynModel.t, gMeanPart);

% The following should rather go to vargplvmLogLikeGradients
%gVarcovs = gVarcovs.*dynModel.vardist.covars;

% Serialize (unfold column-wise) gVarmeans and gVarcovs from NxQ matrices
% to 1x(NxQ) vectors
gVarcovs = gVarcovs(:)';
gVarmeans = gVarmeans(:)';



% From the old one with a small addition
function [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGradsOLD(dynModel, gVarmeansLik, gVarcovsLik)


%fprintf(1,'vargpTimeDynamicsVarReparamGrads2..\n');%%% DEBUG

% gVarmeansLik and gVarcovsLik are serialized into 1x(NxQ) vectors.
% Convert them to NxQ matrices, i.e. fold them column-wise.
gVarmeansLik = reshape(gVarmeansLik,dynModel.N,dynModel.q);
gVarcovsLik = reshape(gVarcovsLik,dynModel.N,dynModel.q);

%%% TODO: check that the following is true for each q (compare with report)
gVarmeans = dynModel.Kt * (gVarmeansLik - dynModel.vardist.means);

gVarcovs = zeros(dynModel.N, dynModel.q); % memory preallocation
gDynKern = 0;
gMeanPart = 0;
for q=1:dynModel.q
%    LambdaH_q = diag(dynModel.vardist.covars(:,q))^(0.5); % SLOW!
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    %Bt_q = eye(dynModel.N) + LambdaH_q * dynModel.Kt * LambdaH_q;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    LbtInv_q = Lbt_q \ eye(dynModel.N);
    BtInv_q = LbtInv_q' * LbtInv_q;
    
    % Bhat_q = LambdaH_q * BtInv_q * LambdaH_q;   %SLOW
    
    % Since LambdaH_q is diagonal, we can use the property
    % D*M*D=diag(D)*diag(D)'.*M, D diag.matrix, M symmetric.
    Bhat_q = LambdaH_q*LambdaH_q'.*BtInv_q;
    
    
    BhatKt = Bhat_q * dynModel.Kt;
    % Find Sq
    Sq = dynModel.Kt - dynModel.Kt * BhatKt;
  % gVarcovs(:,q) = (Sq .* Sq) * (gVarcovsLik(:,q) - 0.5*dynModel.vardist.covars(:,q));
    gVarcovs(:,q) = - (Sq .* Sq) * (gVarcovsLik(:,q) + 0.5*dynModel.vardist.covars(:,q));
    
    
    
    %-- Calculate the trace term-by-term
    trGradKL = -0.5*(BhatKt * Bhat_q + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
    IBK = eye(dynModel.N) - BhatKt;  
    
    %%% NEW
    diagVarcovs = repmat(gVarcovsLik(:,q)', dynModel.N,1);
    trGradKL = trGradKL + IBK' .*  diagVarcovs * IBK; 
    %%%
    
    %trGradKL = trGradKL + IBK' * diag(gVarcovsLik(:,q)) * IBK;
    gKern = kernGradient(dynModel.kern, dynModel.t, trGradKL);
    gDynKern = gDynKern + gKern;
    
    %-- Calculate the means term
    % The following might be the other way around (because
    % kernGradient traces the result -it should be correct even in that case thought-)
    gMeanPart = gMeanPart + gVarmeansLik(:,q)' * dynModel.vardist.means(:,q);
    %gMeanPart = gVarmeansLik(:,q)' * dynModel.vardist.means(:,q);
    %gDynKern = gDynKern + kernGradient(dynModel.kern, dynModel.t, gMeanPart);
end
gDynKern = gDynKern + kernGradient(dynModel.kern, dynModel.t, gMeanPart);


% Serialize (unfold column-wise) gVarmeans and gVarcovs from NxQ matrices to 1x(NxQ) vectors
gVarcovs = gVarcovs(:)';
gVarmeans = gVarmeans(:)';


%-------------
function [gVarmeans gVarcovs gDynKern] = vargpTimeDynamicsPriorReparamGrads1OLD(dynModel, gVarmeansLik, gVarcovsLik)

% gVarmeansLik and gVarcovsLik are serialized into 1x(NxQ) vectors.
% Convert them to NxQ matrices, i.e. fold them column-wise.
gVarmeansLik = reshape(gVarmeansLik,dynModel.N,dynModel.q);
gVarcovsLik = reshape(gVarcovsLik,dynModel.N,dynModel.q);

gVarmeans = dynModel.Kt * (gVarmeansLik - dynModel.vardist.means);

gVarcovs = zeros(dynModel.N, dynModel.q); % memory preallocation
sumTrGradKL = 0;

for q=1:dynModel.q
    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;
    Bt_q = eye(dynModel.N) + LambdaH_q*LambdaH_q'.*dynModel.Kt;
    
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    G1 = Lbt_q \ diag(LambdaH_q);
    G = G1*dynModel.Kt;
   
    % Find Sq
    Sq = dynModel.Kt - G'*G;
    
    gVarcovs(:,q) = - (Sq .* Sq) * (gVarcovsLik(:,q) + 0.5*dynModel.vardist.covars(:,q));

    G1T=G1';
    Bhat=G1T*G1;
    BhatKt=G1T*G;  
    trGradKL = -0.5*(BhatKt*Bhat + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
    IBK = eye(dynModel.N) - BhatKt;
   % trGradKL = trGradKL + IBK * diag(gVarcovsLik(:,q)) * IBK'; % Correct
    diagVarcovs = repmat(gVarcovsLik(:,q)', dynModel.N,1);
    trGradKL = trGradKL + IBK .*  diagVarcovs * IBK'; 
%    Bhat = diag(LambdaH_q) * inv(Bt_q) * diag(LambdaH_q);
%    BhatKt = Bhat * dynModel.Kt;
%    trGradKL = -0.5*(BhatKt*Bhat + dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');
%    
    %%%%%%% 1st way %%%
    %IBK = eye(dynModel.N) - BhatKt;
    %trGradKL = trGradKL + IBK' * diag(gVarcovsLik(:,q)) * IBK;
    %------------------
    
%     %%%%%%% 2nd way %%%%
%     Lt=jitChol(dynModel.Kt)'; invLt = Lt \ eye(dynModel.N); invKt = invLt' * invLt;
%     %trGradKL = trGradKL + (Sq * invKt) * diag(gVarcovsLik(:,q)) * (invKt*Sq);
%     %trGradKL = trGradKL + (invKt*Sq) * diag(gVarcovsLik(:,q)) * (Sq*invKt); % Correct
%     invKtSq = invKt*Sq;
%     trGradKL = trGradKL + invKtSq * diag(gVarcovsLik(:,q)) * invKtSq'; % Correct
%     %trGradKL = trGradKL + (Sq * invKt) * diag(gVarcovsLik(:,q)) * (invKt*Sq);
% 
%     %------------------
   
     trGradKL = trGradKL + dynModel.vardist.means(:,q) * gVarmeansLik(:,q)';
     sumTrGradKL = sumTrGradKL + trGradKL;
end
 gDynKern = kernGradient(dynModel.kern, dynModel.t, sumTrGradKL);

% The following should rather go to vargplvmLogLikeGradients
%gVarcovs = gVarcovs.*dynModel.vardist.covars;

% Serialize (unfold column-wise) gVarmeans and gVarcovs from NxQ matrices
% to 1x(NxQ) vectors
gVarcovs = gVarcovs(:)';
gVarmeans = gVarmeans(:)';
