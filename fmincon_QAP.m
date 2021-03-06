%using fmincon with SQP solver to solve convex relaxed QAP problem
% clc
% clear all
function [value,time]=fmincon_QAP(W)
niter=30;%sample the engienvalue for 10 times

%  W=rand(N^2,N^2);
% load('W10');
N=sqrt(size(W,2));

%similar to TTCRA
k=20;
stepsize=0.0001;

%initial time


muL_min=min(real(eig(W)));
muL_max=max(real(eig(W)));
muL=[muL_min:(muL_max-muL_min)/niter:muL_max];

A_eq=[kron(eye(N),ones(1,N));kron(ones(1,N),eye(N))];

b_eq=ones(2*N,1);

A=-diag(ones(N^2,1));
b=zeros(N^2,1);

init_tmp{1,1}=1/N.*ones(N^2,1);
X=init_tmp{1,1};
options = optimoptions('fmincon','Algorithm','sqp','MaxFunctionEvaluations',10000000,'MaxIterations',10000000);
tic
for i=1:niter+1
    
        [y,f]=fmincon(@(X)QAP(X,W,muL(i)),init_tmp{1,i},A,b,A_eq,b_eq,[],[],[],options);
        init_tmp{1,i+1}=y;
% option.Algorithm='active-set';
% X = quadprog((W-muL_max*ones(N^2,N^2)),[],A,b,A_eq,b_eq,[],[],X,option);
%     for j=1:k*sqrt(size(W,2))
%         grad=(W+W')*X-muL(i).*X;
%         X=X-stepsize.*grad;
%         X=DSProjection(X,N);
%     end
    
    
end

%end time
toc
% disp(['Computing Time: ',num2str(toc)]);
value=QAP(y,W,0);
% perm=reshape(y,N,N);
time=toc;
perm=reshape(y,N,N);
% QAP(y,W,muL_min)
end



