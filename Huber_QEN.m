function [x,w,weight_gap] = Huber_QEN(D,y,lambda1,lambda2)
 
maxI=10;
weight_gap=zeros(maxI,1);
y=y(:);
[M,N,C]=size(D);
y=reshape(y,[M,1,C]);
weight_thre=1e-6;  
w = ones(M,1);
weight_pref = w;
D_w=zeros(M,N,C);
y_w=zeros(M,1,C);
for nit = 1: maxI
     W = diag(w);
     for i=1:C
         if C==3
             D_w(:,:,1)=zeros(M,N);
             D_w(:,:,i+1)=W*D(:,:,i);
             y_w(:,:,i+1)=W*y(:,:,i);
         end    
         D_w(:,:,i)=W*D(:,:,i);
         y_w(:,:,i)=W*y(:,:,i);
     end
    
     x  =  ADMM_QEN(D_w,y_w,lambda1,lambda2); 

     PD=OperatorP(D); Qy=OperatorQ(y);Qx=OperatorQ(x); 
     Qe=Qy-PD*Qx;
     e=OperatorQinv(Qe);
     emo=zeros(M,1);
     for j=1:M
         emo(j,1)=norm(e(j,:),2);
     end
 
     tau=0.01*median(emo)+eps;
     w=zeros(M,1);
     for k=1:M
         if emo(k)<tau
             w(k)=1;
         else
             w(k)=tau/emo(k);
         end
     end

     w=sqrt(w);
     weight_g  = norm(w-weight_pref,2)/norm(weight_pref,2);
     weight_pref = w;
     weight_gap(nit) =  weight_g;
     if weight_g < weight_thre
         break;
     end
  
end
 
