%RQEN with bit noise figure 

clear; clc; close all; 

%addpath function

r=0.05:0.05:0.5;
times=50;

err=zeros(length(r),1);
RQENerr=zeros(length(r),times);
RQENvar=zeros(length(r),1);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for k = 1:length(r)    
    k     
    for t = 1:times      
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d=100;  %Dimension of quaternion measurements
n=400;  %Dimension of quaternion sparse vectors
s=5;    %groupsparsity
b=5;    %block length
x=zeros(n,4);A=zeros(d,n,4);e=zeros(d,n,4);
Z=zeros(d,s,4);
for i=1:n
    for j=1:4
        A(:,i,j)=randn(d,1);
        e(:,i,j)=normrnd(0,0.001,[d,1]); 
    end   
end 

for k2=1:s
    for l=1:4
        Z(:,k2,l)=randn(d,1);
    end    
end    
selected_cols = zeros(1, s);
for i2 = 1:s
    while true
        col = randi(n-8);
        if ~ismember(col-(b+1):1:col+b+1, selected_cols) % 
            selected_cols(i2) = col;
            break;
        end
    end
end
for ii = 1:s
    for jj=selected_cols(ii):selected_cols(ii)+b+1
        A(:,jj, :) = Z(:,ii,:)+e(:,jj,:);
    end
end
for ii1 = 1:s
    for kk1=1:4
        temp=randi([1, 10], 1, 1);
    for jj1=selected_cols(ii1):selected_cols(ii1)+b+1
        
        x(jj1,kk1)=temp;
    end
    end
end 
y=QMultiply(A,x); %Multiplication of quaternions

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%BitError 
num=d*r(k);  
index2=randperm(d);
ind2=index2(1:num);
temp2=rand(length(ind2),4);temp2(temp2>0.5)=1;temp2(temp2<=0.5)=-1; 
noise=zeros(size(y)); noise(ind2,:)=100*temp2;
y1=y;
y1(ind2,:)=100*temp2;

 %%-----------------------Recover Sparse Vector x---------------------
 %method: Robust Quaternion EN
 lambda1 = 0.01;                 lambda2 = 0.001;
 xtest = Huber_QEN(A,y1,lambda1,lambda2); 
 RQENERR=norm(x-xtest,'fro')/norm(x,'fro');
 disp(['RQEN:    ' num2str(RQENERR)] );     
RQENerr(k,t)=RQENERR;

end      
            
end
err=mean(RQENerr');
RQENvar=std(RQENerr');


 figure;
 xf=1:length(r);
errorbar(xf,err5, RQENvar,'r-','linewidth',3,'MarkerSize',10);
legend_str=cell(1,1);
legend_str{1}='RQEN';
legend(legend_str,'Location','NorthWest');  
xlabel('\fontsize{25} Corruption ratios (%) of bit error');    
ylabel('\fontsize{25} Recovery error'); 
 set(gca,'XTick',1:length(r));
set(gca,'XTicklabel',{'5','10','15','20','25','30','35','40','45','50'})
 set(gca,'FontSize',25)
 
 
