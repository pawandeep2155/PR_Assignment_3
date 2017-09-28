function [clustered_data,medoid_returned] = k_medoid(input_data,num_of_clusters,medoid_each_cluster)
    % Each row of input_data is of the form [x1,x2,rnk] where rnk shows the
    % cluster number to which this data row belongs.
    % medoid_each_cluster is a matrix containing medoid for each cluster.
    % num_of_clusters tells the total number of clusters.

    data = input_data;
    medoid = medoid_each_cluster;

    % compute eucledian distance of each point from the medoid and rebuild
    % the cluster based on the distances from medoid
    for index = 1:size(data,1)
        
        % Initialise min_distance_to_medoid for each data point to infinite.
        min_distance_to_medoid = realmax;
        
        for k = 1:num_of_clusters
            
            data_at_index = data(index,1:size(data,2)-1)';
            medoid_cluster_k = medoid(k,:)';
            euc_distance = calculate_eucledian_distance(data_at_index,medoid_cluster_k);
            
            if(euc_distance < min_distance_to_medoid)
                % Set the cluster number
                data(index,size(data,2)) = k;
                min_distance_to_medoid = euc_distance;
            end

        end
    end
    
    % Recompute the medoid for each cluster.
    medoid = 0 * medoid;
    min_eucledian_for_each_medoid = realmax * ones(num_of_clusters,1);
    
    for i=1:size(data,1)
        
        max_eucledian_distance = 0;
        
        for j=1:size(data,1)
            % Check eucledian distance of each point with all other points
            % in that cluster.
            xi_cluster = data(i,size(data,2));
            xj_cluster = data(j,size(data,2));
            
            if(xi_cluster == xj_cluster)
                xi = data(i,1:size(data,2)-1)';
                xj = data(j,1:size(data,2)-1)';
                euc_distance = calculate_eucledian_distance(xi,xj);
                if(euc_distance > max_eucledian_distance)
                        max_eucledian_distance = euc_distance;
                end
            end
        end
                    
          if(max_eucledian_distance < min_eucledian_for_each_medoid(xi_cluster,1))
              medoid(xi_cluster,:) = xi';
              min_eucledian_for_each_medoid(xi_cluster,1) = max_eucledian_distance;
          end
          
    end

    clustered_data = data;
    medoid_returned = medoid;

end

function eucledian_distance = calculate_eucledian_distance(point1,point2)
    eucledian_distance = (point1-point2)'*(point1-point2);
end



