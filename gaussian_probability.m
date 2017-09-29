function probability = gaussian_probability(x,mean,covariance)
    
    u = mean;
    C = covariance;
    t = x - u;
    denominator = 2*pi*(det(C)^1/2);
    
    probability = 1/denominator * exp(-1/2 * t' * C^-1 * t);
    
end