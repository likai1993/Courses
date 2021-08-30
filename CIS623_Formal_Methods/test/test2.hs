group' (x:xs) | x == head xs = x:head xs : group' tail xs
	      | otherwise = concat x : group' xs	
