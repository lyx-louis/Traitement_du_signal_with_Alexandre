function S=Capon(sig,N,fech)
% sig :: signal entrée
% N :: taille de filtre
% fech : freq de echantionnage
Len=length(sig);
corrx=xcorr(sig,'biased');
corrx=corrx(Len:Len+N-1);
corrxtp=toeplitz(corrx);
corrxtpinv=inv(corrxtp);
S=zeros(fech,1);

for m=1:1:fech
   omega=-(m-1)*2*pi/fech;
   e=exp(i*(0:1:N-1)'*omega);
   S(m)=1/(e'*corrxtpinv*e);

end
