function [centroids] = clustering_pc(points, NC)

  m = size (points, 1);
  n = size (points, 2);

  clust = zeros (NC, m * n);
  centroids = zeros (NC, n);

  #initializez clusterele
  for i = 1:m
    clust_ind = mod (i, NC) + 1;
    for j = 1:n:(m * n)
      #verific daca am loc liber de adaugat un punct
      if clust(clust_ind,j) == 0
        for k = 0:(n - 1)
          #adaug fiecare coordonata a punctului pe rand
          clust(clust_ind,j + k) = points(i,k + 1);
        endfor
        break
      endif
    
    endfor
  endfor

  #parcurg inca o data si calculez centrele de masa ale clusterelor
  for i = 1:NC
    for k = 1:n
      nrpct = 0; #contor pentru numarul de puncte din cluster
      for j = 1:n:(m * n)
        
        if clust(i,j + k - 1) != 0
          nrpct = nrpct + 1;
        else
          break
        endif 
        #calculez suma punctelor
        centroids(i,k) = centroids(i,k) + clust(i,j + k - 1); 
      endfor
    endfor
    #fac media aritmetica
    centroids(i,:) = centroids(i,:) ./ nrpct;
  endfor

  #Aplic algoritmul
  while 1
    #Initializez o lista de puncte plina de 0
    lista_pct = zeros (NC, m * n);
    for i = 1:m
      #calculez minimul distantei de la punct la un centroid
      crt_pct = points(i,1:n);
      min_dist = norm (centroids(1,1:n) - crt_pct);
      cntr_ind = 0;
      
      for j = 1:NC
        crt_centr = centroids(j,1:n);
        crt_dist = norm (crt_centr - crt_pct);
        
        if(crt_dist <= min_dist)
          min_dist = crt_dist;
          cntr_ind = j; #pastrez indicele centroidului apropiat
        endif
      endfor 
    
      for k = 1:n:(m * n)
        #adaug punctul in lista corespunzatoare
        if lista_pct(cntr_ind,k) == 0
          for l = 0:(n - 1)
            lista_pct(cntr_ind,k + l) = points(i,l + 1);
          endfor
          break
        endif
    
      endfor
    endfor
    #initializez noii centroizi ca centrele de masa ale punctelor
    #din lista anterior construita  
    centroids_new = zeros (NC, n);

    for i = 1:NC
      for k = 1 : n
        nrpct = 0;
        for j = 1:n:(m * n)
        
          if lista_pct(i,j + k -1) != 0
            nrpct = nrpct + 1;
          else
            break;
          endif
        
          centroids_new(i,k) = centroids_new(i,k) + lista_pct(i,j + k - 1);
        endfor
      endfor
    
      centroids_new(i,:) = centroids_new(i,:) ./ nrpct;
    endfor

    #daca centroizii noi sunt aceeasi cu cei vechi, ies din bucla
    if centroids_new == centroids
      break
    endif
    
    centroids = centroids_new;

  endwhile

endfunction