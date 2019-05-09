function targets = predict(tree,test_features, indices, discrete_dim)       
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calling C4.5 Decision Tree to Predict Test Samples
% tree：              Decision Tree Established by C4.5 Algorithms 
% test_features：     features of test samples 
% indices：           Indexes
%discrete:            Whether the features of each dimension are continuous values or not, 0 means continuous values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


targets = zeros(1, size(test_features,2)); 
        
if (tree.feature_tosplit == 0)  
    targets(indices) = tree.child;  % The label corresponding to the sample is tree.child  
    return    
end    
        
feature_tosplit = tree.feature_tosplit;  % Obtain the splitting characteristics 
dims= 1:size(test_features,1);  % Get the feature index  
        
% Classification of test samples based on the decision tree  
if (discrete_dim(feature_tosplit) == 0) %If the current splitting feature is a continuous feature 
    in= indices(find(test_features(feature_tosplit, indices)<= tree.location));  
    targets= targets + predict( tree.child(1),test_features(dims, :), in,discrete_dim(dims)); 
    in= indices(find(test_features(feature_tosplit, indices)>tree.location)); 
    targets= targets + predict(tree.child(2),test_features(dims, :),in,discrete_dim(dims));   
else  %If the current splitting feature is a discrete feature  
    Uf= unique(test_features(feature_tosplit,:)); %The non-repetitive eigenvalues of this feature in the sample set are obtained.  
    for i = 1:length(Uf)  %Traversing through each eigenvalue 
        if any(Uf(i) == tree.value)  %Tree. Nf is the classified feature vector of the tree. The eigenvalues of this feature of all current samples  
            in= indices(find(test_features(feature_tosplit, indices) == Uf(i)));  %Find the sample index with the eigenvalue== split value of this feature in the current test sample  
            targets = targets + predict(tree.child(find(Uf(i)==tree.value)),test_features(dims, :),in,discrete_dim(dims));% Bifurcation of these sample 
        end    
    end    
end 
