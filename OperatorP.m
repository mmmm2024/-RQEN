function B=OperatorP(A)

[M,N,C]=size(A); 
if C==3
    Temp=zeros(M,N,4);
    Temp(:,:,2:4)=A;
    A=Temp;
end
A0=A(:,:,1);A1=A(:,:,2);A2=A(:,:,3);A3=A(:,:,4);

B=[A0, -A1, -A2, -A3;...
   A1,  A0, -A3,  A2;...
   A2,  A3,  A0, -A1;...
   A3, -A2,  A1, A0];



