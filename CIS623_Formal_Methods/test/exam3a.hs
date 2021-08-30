import Parsing   {-- Hutton's Parsing Library: Parsing.hs --}
import Data.List (elemIndex)
import Data.Char
    
------------------------------------------------------------------------
-- Problem 1.

-- lengths :: IO [Int]
lengths = do cs <- getLine
             if (cs=="")
                then return []
                else do lines <- lengths
                        return ((length cs):lines)
                    
------------------------------------------------------------------------
-- Problem 2.

data Weight = Kilo Float | Lbs Float        deriving (Show)
                  
-- Part (a) ------------------------------------------------------------

toLbs (Lbs  x)  = x
toLbs (Kilo x)  = 2.02*x    

toKilo (Kilo x) = x
toKilo (Lbs  x) = x/2.02

instance Eq Weight where
    w1==w2  =  (toKilo w1)==(toKilo w2)

-- Part (b) ------------------------------------------------------------

instance Monoid Weight where
    mempty                = Kilo 0.0
    (Lbs x)  `mappend` w2 = Lbs (x + toLbs w2)
    (Kilo x) `mappend` w2 = Kilo (x + toKilo w2)

------------------------------------------------------------------------
-- Problem 3.

word = many1 (sat isLower)
num  = many1 (sat isDigit)
str  = word +++ num       

separate :: Parser ([String],[Int])
separate = do itms <- getItems
              return ([ s      | s <- itms , isLower (head s)]
                     ,[ read s | s <- itms , isDigit (head s)]
                     )
              
getItems = do s <- str
              ss <- many (char ',' >> str)
              return (s:ss)
------------------------------------------------------------------------
-- Problem 4.

data AList a = Emp | Single a | Append (AList a) (AList a) Int
               deriving (Show, Eq)

size :: (AList a) -> Int
size Emp            = 0
size (Single _)     = 1
size (Append _ _ s) = s

append :: (AList a) -> (AList a) -> (AList a)
append Emp  lst2 = lst2
append lst1 Emp  = lst1
append lst1 lst2 = Append lst1 lst2 ((size lst1)+(size lst2))

lst0 = Append (Single 'a') (Append (Single 'b') (Single 'c') 2) 3

-- Part (a) ------------------------------------------------------------

instance Functor AList where
    fmap f Emp                  = Emp
    fmap f (Single x)           = Single (f x)
    fmap f (Append lst1 lst2 s) = Append (fmap f lst1) (fmap f lst2) s

-- Part (b) ------------------------------------------------------------

isProper :: Eq a => AList a -> Bool
isProper (Append xs ys s)
           =    xs/=Emp
             && ys/=Emp
             && s == (size xs)+(size ys)
             && isProper xs
             && isProper ys
isProper _ = True                    

-- Part (c) ------------------------------------------------------------

fetch :: Int -> (AList a) -> (Maybe a)
fetch i xs | (i<0 || i >= size xs)  = Nothing
           | otherwise              = Just (get i xs)
                                     
get i (Single x)                    = x
get i (Append xs ys _) | i<ls       = get i xs
                       | otherwise  = get (i-ls) ys
    where ls = size xs
        
-- Part (d) ------------------------------------------------------------

delete :: Int -> (AList a) -> (AList a)
delete i xs | i<0 || i>=size xs     = xs
            | otherwise             = del i xs
                                  
del i (Single _)                    = Emp
del i (Append xs ys s) | i<ls       = append (del i xs) ys
                       | otherwise  = append xs (del i ys)
    where ls = size xs
