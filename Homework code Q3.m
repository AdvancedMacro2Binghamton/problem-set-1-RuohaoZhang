I=1.1235; %I is inflation rate comparing 2013 dollar and 2007 dollar
wealth=NETWORTH/I;
earn=(WAGEINC+BUSSEFARMINC)/I;
income=(WAGEINC+TRANSFOTHINC+SSRETINC+KGINC+INTDIVINC+BUSSEFARMINC)/I;
y=[0,1,5,10,20,40,60,80,90,95,99,100];
%calculate quantile
a=1;
while a<13
WEALTH_percentile(a) = wprctile(wealth,y(a),WGT)/1000;%wealth percentile,10^3
EARN_percentile(a) = wprctile(earn,y(a),WGT)/1000;%earning percentile,10^3
INCOME_percentile(a) = wprctile(income,y(a),WGT)/1000;%income percentile,10^3
a=a+1;
end
%coefficent of variation
wealth_var=sqrt(var(wealth,WGT))/(wealth'*WGT/sum(WGT))
income_var=sqrt(var(income,WGT))/(income'*WGT/sum(WGT))
earn_var=sqrt(var(earn,WGT))/(earn'*WGT/sum(WGT))
%gini index & lorenz curve by drop all the negative value
T=[WGT,earn,income,wealth];
a1=T(T(:,2)>=0,:);
a2=T(T(:,3)>=0,:);
a3=T(T(:,4)>=0,:);
figure
subplot(3,1,1)  
earn_gini=gini(a1(:,1),a1(:,2),true)
title(['Earning, gini=',num2str(earn_gini)])
subplot(3,1,2)
income_gini=gini(a2(:,1),a2(:,3),true)
title(['income, gini= ',num2str(income_gini)])
subplot(3,1,3)
wealth_gini=gini(a3(:,1),a3(:,4),true)
title(['wealth, gini= ',num2str(wealth_gini)])
%log variance by drop all the non-positive value
b1=log(T(T(:,2)>0,:));
b2=log(T(T(:,3)>0,:));
b3=log(T(T(:,4)>0,:));
V=var(b1,exp(b1(:,1)));
earn_log_var=V(2)
V=var(b2,exp(b2(:,1)));
income_log_var=V(3)
V=var(b3,exp(b3(:,1)));
wealth_log_var=V(4)
%calculte the Top 1% / lowest 40%, Location of mean (%) and Mean / median
A=[earn,income,wealth];
ratio=[1,1,1];
mean_location=[1,1,1];
wmean=[1,1,1];
wmedian=[1,1,1];
q=1;
while q<4
%order by income
[S,a]=sort(A(:,q));
weight_sort=WGT(a);
%cumulate income
g=weight_sort.*S;
% first 1 percent cumulated income
a1=round(sum(WGT)*0.01);
i=0;
c1=0;
while c1<a1
    c1=c1+weight_sort(end-i);
    i=i+1;
end
f1=sum(g((end-i):end));
% last 40 percent cumulated income
a2=round(sum(WGT)*0.4);
j=1;
c2=0;
while c2<a2
    c2=c2+weight_sort(j);
    j=j+1;
end
l40=sum(g(1:j));
%income ratio,Top 1% / lowest 40%
ratio(q)=f1/c1/(l40/c2);
%location of mean
wmean(q)=A(:,q)'*WGT/sum(WGT);%calculate weighted mean
k=1;
while S(k)<wmean(q)
        k=k+1;
end
mean_location(q) = sum(weight_sort(1:k))/sum(weight_sort);
%calculate weighted median
wmedian(q)=weightedMedian(A(:,q),WGT);
q=q+1;
end
ratio  %ratio is the Top 1% / lowest 40% ration for earning, income and wealth.
mean_location  %mean_location is the percentile location of mean
MM=wmean./wmedian  %MM is mean/median

