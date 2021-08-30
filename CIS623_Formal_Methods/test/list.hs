import Data.List
--P1
myLast x =  x !! (length x -1)
myLast' = head . reverse

--P2
myButLast x = x !! (length x - 2)
myButLast' = head . tail . reverse

--P3
elementAt x a = x !! (a-1)

--p4
myLength [] = 0
myLength (x:xs) = 1 + myLength xs

--myLength' =  foldl (\n _ -> n + 1) 0
--myLength'' =  foldr (\_ n -> n + 1) 0

--p5
myReverse [] = []
myReverse (x:xs) = reverse xs ++ [x]

--P6
isPalindrome [] = True
isPalindrome x = x == reverse x

--P7
data NestedList a = Elem a | List [NestedList a]
 
flatten :: NestedList a -> [a]
flatten (Elem x) = [x]
flatten (List x) = concatMap flatten x

flatten' (List (x:xs)) = flatten x ++ flatten (List xs)
flatten' (List []) = []

--P8
--compress (x:xs)
--	| x == head xs = compress xs
--	|otherwise = x:compress xs
--compress x = x 

compress (x:ys@(y:_))
  | x == y    = compress ys
  | otherwise = x : compress ys
compress ys = ys


--P9
--pack (x:ys@(y:_))
--   | x == y = x:[y] ++ pack ys
--  | otherwise = [x,y] ++ pack ys
--pack ys = ys
pack [] = []
pack (x:xs) = (x : takeWhile (==x) xs) : pack (dropWhile (==x) xs)
--pack' = foldr func []
 --   where func x []     = [[x]]
 --         func x (y:xs) =
 --             if x == (head y) then ((x:y):xs) else ([x]:y:xs)

--P10
encode [] = []
encode x = map (\x -> (length x, head x)) (group x)

encode' [] = []
encode' (x:xs) = (length $ x:takeWhile (==x) xs,x) : encode' (dropWhile (==x) xs)

--P11 Implement the group function
myGroup [] = []
myGroup (x:xs) = (x : takeWhile (==x) xs) : pack (dropWhile (==x) xs)

--P12 Implement the partition function
myPartition f xs = (first,second)
     where first = [x | x <-xs, f x == True]
           second = [x | x<-xs, f x == False]

--P13 split

--P14 qsort
qsort [] = []
qsort (h:t) = (qsort [x| x<-t, x < h]) ++ [h] ++ (qsort [x| x<-t, x>=h ])


--P26 combination
combinations 0 _  = [ [] ]
combinations n xs = [ y:ys | y:xs' <- tails xs
                           , ys <- combinations (n-1) xs']

--P27
combination 0 xs     = [([],xs)]
combination n []     = []
combination n (x:xs) = ts ++ ds
  where
    ts = [ (x:ys,zs) | (ys,zs) <- combination (n-1) xs ]
    ds = [ (ys,x:zs) | (ys,zs) <- combination  n    xs ]

group' [] = const [[]]
group' (n:ns) = concatMap (uncurry $ (. group' ns) . map . (:)) . combination n
