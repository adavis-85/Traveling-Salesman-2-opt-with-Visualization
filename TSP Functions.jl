function hypotenuse(x)
    
       right=(x[1][1]-x[2][1])^2
       left=(x[1][2]-x[2][2])^2
       return(sqrt(right+left))
       end

##Takes in a list of points starting at whichever is desired.  For demonstration purposes
##the beginning point is at the origin (0,0).  Then calculates the distance from each individual
##point to all others 
##for example for three points:
## 0->1
## 0->2
## 0->3
##would be the first row with the row beginning at the distance of the point to itself 
##which would be zero.

function distance_matrix(list)
              new=Tuple{Int,Int}[]
              for i in 1:length(list)
              push!(new,(list[i]))
              end
               list=new
              n=length(list)
              mat=zeros(n,n)
              for i in 1:n
              for j in 1:n
              t=(list[i],list[j])
              mat[i,j]=hypotenuse(t)
              end
              end
    for i in 1:n
        mat[i,i]=Inf
    end
              return mat
              end

##The node amount is of the users choosing unless a distance matrix is provided.
node_amount=200
first_point=rand(1:10,node_amount)
second_point=rand(1:10,node_amount)
point_list=Tuple{Int,Int}[]

for i in 1:length(first_point)
    push!(point_list,(first_point[i],second_point[i]))
end

##Now the matrix with the starting location being the origin.
Distances=distance_matrix(point_list)

#Can be any path starting and ending at the same location/node.
visited=arbitrary_path

##This function calculates the cost of a path accoring to the distance matrix.
function path_cost_from_distance_matrix(dist_m,path)
    
    cost=0
    for i in path
        cost+=dist_m[path[i],path[i+1]]
    end
    
    return cost
end

##Swapping action of the 2-opt algorithm
function two_opt_change(route, first, second) 
    
    new_route=zeros(length(route))
    
    new_route[1:first]=route[1:first]
    
    new_route[first+1:second]=reverse(route[first+1:second])
  
    new_route[second+1:end]=route[second+1:end]
    
    return Int.(new_route)
end

##2-opt algorithm

function two_opt(path)
    new_distance=Inf
    best_distance = path_cost_from_distance_matrix(Distances,path)
    existing_route=path

   for k in 1:10000
        for i in 1:length(path)-2
            
            for j in i+1:length(path)-1
                
                new_route = two_opt_change(present_route,i,j)
                
                new_distance = path_cost_from_distance_matrix(Distances,new_route)
                diff=abs(best_distance-new_distance)
                if (new_distance < best_distance) 
                    println(new_distance)
                    present_route = new_route
                    best_distance = new_distance
                end
            end
        end
    end
        return best_distance,existing_route
end

##2-opt call
opt_dist,best_path=two_opt(visited)

##Collects vertices from original point list/node location.
function graphing_path(path)
    
    x=[]
    y=[]
    
    push!(x,point_list[path[1]][1])
    push!(y,point_list[path[1]][2])
    
    for i in 2:length(path)-1
        push!(x,point_list[path[i]][1])
        push!(y,point_list[path[i]][2])
    end
    
    push!(x,point_list[path[1]][1])
    push!(y,point_list[path[1]][2])
    
    return x,y
end

##Visualize graph to check optimality.
scatter(point_list)
x,y=graphing_path(best_path)
plot!(x,y,legend=false)
