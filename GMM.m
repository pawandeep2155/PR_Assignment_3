function [mean_new,covariance_new,pie_new] = GMM(input_data,mean_input,covariance_input,pie_input,num_of_clusters)
    % Input matrix contains data points. Each row of input matrix looks
    % like [x1 x2 ...xd] where x1,x2...xd means data point in d dimension.
    % Mean matrix contains mean for each cluster. 
    % Covariance matrix contains covariance matrices concatenated vertically of each clusters.
    % pie is a vector containing πk value for each cluster.
    % num_of_clusters is a scalar value telling total number of clusters.
    data = input_data;
    mean = mean_input;
    covariance = covariance_input;
    pie = pie_input;
    
    %% Estimation Step of GMM
    data_points = size(data,1);
    
    % Responsibility matrix contains responsibility of each cluster for each
    % data point where element at index i,j shows responsiblity of data point i by cluster j. 
    responsibility = zeros(data_points,num_of_clusters);
    
    for index = 1:data_points
        
        responsibility_of_point = 0;
        data_at_index = data(index,:)';
        
        for k = 1:num_of_clusters
            
            % extract mean of cluster k.
            mean_k = mean(k,:)';
            
            % extract covariance matrix for cluster k from covariance
            % matrix given as input.
            col_in_covariance = size(covariance,2);
            cov_k = covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:);
            
            % Compute γ(Znk) for each data point corresponding to each
            % cluster.
            gaussian_prob = gaussian_probability(data_at_index,mean_k,cov_k);
            responsibility_of_point = responsibility_of_point + pie(k) * gaussian_prob;
            responsibility(index,k) = pie(k) * gaussian_prob;
        end
            
            responsibility(index,:) = (1/responsibility_of_point) * responsibility(index,:);
        
    end

    
    %% Maximization Step of GMM
    
    % Compute Nk i.e responsibility of each cluster
    % responsibility_clusters vector contain responsiblity of each cluster
    % for all of it's data points.
    responsibility_cluster = zeros(num_of_clusters,1);
    % Reseet mean,covariance and piek for all clusters, as we have to
    % recompute them again.
    mean = 0*mean;
    covariance = 0*covariance;
    pie = 0*pie;
    
    for k = 1:num_of_clusters
        for index = 1:data_points
            responsibility_cluster(k) = responsibility_cluster(k) + responsibility(index,k);
        end
    end
    
    % Compute new mean,covariance for each cluster
    for k=1:num_of_clusters
        for index=1:data_points
            mean(k,:) = mean(k,:) + responsibility(index,k) * data(index,:);
            
            t = data(index,:)' - mean(k,:)';
            covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:) = responsibility(index,k) * (t * t') + covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:);
        end
        mean(k) = mean(k)/responsibility_cluster(k);
        covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:) = covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:) / responsibility_cluster(k);     
    end
    
    % Compute piek for each cluster.
    for k = 1:num_of_clusters
        pie(k) = responsibility_cluster(k)/data_points;
    end

    %% Return the mean,covariance,pie
    mean_new = mean;
    covariance_new = covariance;
    pie_new = pie;
    
end





