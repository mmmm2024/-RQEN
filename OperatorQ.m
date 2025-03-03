function z=OperatorQ(y)

[D,C]=size(y); 
if C==3
    Temp=zeros(D,4);
    Temp(:,2:4)=y;
    y=Temp;
end
z=[y(:,1);y(:,2);y(:,3);y(:,4)];



