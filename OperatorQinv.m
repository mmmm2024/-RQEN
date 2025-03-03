function y=OperatorQinv(z)

DD=size(z,1); D=DD/4;
y=zeros(D,4);
for i=1:4
    y(:,i)=z(D*(i-1)+1:D*i);
end




