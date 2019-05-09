function err=DT_FR(x)
% *************************
% …………………………………input………………………………………
% runtimes=30;
ErrorRate=zeros(1,runtimes);
    load('sonar.mat')
    X=data(:,1:end-1);
    Y=data(:,end);
% label_class=unique(Y);
% changerow=strcmp(Y,label_class(1));
% Y=changerow;    
    indices = crossvalind('Kfold',Y,10);
% cp = classperf(Y);
     result=zeros(10,1);
     Ranks = FeatureRank(X,x(1));
     for i = 1:10
         test = (indices == i); 
         train = ~test;
         test_targets = C4_5(X(train,:)',Y(train,:)',X(test,:)',x(2),x(3),Ranks);
         result(i)=sum(test_targets~=Y(test,1)')/size(test_targets,2);
     end
     err=mean(result);

% for i = 1:10
%     test = (indices == i); 
%     train = ~test;
%     tree = fitctree(X(train,:),Y(train,:));
%     class=predict(tree,X(test,:));
%     classperf(cp,class,test);
% end
% cp.ErrorRate
