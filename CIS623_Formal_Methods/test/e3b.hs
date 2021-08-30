import Parsing
-- Sample answers for Exam 3b

import Data.Char
import Data.List    
    
------------------------------------------------------------------------
-- Problem 1.

tritext cs = do putStrLn cs
                if (cs=="")
                   then return ()
                   else tritext (tail cs)
-- or

tritext' ""     = putStrLn ""
tritext' (c:cs) = putStrLn (c:cs) >> tritext' cs

-- or

tritext'' = putStrLn . unlines . tails

------------------------------------------------------------------------
-- Problem 2.

data Mass = M Int Int         deriving (Show)


toGrams (M a b) = a*1000+b
                  
-- Part (a) ------------------------------------------------------------

instance Eq Mass where
    m1 == m2 = (toGrams m1)==(toGrams m2)

-- Part (b)  ------------------------------------------------------------

instance Monoid Mass where
    mempty  = M 0 0
    m1 `mappend` m2 = M k g
        where (k,g) = divMod (toGrams m1 + toGrams m2) 1000

------------------------------------------------------------------------
-- Problem 3.

var = many1 (sat isLower)
num = int
def = do v <- var
         char '='
         n <- num
         return (v,n)

defs = do d <- def
          ds <- many (char ';' >> def)
          return (d:ds)

------------------------------------------------------------------------
-- Problem 4.

data FPQ a = Finger a Int | Join (FPQ a) (FPQ a) Int
             deriving (Eq,Show)

getMaxPri (Finger _ p) = p
getMaxPri (Join _ _ p) = p

join q1 q2 = Join q1 q2 (max (getMaxPri q1) (getMaxPri q2))

q0 = Join (Finger 'a' 3) (Join (Finger 'b' 4) (Finger 'c' 2) 4) 4
             
-- Part (a) ------------------------------------------------------------

isProper (Join q1 q2 p) =    p == max (getMaxPri q1) (getMaxPri q2)
                          && isProper q1
                          && isProper q2
isProper _              = True
             
-- Part (b) ------------------------------------------------------------

instance Functor FPQ where
    fmap f (Finger x p)   = Finger (f x) p
    fmap f (Join q1 q2 s) = Join (fmap f q1) (fmap f q2) s

-- Part (c) ------------------------------------------------------------

getMax (Finger x _)                     = x
getMax (Join q1 q2 p) | p==getMaxPri q1 = getMax q1
                      | otherwise       = getMax q2                        

-- Part (d) ------------------------------------------------------------

deleteMax (Finger x _)                     = Nothing
deleteMax (Join q1 q2 p) | p==getMaxPri q1 = join' (deleteMax q1) q2
                         | otherwise       = join' (deleteMax q2) q1

join' Nothing q2   = Just q2
join' (Just q1) q2 = Just (join q1 q2)
