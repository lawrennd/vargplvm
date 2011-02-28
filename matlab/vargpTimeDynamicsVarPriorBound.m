function pb = vargpTimeDynamicsVarPriorBound(dynModel)

pb = vargpTimeDynamicsVarPriorBound1(dynModel);

%{
%%% COMPARISON
tStart=tic;
pb1=vargpTimeDynamicsVarPriorBound1(dynModel);
tElapsed1=toc(tStart);

tStart=tic;
pb2=vargpTimeDynamicsVarPriorBoundDummy(dynModel);
tElapsed2=toc(tStart);

fprintf(1,'abs(pb2-pb1)=%.15d\n',abs(pb2-pb1));
fprintf(1,' tElapsed1=%d\n tElapsed2=%d\n',tElapsed1,tElapsed2);

pb=pb1;
%%% 
%}

function pb = vargpTimeDynamicsVarPriorBound1(dynModel)

%fprintf(1,'vargpTimeDynamicsVarPriorBound1..\n');%%% DEBUG

sumBhat = zeros(dynModel.N, dynModel.N);
sumMu = zeros(dynModel.N, dynModel.N);
sumLogDetB = 0;

for q=1:dynModel.q

    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;

    Bt_q = eye(dynModel.N) + (LambdaH_q*LambdaH_q').*dynModel.Kt;
   
    Lbt_q = jitChol(Bt_q)';
    Bhat_q = Lbt_q \ diag(LambdaH_q);
    Bhat_q = Bhat_q'*Bhat_q; 
    sumBhat = sumBhat + Bhat_q; 

    sumMu = sumMu + (dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');   
    sumLogDetB = sumLogDetB + 2*sum(log(diag(Lbt_q)));
end


% pb = 0.5*(-(dynModel.N * dynModel.q) + sum(sum(sumBhat.*dynModel.Kt)) ...
%           - sum(sum(dynModel.Kt .* sumMu)) - sumLogDetB ); 

% Note: 0.5*N*Q was missing before... now is the correct KL 
pb = 0.5*(sum(sum(sumBhat.*dynModel.Kt)) - sum(sum(dynModel.Kt .* sumMu)) - sumLogDetB ); 
      



      
function pb = vargpTimeDynamicsVarPriorBoundDummy(dynModel)

%fprintf(1,'vargpTimeDynamicsVarPriorBound1..\n');%%% DEBUG

Lt = jitChol(dynModel.Kt)';
invLt = Lt \ eye(dynModel.N);
invKt = invLt' * invLt;

sumTr = 0;
sumLogSq =0;
for q=1:dynModel.q
    Lambda_q = diag(dynModel.vardist.covars(:,q));
    KtL = invKt + Lambda_q;
    L_KtL = jitChol(KtL)';
    invL_KtL = L_KtL \ eye(dynModel.N);
    Sq = invL_KtL' * invL_KtL;
    Ls = jitChol(Sq)';
        
    sumTr = sumTr + sum(sum(invKt .* Sq));
    
    mu = dynModel.Kt * dynModel.vardist.means(:,q);
    mumut= mu*mu';
    sumTr = sumTr + sum(sum(invKt .* mumut));
    sumLogSq = sumLogSq + 2*sum(log(diag(Ls)));
end

pb = -0.5*dynModel.q*2*sum(log(diag(Lt))) - 0.5*sumTr +0.5*sumLogSq;


%{      
function pb = vargpTimeDynamicsVarPriorBound2(dynModel)
fprintf(1,'vargpTimeDynamicsVarPriorBound2..\n');%%% DEBUG

sumMu = 0;
sumLogDetB = 0;

sumTr1 = 0;

for q=1:dynModel.q

    LambdaH_q = dynModel.vardist.covars(:,q).^0.5;

    LKL =  (LambdaH_q*LambdaH_q').*dynModel.Kt; 
    Bt_q = eye(dynModel.N) + LKL;
    Lbt_q = jitChol(Bt_q)';
    sumTr1 = sumTr1 + sum(diag(Lbt_q'\(Lbt_q\LKL)));

    sumMu = sumMu + (dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');   
    sumLogDetB = sumLogDetB + 2*sum(log(diag(Lbt_q)));
end
pb = 0.5*(-(dynModel.N * dynModel.q) + sumTr1 ...
         - sum(sum(dynModel.Kt .* (dynModel.vardist.means*dynModel.vardist.means'))) - sumLogDetB ); 

%}    
 
%{
%%%%%%%%%% OLD %%%%%%%%%%%%%
function pb = vargpTimeDynamicsVarPriorBoundOLD(dynModel)

fprintf(1,'vargpTimeDynamicsVarPriorBoundOLD..\n');%%% DEBUG

sumBhat = 0;
sumMu = 0;
sumLogDetB = 0;
for q=1:dynModel.q
    LambdaH_q = diag(dynModel.vardist.covars(:,q).^0.5); % I don't need diag here, I only use lambda_q's
    
    Bt_q = eye(dynModel.N) + diag(LambdaH_q)*diag(LambdaH_q)'.*dynModel.Kt;
   
    % Invert Bt_q
    Lbt_q = jitChol(Bt_q)';
    LbtInv_q = Lbt_q \ eye(dynModel.N);
    BtInv_q = LbtInv_q' * LbtInv_q;    

    Bhat_q = diag(LambdaH_q)*diag(LambdaH_q)'.*BtInv_q;
   
    sumBhat = sumBhat + Bhat_q;   
    sumMu = sumMu + (dynModel.vardist.means(:,q) * dynModel.vardist.means(:,q)');   
    sumLogDetB = sumLogDetB + 2*sum(log(diag(Lbt_q)));
end

pb = 0.5*(-(dynModel.N * dynModel.q) + sum(sum(sumBhat.*dynModel.Kt)) ...
          - sum(sum(dynModel.Kt .* sumMu)) - sumLogDetB ); 

%}