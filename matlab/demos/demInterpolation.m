
%-- interpolation

dt = (timeStampsTraining(end) - timeStampsTraining(end-1));
dtt = dt/3;
% futurePred = dtt:dt:dt*size(Ytr,1)-1
%futurePred = 0.0515:0.103:0.103*59; % dt/2
%futurePred = 0.0343:0.103:0.103*59; % dt/3

  Z = zeros(size(Ytr,1)+size(Varmu2,1),size(Varmu2,2));
  
  k=1;
  for i=1:size(Varmu2,1)
Z(k,:) = Ytr(i,:);
k = k+1;
Z(k,:) = Varmu2(i,:);
k=k+1;
end