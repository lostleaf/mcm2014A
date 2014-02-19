function w=poisson(lambda)
la=1/lambda;Tmax=120;
i=1;T(1)=random('exponential',la);
while(T(i)<Tmax)
    T(i+1)=T(i)+random('exponential',la);
    i=i+1;
end
T(i)=Tmax;x=0:1:i;
w=[0, T];
end