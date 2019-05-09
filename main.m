addpath(genpath('bads-master'));
addpath(genpath('info-pack-master'));
result=[];
%% Input arguments: 
%                  [x,fval,exitflag,output] = bads(@fun,x0,lb,ub,plb,pub);
%                                         x0:Initialization parameters
%                                         lb:Upper bound of parameter search
%                                         ub:Low bound of parameter search
%                                         plb:Plausible upper bound of parameter search
%                                         pub::Plausible low bound of parameter search
% Output arguments: 
%                   x:Optimized parameters
%                   fval:Classification error rate of feature subset
%                   exitflag:Characteristics of termination iteration
%                   output:returns a structure OUTPUT
%% Coding information
% Editor:Xuesen Yang
% Institution: Shenzhen University
% E-mail:1348825332@qq.com
% Edit date:2019-3-4 
%% Sample
maxrun=30;
for r=1:maxrun
[x,fval,exitflag,output] = bads(@DT_FR,[0.1 20 5],[0 1 1],[1 50 10],[0 1 1],[1 50 10]);
result=[result;x,fval]
end
result(:,3)=round(result(:,3));
save('FRank','result')
%% recommend parameter for each dataset
%sonar:[0.1 20 5],[0 1 1],[1 50 10],[0 1 1],[1 50 10]
