import System.Environment (getArgs)

import Data.Char          (isAlpha, ord)
import Data.List          (group, sort)
import System.IO          (isEOF)
import Data.Monoid        ((<>))
import qualified Data.Foldable as F    

-- a safer version of getChar (from class)
getc :: IO (Maybe Char)
getc = do { eof <- isEOF
          ; if eof
              then return Nothing
              else 
                do { c <- getChar
                   ; return (Just c)
                   }
           }
    
-- To compile are on Unix-like systems
--     ghc --make ex7.hs  -o ex7
-- Be sure to uncomment the appropriate ``main = ...'' line.
------------------------------------------------------------------------
-- Problem 1

--main = csum1

csum1 :: IO ()
csum1 = do n <- cs1 0
           putStrLn $ "The check sum is "++show n

cs1 :: Int -> IO (Int)
cs1 n = do { mc <- getc
           ; case mc of
               Nothing -> return n
               Just c  -> cs1 ((n+ord c)`mod` 256)
           }

------------------------------------------------------------------------
-- Problem 2

main = csum2

csum2 :: IO ()
csum2 = do n <- cs2
           putStrLn $ "The check sum is "++show n

cs2 = do { (fpath:_) <- getArgs
         ; inp <- readFile fpath
         ; putStrLn $ "The check sum of "++fpath++" is "++show (length inp)
         }

------------------------------------------------------------------------
-- Problem 3

-- main = sumUp

sumUp = sumRec 0

sumRec n = do { inp <- getLine
              ; let m = (read inp::Float)
              ; if m==0.0 then return n else sumRec (m+n)  
              }

--main = sumUp'

sumUp' = do inp <- getContents
            putStrLn $ process inp
    where
      ans n    = "The sum is "++show n
      process  = ans .  sum . (takeWhile (/=0.0))
                 . map (\s-> (read s :: Float)) . lines    

------------------------------------------------------------------------
-- Probem 4

-- main = wc

wc = do { (fpath:_) <- getArgs
        ; inp <- readFile fpath
        ; putStrLn $ process inp
        }
    where
      gather xs@(x:_) = x++" "++show(length xs)
      process         = unlines . (map gather) . group . sort
                         . (map (filter isAlpha)) . words

------------------------------------------------------------------------
-- Problem 5

data BinTree a = Empty | Branch a (BinTree a) (BinTree a) deriving (Eq,Show)

instance Functor BinTree where
    fmap f Empty            = Empty
    fmap f (Branch x tl tr) = Branch (f x) (fmap f tl) (fmap f tr)

instance Foldable BinTree where
    foldMap f Empty            = mempty
    foldMap f (Branch x tl tr) = foldMap f tl <> (f x) <> foldMap f tr

-- A sample BST
t = foldr insrt Empty [3,5,6,32,2,7,9]  -- insrt defined below
t' = fmap (\n-> ((97*n) `mod` 256)) t   -- a jumbled version of t

------------------------------------------------------------
-- Part (a)
    
preord, inord, postord :: BinTree a -> [a]
preord Empty = []
preord (Branch x tl tr) = x:(preord tl)++(preord tr)
                        
inord Empty = []
inord (Branch x tl tr) = (inord tl)++[x]++(inord tr)

inord' t = foldMap (\x->[x]) t                         
                          
postord Empty = []
postord (Branch x tl tr) = (postord tl)++(postord tr)++[x]
                          
------------------------------------------------------------
-- Part (b)

isIncreasing :: (Ord a) => [a] -> Bool
isIncreasing [] = True
isIncreasing [x] = True
isIncreasing (x:y:ys) = (x<=y) && isIncreasing (y:ys)

isBst :: (Ord a) => (BinTree a) -> Bool
isBst = isIncreasing . inord

------------------------------------------------------------
-- Part (c)
        
-- (insrt n t) = the BST t with n inserted
insrt :: Int -> BinTree Int -> BinTree Int
insrt n Empty = Branch n Empty Empty
insrt n t@(Branch m tl tr)
    | n==m      = t
    | n<m       = Branch m (insrt n tl) tr
    | otherwise = Branch m tl (insrt n tr)

------------------------------------------------------------
-- Part (d)
        
postRebuild ::  [Int] -> BinTree Int
postRebuild xs = foldr insrt Empty xs

------------------------------------------------------------
-- Part (e)

preRebuild ::  [Int] -> BinTree Int
preRebuild xs = foldl (flip insrt) Empty xs
--preRebuild xs = foldl insrt Empty xs                 
------------------------------------------------------------
-- Part (f)

rebuild :: (Eq a) => [a] -> [a] -> (BinTree a)
rebuild [] []     = Empty
rebuild (c:cs) ds = Branch c (rebuild prelow inlow) (rebuild prehigh inhigh)
    where
      (inlow, (x:inhigh)) = break (==c) ds
      (prelow,prehigh)    = splitAt (length inlow) cs

tpre = preord t
tin  = inord  t

-- (tst t) tests rebuild on t, we assume t has no repeated values
tst t = (t == rebuild (preord t) (inord t))
       
