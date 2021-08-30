import Data.List
import Data.Functor
import Data.Monoid
import Control.Applicative
import Control.Monad
import Parsing     

------------------------------------------------------------------------    
------------------------------------------------------------------------    
-- Problem 1
    
data Tree a = Empty | Fork (Tree a) a (Tree a) Int
              deriving (Show)

addTree :: (Ord a) => (Tree a) -> a -> (Tree a)
addTree Empty c          = Fork Empty c Empty 0
addTree (Fork tl d tr n) c
    | c<d       = Fork (addTree tl c) d tr (n+1)
    | otherwise = Fork tl d (addTree tr c) n

index :: (Ord a) => (Tree a) -> a -> Maybe Int
index Empty _ = Nothing
index (Fork tl x tr n) y
      | x==y      = Just n
      | y<x       = index tl y
      | otherwise = fmap (+(n+1)) (index tr y)

fetch :: (Tree a) -> Int -> Maybe a
fetch Empty _ = Nothing
fetch (Fork tl x tr n) i
    | (i==n)    = Just x
    | (i<n)     = fetch tl i
    | otherwise = fetch tr (i-(n+1))

rotRight, rotLeft :: (Tree a) -> (Tree a)
-- The variable names match the labels in Figure 1(b) in the write-up;
-- m is the left-count for p and n is the left-count for q.
rotRight (Fork (Fork a p b m) q c n) = Fork a p (Fork b q c (n-m-1)) m
rotLeft  (Fork a p (Fork b q c n) m) = Fork (Fork a p b m) q c (m+n+1)

reroot :: (Ord a) => (Tree a) -> a -> (Tree a)
reroot Empty y = Empty
reroot t@(Fork tl x tr n) y
    | (x==y)    = t
    | (y<x)     = rotRight (Fork (reroot tl y) x tr n)
    | otherwise = rotLeft  (Fork tl x (reroot tr y) n)


------------------------------------------------------------------------    
------------------------------------------------------------------------    
-- Problem 2

type Edge  = (Char,Trie)
data Color = W | B                   deriving (Show,Eq)
data Trie  = Node Color [Edge]       deriving (Show,Eq)

t0 = Node W
     [('a',Node B [('t',Node B [('e',Node B [])])]),
      ('m',Node W [('e',Node B []),
                   ('u',Node W [('d',Node B [])]),
                   ('y',Node B [])]),
      ('o',Node W [('n',Node B [('e',Node B [])]),
                   ('u',Node W [('t',Node B [])])]) ]
           
-- an empty Trie
tempty = Node W []

------------------------------------------------------------------------    

search :: String -> Trie -> Bool
search "" (Node clr _)    = (clr==B)
search (c:cs) (Node _ es) = case (lookup c es) of
                              Nothing  -> False
                              (Just t) -> search cs t

------------------------------------------------------------------------    
add :: String -> Trie -> Trie
add "" (Node _ es)       = Node B es
add (c:cs) (Node clr es) = Node clr (edgeAdd c cs es)

edgeAdd :: Char -> String -> [Edge] -> [Edge]
edgeAdd c cs [] = [(c,add cs tempty)]  -- Recall: tempty = Node W []
edgeAdd c cs (e@(d,t):es)
    | c==d      = (c,add cs t):es     -- revise the edge
    | otherwise = e:(edgeAdd c cs es) -- search onward

-- (build ss) builds a Trie with ss as its lexicon.
build :: [String] -> Trie
build ss = foldr add tempty ss
           
------------------------------------------------------------------------    
remove :: String -> Trie -> Trie
remove "" (Node _ es)       = Node W es
remove (c:cs) (Node clr es) = Node clr (edgeRm c cs es)

edgeRm :: Char -> String -> [Edge] -> [Edge]
edgeRm c cs [] = []
edgeRm c cs ((d,t):es)
    | c==d      = consEdge (c,remove cs t) es -- revise the edge
    | otherwise = (d,t):edgeRm c cs es        -- search onward
    where
      consEdge (c,Node W []) es = es          -- prune edges with empty trees
      consEdge (c,t)         es = (c,t):es

------------------------------------------------------------------------    
lexicon :: Trie -> [String]
lexicon (Node clr es) = [""| clr==B]++concatMap edgeLex es

edgeLex :: Edge -> [String]
edgeLex (c,t) = map (c:) (lexicon t)                        
               

------------------------------------------------------------------------    
------------------------------------------------------------------------    
-- Problem 3

-- See: http://www.seas.upenn.edu/~cis194/fall16/sols/08-functor-applicative.hs

------------------------------------------------------------------------    
------------------------------------------------------------------------    
-- Problem 4

-- See: http://www.cis.syr.edu/courses/cis623/code/Hutton/ParsingM.hs

------------------------------------------------------------------------    
------------------------------------------------------------------------    
-- Problem 5
-- Part (a) -- I did this part in class.
dyckA :: Parser Int
dyckA = do { n <- count; char '#'; return n }
count = do { char '['
           ; m <- count
           ; char ']'
           ; n <- count
           ; return $ max (m+1) n
           }
         +++ return 0


-- Part (b)
dyckB :: Parser (Int,Int,Int)
dyckB  = do { triple <- count'; char '#'; return triple }
count' = do { char '('
            ; (m1,m2,m3) <- count'
            ; char ')'
            ; (n1,n2,n3) <- count'
            ; return ( max (m1+1) n1, max m2 n2, max (m3+1) n3)
            }
         +++
         do { char '['
            ; (m1,m2,m3) <- count'
            ; char ']'
            ; (n1,n2,n3) <- count'
            ; return ( max m1 n1, max (m2+1) n2, max (m3+1) n3)
            }
         +++ return (0,0,0)

