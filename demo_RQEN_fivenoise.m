%RQEN with five noise table

clear; clc; close all; 

addpath function
d=100;  %Dimension of quaternion measurements
n=400;  %Dimension of quaternion sparse vectors
s=4;    %groupsparsity
b=5;    %groupcolumnnumber
t=50;   %random run number
RQENERR=zeros(5,1);
RQENVAR=zeros(5,1);
RQENERRTEMP=zeros(t,5); 

%%-----------------------Generate Data---------------------
for j=1:t 
    j
     for i=1:5             
        %Create sparse quaternionic vector
        x=zeros(n,4);A=zeros(d,n,4);e=zeros(d,n,4);
        Z=zeros(d,s,4);
        for i1=1:n
            for j1=1:4
                A(:,i1,j1)=randn(d,1);
                e(:,i1,j1)=normrnd(0,0.001,[d,1]);  
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
                if ~ismember(col-(b+1):1:col+b+1, selected_cols) 
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
        
        yq=QMultiply(A,x); %Multiplication of quaternions      
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

       
        noise=zeros(size(yq,1),size(yq,2),5);
        noise(:,:,1)=normrnd(0,1,size(yq));
        noise(:,:,2)=chi2rnd(1,size(yq));
        noise(:,:,3)=exprnd(1,size(yq));
        noise(:,:,4)=trnd(1,size(yq));
        noise(:,:,5)=unifrnd(0,1,size(yq));
        y1=yq+noise(:,:,i); %add noise
     
        %%-----------------------Recover Sparse Vector x-----------
        lambda1 = 0.01;              lambda2 = 0.001;
        xtest5 = Huber_QEN(A,y1,lambda1,lambda2); 
        RQENERR=norm(x-xtest5,'fro')/norm(x,'fro');
        err=RQENERR;
        disp(['RQEN:' num2str(err)] );
            
        RQENERRTEMP(j,i)=err;        
     end    
end
    RQENERR=mean(RQENERRTEMP);RQENVAR=std(RQENERRTEMP); 
    
allerr=RQENERR; 
allvar=RQENVAR; 
    

