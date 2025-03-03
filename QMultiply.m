function y=QMultiply(A,x)

PA=OperatorP(A); 
Qx=OperatorQ(x);
Qy=PA*Qx;
y=OperatorQinv(Qy);


