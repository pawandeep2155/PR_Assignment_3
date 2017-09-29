% data = [6.5 7 0; 6 6 0; 8 9 0; 8.5 10 0;9.5 10 0; 8.5 9.5 0; 10 12 0];
% medoid = [6 6; 10 12];
% cluster = data;
% new_medoid = medoid;
% 
% for k = 1:5
%     [cluster,new_medoid] = k_medoid(cluster,2,new_medoid);
% end
% 
data1 = [6.5 7 0; 6 6 0; 8 9 0; 8.5 10 0;9.5 10 0; 8.5 9.5 0; 10 12 0];
mean = [6 6; 10 12];
cluster1 = data1;
new_mean = mean;

for k = 1:5
    [cluster1,new_mean] = k_mean(cluster1,2,new_mean);
end

[cov,pie] = compute_cov_pie(cluster1,2,new_mean);

[mean_new,cov_new,pie_new] = GMM(cluster1(:,1:size(cluster1,2)-1),new_mean,cov,pie,2); 








