%RQEN bit noise show

clear; clc; close all; 


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
    %    x(jj,:)=ii*ones(1,4);
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
y=QMultiply(A,x); 
yr=zeros(100,4);
for k1=1:4
    yr(:,k1)=A(:,:,k1)*x(:,k1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%BitError 
num=d*0.1;
index2=randperm(d);
ind2=index2(1:num);
temp2=rand(length(ind2),4);temp2(temp2>0.5)=1;temp2(temp2<=0.5)=-1; 
noise=zeros(size(y)); noise(ind2,:)=100*temp2;
y1=y;y2=yr;
y1(ind2,:)=100*temp2;
y2(ind2,:)=100*temp2;

        


%%-----------------------Recover Sparse Vector x---------------------
lambda1 = 0.01;              lambda2 = 0.001;
xtest = Huber_QEN(A,y1,lambda1,lambda2); 
RQENERR=norm(x-xtest,'fro')/norm(x,'fro');


            
%%-----------------------Show Recovery Results---------------------
figure;gca_fontSize=20;linewidth=2;titlesize=20;

subplot(4,4,1);plot(1:n,x(:,1),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('Groundtruth: Scalar','fontsize',titlesize);hold on;
subplot(4,4,2);plot(1:n,x(:,2),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('Groundtruth: part i ','fontsize',titlesize);hold on;
subplot(4,4,3);plot(1:n,x(:,3),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('Groundtruth: part j','fontsize',titlesize);hold on;
subplot(4,4,4);plot(1:n,x(:,4),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('Groundtruth: part k','fontsize',titlesize);hold on;


subplot(4,4,5);plot(1:n,xtest(:,1),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('RQEN: Scalar','fontsize',titlesize);hold on;
subplot(4,4,6);plot(1:n,xtest(:,2),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('RQEN: part i','fontsize',titlesize);hold on;
subplot(4,4,7);plot(1:n,xtest(:,3),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('RQEN: part j','fontsize',titlesize);hold on;
subplot(4,4,8);plot(1:n,xtest(:,4),'LineWidth',linewidth);ylim([-10 10]);
set(gca,'FontSize', gca_fontSize);
title('RQEN: part k','fontsize',titlesize);hold on;
set(gcf,'outerposition',get(0,'screensize'));


disp(['Recovery error of RQEN:' num2str(RQENERR)] );