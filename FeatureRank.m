function H1 = FeatureRank(X,alpha)
% The first kind of probability matrix L
L=abs(corr(X)); 
change_element=L<alpha;
L(change_element)=0; % remove edges which weighs less than θ
sum_low=sum(L,1)';
num_low=length(sum_low);
matrx=repmat(sum_low,1,num_low);
L=L./matrx;

%%  The second kind of probability matrix L
% L=abs(corr(X)); 
% change_element=L<alpha;
% L(change_element)=0; % remove edges which weighs less than θ
% change_element=L>=alpha;
% L(change_element)=1;
% L=L-diag(diag(L));
% sum_low=sum(L,1)';
% num_low=length(sum_low);
% matrx=repmat(sum_low,1,num_low);
% L=L./matrx;



%% Obtaining number of features 
N= size(L,2);     % N: total number of features
q= 0.85;          % Damping Coefficient,Default:0.85

d= sum(L,2);      % D is a column vector representing each feature
D= diag(d);       

M= L'*inv(D);    
e= ones(N,1);
a= (d==0);  

S= M + e*a'/N;   
% Constructing the Final Probability Transfer Matrix
G= q*S + (1-q)*e*e'/N;     



H0= zeros(N,1);  % Initialize H0
H1= ones(N,1);   % The default initial weight vectors are all 1
count= 0;        % Number of initialization iterations
% markov process
sigma=1e-10;
while  norm(H1-H0) >= sigma
    H0= H1;
    H1= G*H0;
    count= count+1;
end  

[Rank,index]= sort(H1,'descend');       
% Rank:  Save the final descending array
% index: Stores the ordinal number in the original array corresponding to the descending sort


% fprintf('After %d steps PageRank finally converges\n', count)
% fprintf('Rank               Weight              PageNumber\n')
% fprintf('-------------------------------------------------\n')
% for  k= 1:N
%     fprintf('%-3d                %-.7f            %-3d\n',...
%             k, Rank(k), index(k))
% end   % 
end  
