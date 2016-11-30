function [IDX, isnoise]=clustering(temp,epsilon,MinPts)

    C=0;
	[m,n] = size(temp);
	IDX=zeros(m,n);
	visited=false(m,n);
	isnoise=false(m,n);
	
	for i=1:m
		for j=1:n

			if ~visited(i,j)
				visited(i,j) = true;
				
				Neighbors=RegionQuery(i,j);
				
				if numel(Neighbors)<MinPts
                isnoise(i,j)=true;
				else
					C=C+1;
					ExpandCluster(i,j,Neighbors,C);
				end

			end

		end
	end
	
	function ExpandCluster(i,j,Neighbors,C)
        IDX(i,j)=C;
        
        k = 1;
        while true
           [p,q] = Neighbors(k);
            
            if ~visited(p,q)
                visited(p,q)=true;
                Neighbors2=RegionQuery(p,q);
                if numel(Neighbors2)>=MinPts
                    Neighbors=[Neighbors Neighbors2];  
                end
            end
            if IDX(p,q)==0
                IDX(p,q)=C;
            end
            
            k = k + 1;
            if k > numel(Neighbors)
                break;
            end
        end
	end

	function Neighbors=RegionQuery(i,j)
        Neighbors=find(D(i,j,:)<=epsilon);
    end

end



