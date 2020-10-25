function [cost] = compute_cost_pc(points, centroids)
  
  m = size (points, 1);
  NC = size (centroids, 1);
  cost = 0;
  
  #calculez minimul distantei de la fiecare punct la centroidul lui
  for i = 1:m
      pct = points(i,:);
      min_dist = norm (centroids(1,:) - pct);
      for k = 1:NC
        crt_dist = norm (centroids(k,:) - pct);
        
        if crt_dist < min_dist
          min_dist = crt_dist;
        endif
      
      endfor
      cost = cost + min_dist; #adun aceste distante
  endfor
  
endfunction