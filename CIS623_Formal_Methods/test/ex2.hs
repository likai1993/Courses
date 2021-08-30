------------------------------------------------------------------------
-- The binary tree data type

data BTree a = Emp | Branch a (BTree a) (BTree a)    deriving (Show)

tb :: BTree Char
tb = Branch 't' (Branch 'w' Emp (Branch 'e' Emp Emp))
                (Branch 'a' Emp Emp)
                
------------------------------------------------------------------------
-- The multiway tree data type

data MTree a = Fork a [(MTree a)]    deriving (Show)

tm :: MTree Int
tm = Fork 0 [Fork 8 [Fork 4 [],Fork 7 []],
             Fork 9 [],
             Fork 2 [Fork 5 [],Fork 3 [], Fork 1 []]]                      

------------------------------------------------------------------------     
-- Definitions for Exam 2a, Problem 1

someFun ::  [a] -> Int
someFun (x:xs) = 1
someFun _      = 0

g, h, k :: Int -> Int
g x = x * 10
h y = y + 3
k = g . h

data Person
      = Ninja Int
      | Pirate String Float
      | Dentist String
      deriving (Eq,Show)

-- + the definition of Maybe               

foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' s z []     = z
foldr' s z (x:xs) = s x (foldr' s z xs)

------------------------------------------------------------------------
-- Exam 2a, Problem 1

-- Expression                         Type
aa = ("voles",[True,False])     -- :: ([Char], [Bool])
ab = map someFun                -- :: [[a]] -> [Int]
ac = Just . someFun             -- :: [a] -> Maybe Int
ad = [g,k,h]                    -- :: [Int -> Int]
ae = Pirate "Jenny"             -- :: Float -> Person
af = foldr' map                 -- :: [a] -> [a -> a] -> [a]
{- Grading Notes
* Be kind on c, if the answer is semisane (e.g., Maybe is involved), 
  give 1/2.
* Be strict on f, those two points are supposed to be hard to get.
-}

     
------------------------------------------------------------------------     
-- Definitions for Exam 2b Problem 1 (with some primes added)

g', h', k' :: Int -> Int
g' x = x * 10
h' y = y + 3
k' = g' . h'
    
someFun' ::  a -> Int -> Int
someFun' x r = 3+g(r)

data Drink
      = Coffee String Float
      | Tea String
      | Absinthe Float
      deriving (Eq,Show)

-- + the definitions of foldr and Either               

------------------------------------------------------------------------
-- Exam 2b, Problem 1

-- Expression                         Type
ba = (7==9,['k'])               -- :: (Bool, [Char])
bb = foldr' someFun'            -- :: Int -> [a] -> Int
bc = Left . g                   -- :: Int -> Either Int b
bd = Coffee "Strong"            -- :: Float -> Drink
be = (g,someFun' [])            -- :: (Int -> Int, Int -> Int)
bf = map map                    -- :: [a -> b] -> [[a] -> [b]]

{- Grading Notes
* Be a little kind on b and very kind on c.
* Be strict on f, those two points are supposed to be hard to get.
-}
------------------------------------------------------------------------
-- Exam 2a, Problem 2

allRec, allFold :: (a -> Bool) -> [a] -> Bool
allRec f []     = True
allRec f (x:xs) = (f x) && allRec f xs

allFold f xs = foldr (\x r -> f x && r) True xs

{- Grading Notes
a. * 2 points for the base case
   * If they write something silly like  f x == True,  x-out the ``==True'',
     but no point off.
   * Having the right form of the answer is worth a point or two even
     if the rest is nonsense
b. * They may include an unneed base case, but if that is the only  
     thing they get right, give them a point.
   * Having the right form of the answer (e.g., the foldr expression
     is close to the right type) is worth a point or two.
-}
------------------------------------------------------------------------
-- Exam 2b, Problem 2

anyRec, anyFold :: (a -> Bool) -> [a] -> Bool
anyRec f []     = False
anyRec f (x:xs) = (f x) || anyRec f xs

anyFold f xs = foldr (\x r -> f x || r) False xs

{- Grading Notes
a. * 2 points for the base case
   * If they write something silly like  f x == True,  x-out the ==True,
     but not point off.
   * Having the right form of the answer is worth a point or two even
     if the rest is nonsense
b. * They may include an unneed base case, but if that is the only  
     thing they get right, give them a point.
   * Having the right form of the answer (e.g., the foldr expression
     is close to the right type) is worth a point or two.
-}

------------------------------------------------------------------------
-- Exams 2a and 2b, Problem 3

sublist []     _      = True
sublist _      []     = False
sublist (c:cs) (d:ds) = (c==d) && sublist cs ds || sublist (c:cs) ds

{- Grading Notes
* 2 points for the (sublist [] _  = ...) base case
* 2 points for the (sublist _  [] = ...) base case
-}

------------------------------------------------------------------------
-- Exam 2a, Problem 4

countBranches Emp              = 0
countBranches (Branch _ tl tr) = 1 + countBranches tl + countBranches tr

countForks (Fork a ts) = 1+sum(map countForks ts)                              

{- Grading Notes
* Take a point off if they use nonsense elements of the data types,
  E.g.:  countForks [] XXXX
         countBranches a tl tr XXXX
* Part a: The base case is worth 2 points. 
* Part a: -3 points if they forget the 1+ in the rec case
* Part b: If they include (unnecessary) base case that is wrong, 
          take off up to 2 points. 
* Part b: -3 points if they forget the 1+ in the rec case
* Part b: -4 points if they forget to sum the results of the rec calls
* Part b: -4 points if they mess up the rec calls
* Part b: If they mess up both the sum + recursion, you can be kinder than
          taking off 8 points.
* If they have the basic structure down, but miss everything else,
  give then a few points.
-}
------------------------------------------------------------------------
-- Exam 2b, Problem 4

listLabels Emp                = []
listLabels (Branch lab tl tr) = lab:(listLabels tl ++ listLabels tr)

listLabels' (Fork lab ts)     = lab:concatMap listLabels' ts                                
{- Grading Notes
* Take a point off if they use nonsense elements of the data types,
  E.g.:  countForks [] XXXX
         countBranches a tl tr XXXX
* Part a: The base case is worth 2 points. 
* Part a: -3 points if in (countBranches (Branch x tl tr)) 
          they forget the (x:)
* Part b: If they include (unnecessary) base case that is wrong, 
          take off up to 2 points. 
* Part b: -3 points if they forget the (x:) in the rec case
* Part b: upto -6 points depending on how badly the mess up the 
          recursive case. 
* If they have the basic structure down, but miss everything else,
  give then a few points.
-}
------------------------------------------------------------------------
-- Exam 2a, Problem 5

level :: Int -> (BTree a) -> [a]
level n _ | n<0          = []
level n Emp              = []
level 0 (Branch a _ _)   = [a]
level n (Branch _ tl tr) = level (n-1) tl ++ level (n-1) tr

level' :: Int -> (MTree a) -> [a]
level' n _ | n<0         = []
level' 0 (Fork a _)      = [a]
level' n (Fork _ ts)     = concatMap (level' (n-1)) ts

{- Grading Notes
* Part a: 1 point for each base of the three base cases
* Part a: If they have a (1+) in the rec case, -2 points
* Part b: 1 point for each base of the two base cases
* Part b: if they mess up the recursive case, give them some
          partial credit for getting parts sorta right
-}
------------------------------------------------------------------------
-- Exam 2b, Problem 5

nlevel :: Int -> (BTree a) -> Int
nlevel n _ | n<0          = 0
nlevel n Emp              = 0
nlevel 0 (Branch a _ _)   = 1
nlevel n (Branch _ tl tr) = nlevel (n-1) tl + nlevel (n-1) tr

nlevel' :: Int -> (MTree a) -> Int
nlevel' n _ | n<0         = 0
nlevel' 0 (Fork a _)      = 1
nlevel' n (Fork _ ts)     = sum (map (nlevel' (n-1)) ts)

{- Grading Notes
* Part a: 1 point for each base of the three base cases
* Part a: If they have a (1+) in the rec case, -2 points
* Part b: 1 point for each base of the two base cases
* Part b: if they mess up the recursive case, give them some
          partial credit for getting parts sorta right
-}
------------------------------------------------------------------------
-- Exams 2a and 2b, Problem 6

makeTrees 0 = [Emp]
makeTrees n = [Branch () t1 t2 | i  <-[0..n-1],
                                 t1 <- makeTrees i,
                                 t2 <- makeTrees (n-i-1)]
              
{- Grading Notes
* 1 point for the [Emp] base case
* 1 point if there is an attempt as a recursion that 
  makes some sort of sense.
* Every other point they have to earn. 
-}
