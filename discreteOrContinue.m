function discrete_dim=discreteOrContinue(train_features,thres_disc)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Determine whether the characteristics of a dimension are continuous values
    % train_features:      features of Training Sets
    % thres_disc:          Discrete feature threshold, > thres_disc is recognized as continuous range of feature values
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    fea=size(train_features,1);
    discrete_dim = zeros(1,fea);
    for i = 1:fea  % Traversing through each feature  
        Ub = unique(train_features(i,:)); 
        Nb = length(Ub);   
        if (Nb <= thres_disc)    
            discrete_dim(i) = Nb; % In the training sample, the number of non-repetitive eigenvalues of this feature is stored in discrete_dim(i), I denotes the first feature.  
        end    
    end
end
