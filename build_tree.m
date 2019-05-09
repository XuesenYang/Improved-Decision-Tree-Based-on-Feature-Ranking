function tree = build_tree(train_features, train_targets, discrete_dim, layer,pruning,Ranks)    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calling C4.5 Decision Tree Algorithms to Establish Decision Tree
% training_features：   features of training samples  
% training_targets：    label of training samples  
% discrete_dim：        Whether the features of each dimension are continuous features or not, 0 means continuous features  
% layer:                Number of layers of trees to which nodes belong
% tree:                 Structure of Decision Tree 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
% if nargin>5
%     pruning=varargin{1};
% else
%     pruning=35;
% end
        
[fea, L]= size(train_features);  
ale= unique(train_targets);  
tree.feature_tosplit= 0;  
tree.location=inf;  % The initialization splitting location is inf  
        
if isempty(train_features)   
    return    
end    
           
if ((pruning > L) || (L == 1) ||(length(ale) == 1)) %If the remaining training sample is too small (less than pruning), or only one, or only one label, exit.    
    his= hist(train_targets, length(ale));  %Statistical sample labels, which belong to the number of labels  
    [~, largest]= max(his); 
    tree.value= [];    
    tree.location  = [];    
    tree.child= ale(largest);
    return    
end    
         
for i = 1:length(ale) % Number of traversal discriminant Tags   
    Pnode(i) = length(find(train_targets == ale(i))) / L; 
end   

% Compute Information Entropy of Current Node
Inode = -sum(Pnode.*log2(Pnode));    
        
el= zeros(1, fea);  % Record each feature information gain ratio  
location= ones(1, fea)*inf;
   
for i = 1:fea % Traversing through each feature    
    data= train_features(i,:); 
    pe= unique(data);    
    nu= length(pe);   
    if (discrete_dim(i)) % If Discrete characteristics  
        el(i) = Ranks(i); %feature ranking rate   
    else   % Or Continuous feature
        node= zeros(length(ale), 2);
        [sorted_data, indices] = sort(data);
        sorted_targets = train_targets(indices);
        % Computate Split Information Metrics 
         I = zeros(1,nu);  
         spl= zeros(1, nu);  
         for j = 1:nu-1  % The feature i has Nbins continuous values, set Nbins-1 possible segmentation points, and calculate the information gain rate for each segmentation point.
             node(:, 1) = hist(sorted_targets(find(sorted_data <= pe(j))) , ale);  
             node(:, 2) = hist(sorted_targets(find(sorted_data > pe(j))) , ale);   
             Ps= sum(node)/L; 
             node= node/L; 
             rocle= sum(node);    
             P1= repmat(rocle, length(ale), 1); 
             P1= P1 + eps*(P1==0);    
             info= sum(-node./P1.*log(eps+node./P1)/log(2)); %information gain
             I(j)= Inode - sum(info.*Ps);   
             spl(j) =I(j)/(-sum(Ps.*log(eps+Ps)/log(2)));  % Information Gain Rate of the j Segmentation Point
         end  
  
       [~, s] = max(I);  % Find the Maximum Information Gain Rate of All Segmentation Points
       el(i) = Ranks(i);
       location(i) = pe(s);  % The partition position of corresponding feature i is the partition value which can maximize the information gain.
   end    
end    
        
% Find the features that are currently used as splitting features  
[~, feature_tosplit]= max(el); 
dims=1:fea;   
Ranks(feature_tosplit)=0;
tree.feature_tosplit= feature_tosplit;  % Record feature as split of the tree  
        
value= unique(train_features(feature_tosplit,:)); 
nu= length(value);
tree.value = value;  %  
tree.location = location(feature_tosplit);  %
           
if (nu == 1)   
    his= hist(train_targets, length(ale));
    [~, largest]= max(his); 
    tree.value= []; 
    tree.location  = [];    
    tree.child= ale(largest); 
    return    
end    
        
if (discrete_dim(feature_tosplit))    
    for i = 1:nu     
        indices= find(train_features(feature_tosplit, :) == value(i));
        tree.child(i)= build_tree(train_features(dims, indices), train_targets(indices), discrete_dim(dims), layer, pruning,Ranks);  
    end    
else
    
% If the feature currently selected as splitting feature is a continuous feature
indices1= find(train_features(feature_tosplit,:) <= location(feature_tosplit));  % Indicators for finding samples with eigenvalues <= split values  
indices2= find(train_features(feature_tosplit,:) > location(feature_tosplit));
  if ~(isempty(indices1) || isempty(indices2))  % If the number of samples with <= splitting value > splitting value is not equal to 0   
      tree.child(1)= build_tree(train_features(dims, indices1), train_targets(indices1), discrete_dim(dims),layer+1, pruning,Ranks);
      tree.child(2)= build_tree(train_features(dims, indices2), train_targets(indices2), discrete_dim(dims),layer+1, pruning,Ranks);   
  else    
      his= hist(train_targets, length(ale));  % The number of labels in each label is counted for each sample. 
      [~, largest]= max(his);
      tree.child= ale(largest);   
      tree.feature_tosplit= 0;   
  end    
end 
