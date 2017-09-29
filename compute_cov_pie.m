function [cov_return,pie_return] = compute_cov_pie(input_data,num_of_clusters,mean_input)
    % Each row of input_data is of the form [x1,x2,rnk] where rnk shows the
    % cluster number to which this data row belongs.
    data = input_data;
    k = num_of_clusters;
    mean = mean_input;
    
    cov = compute_covarience(data,k,mean);
    pie = compute_pie(data,k);
    
    cov_return = cov;
    pie_return = pie;
    
end

function covarience_return = compute_covarience(input_data,num_of_clusters,mean_input)
    
    data = input_data;
    mean = mean_input;
    k = num_of_clusters;
    covariance = zeros(k*(size(data,2)-1),size(data,2)-1);
    col_in_covariance = size(covariance,2);
    
    
    % Compute number of points in each cluster
    num_point_each_cluster = zeros(k,1);

    for index=1:size(data,1)
        
        data_at_index = data(index,size(data,2)-1)';
        cluster_num = data(index,size(data,2));
        
        mean_k = mean(cluster_num,:)';
        t = data_at_index - mean_k;
        
        covariance((cluster_num-1)*col_in_covariance+1:cluster_num*col_in_covariance,:) = (t * t') + covariance((cluster_num-1)*col_in_covariance+1:cluster_num*col_in_covariance,:);
        num_point_each_cluster(cluster_num,1) = 1 + num_point_each_cluster(cluster_num,1); 
        
    end

    % Cov = 1/N * (xk - u) (xk - u)'
    for k=1:num_of_clusters
        covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:) = 1/(num_point_each_cluster(k,1)) * covariance((k-1)*col_in_covariance+1:k*col_in_covariance,:);
    end
    
    covarience_return = covariance;
    

end

function pie_return = compute_pie(input_data,num_of_clusters)

    data = input_data;
    k = num_of_clusters;
    pie = zeros(k,1);
    
    for index = 1:size(data,1)
        pie(data(index,size(data,2)),1) = pie(data(index,size(data,2)),1) + 1;
    end
    
        % pie(k) = Nk/N; where Nk is number of points in cluster k and N is
        % total number of points in data.
        pie(:,1) = 1/size(data,1) * pie(:,1);

        pie_return = pie;

end