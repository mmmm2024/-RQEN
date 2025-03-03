function [x,iter] = ADMM_QEN(A, Y, lambda, par)
%------------------------------------------------------------------------

n=size(A,2); N=4*n;
PA=OperatorP(A); QY=OperatorQ(Y); %Using transform operator P and Q
D=PA; y=QY;

% Initialize
beta = 1e-2;
maxIter = 1000;
thres = 1e-15; 
f=0;

b = zeros(N ,1);
U = zeros(n ,4);

I = diag(ones(N,1));
Dy=D'*y;
DDI=D'*D+beta*I+par*I;
inv_DDI=inv(DDI);

for iter = 1:maxIter

    z = vec(U) - b;
    aux=Dy+beta*z;
    c=inv_DDI*aux;
    x=inv_vec(c);

    Temp=inv_vec(c+b);
    U = grpRow_wthresh(Temp, lambda/beta);   
    
    b = b + (c - vec(U));

    % % Check convergence 
    if mod(iter,10) == 0
        prev_f = f;   
        f = f + norm(y - D*c, 'fro' )^2;

        f = f/2 + lambda*norm12(U)+par*norm(U,'fro');
        
        thresCheck = abs((prev_f-f)/prev_f);
        if  thresCheck < thres
            break
        end   
    end
end

function f = norm12(W)
p = size(W,1);temp=zeros(p,1);
for i = 1:p
    temp(i) = norm(W(i,:),2);
end
f = norm(temp,1);

function u = vec(U)
u=U(:);

function U = inv_vec(u)
u=u(:);N=length(u);n=N/4;
U=[u(1:n),u(n+1:2*n),u(2*n+1:3*n),u(3*n+1:end)];


function v = grpRow_wthresh(b, lambda)

[n, C] = size(b);
for i = 1:n    
        tmp = 1 - lambda/norm(b(i,:));
        tmp = (tmp + abs(tmp))/2;
        v(i,:) = tmp*b(i,:);    
end


