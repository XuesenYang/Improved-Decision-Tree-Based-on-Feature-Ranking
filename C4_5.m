function test_targets = C4_5(train_features, train_targets, test_features,pruning,thres_disc,Ranking)    
    
% pruning=35;
% thres_disc=10;
% if nargin>4
%     pruning=varargin{1};
%     thres_disc=varargin{2};
% elseif nargin>3
%     thres_disc=varargin{1};
% end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%training_features：features of training samples  
%training_targets： label of training samples  
%test_features：    features of test samples   
%pruning：          Pruning coefficient  
%thres_disc:        Discrete feature threshold，  >thres_disc   means feature values is continuous.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [fea, num]     = size(train_features); % num: size of training samples，  fea:total number of features  
    pruning    = pruning*num/100;  % Pruning  
        
    % Judging whether a feature of a dimension is discrete or continuous, 0 represents continuous feature
    discrete_dim =discreteOrContinue(train_features,thres_disc); 
        
    % Constructing Trees Recursively  
    % disp('Building tree')    
    tree= build_tree(train_features, train_targets,discrete_dim,0,pruning,Ranking);    
    save tree.mat tree;  
    % Add pessimistic pruning  
    % On the basis of fully growing decision tree, pruning sub-trees with poor classification effect 
    % after growth can reduce the complexity of decision tree and the influence of over-fitting.  
    % treeplot(tree);  
      
    % Predictive Test dataset   
    % disp('Classify test samples using the tree')    
    test_targets= predict(tree,test_features, 1:size(test_features,2), discrete_dim);    
