function [clustered_data,mean_returned] = k_mean(input_data,num_of_clusters,mean_each_cluster)
    % Each row of input_data is of the form [x1,x2,rnk] where rnk shows the
    % cluster number to which this data row belongs.
    % mean_each_cluster is a matrix containing mean for each cluster.
    % num_of_clusters tells the total number of clusters.

    data = input_data;
    mean = mean_each_cluster;

    % compute eucledian distance of each point from the mean and rebuild
    % the cluster based on the distances from mean
    for index = 1:size(data,1)
        
        % Initialise min_distance_to_mean for each data point to infinite.
        min_distance_to_mean = realmax;
        
        for k = 1:num_of_clusters
            
            data_at_index = data(index,1:size(data,2)-1)';
            mean_cluster_k = mean(k,:)';
            euc_distance = calculate_eucledian_distance(data_at_index,mean_cluster_k);
            
            if(euc_distance < min_distance_to_mean)
                % Set the cluster number
                data(index,size(data,2)) = k;
                min_distance_to_mean = euc_distance;
            end

        end
    end
    
    % Recompute the mean for each cluster 
    % Reset mean to zero for calculating it from data points of new cluster
    mean = 0 * mean;
    % Keep track of number of points in each cluster
    points_in_cluster = zeros(num_of_clusters,1);
    
    for index=1:size(data,1)
        cluster_num = data(index,size(data,2));
        points_in_cluster(cluster_num,1) = points_in_cluster(cluster_num,1)+1;
        mean(cluster_num,:) = mean(cluster_num,:) + data(index,1:size(data,2)-1);
    end

    for k=1:num_of_clusters
        mean(k,:) = (1/points_in_cluster(k,1)) * mean(k,:);
    end
    
    clustered_data = data;
    mean_returned = mean;

end

function eucledian_distance = calculate_eucledian_distance(point1,point2)
    eucledian_distance = (point1-point2)'*(point1-point2);
end



