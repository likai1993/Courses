import Data.List (elemIndex)
import Parsing   {-- Hutton's Parsing Library: Parsing.hs --}

    
------------------------------------------------------------------------
-- Problem 1

newtype Angle = Angle { getAngle :: Int }
    deriving (Show)

instance Eq Angle where
    Angle a1 == Angle a2 = mod (a1-a2) 360 == 0

instance Ord Angle where
    Angle a1 <= Angle a2 = mod a1 360 <= mod a2 360
                           
instance Monoid Angle where
    mempty = Angle 0
    mappend (Angle a1)  (Angle a2) = Angle ((a1+a2) `mod` 360)


------------------------------------------------------------------------
-- Problem 2

newtype Priority = Priority { getPriority :: Int }
    deriving (Show)

instance Eq Priority where
    (Priority x)==(Priority y) = (max 0 x)==(max 0 y)

instance Ord Priority where
    (Priority x)<=(Priority y)  = (max 0 x)<=(max 0 y)    

instance Monoid Priority where
    mempty                              = Priority 0
    (Priority x) `mappend` (Priority y) = Priority (max 0 (max x y))

------------------------------------------------------------------------
-- Problem 3

add3 ma mb mc = do { a <- ma
                   ; b <- mb
                   ; c <- mc
                   ; return (a+b+c)
                   }
-- or 
add3' ma mb mc = (\a b c->a+b+c) <$> ma <*> mb <*> mc

------------------------------------------------------------------------
-- Problem 4


fun1, fun2, fun3 :: String -> IO ()
fun1 xs = foldr (>>) (return ()) (map putChar xs) >> putChar '\n'
-- equivalent to: putStrLn xs
fun2 xs = foldl (>>) (return ()) (map putChar xs) >> putChar '\n'
-- equivalent to: putStrLn xs
fun3 xs = foldr (flip(>>)) (return ()) (map putChar xs) >> putChar '\n'         -- equivalent to: putStrLn (reverse xs)
-- reverse xs = foldl (flip(:)) [] xs             
------------------------------------------------------------------------
-- Problem 5

hexdigits = "0123456789ABCDEF"

hex = do { string "0x"
         ; ns <- many (sat (`elem` hexdigits))
         ; return (convert ns)
         }

convert :: String -> Int
convert cs = foldl (\x y->16*x+convertDigit y) 0 cs

convertDigit d = i
    where (Just i) = elemIndex d hexdigits

square (Just x) = (Just (x * x))

convertDDight c = j
    where j =square( elemIndex c hexdigits)

------------------------------------------------------------------------
-- Problem 6
data CTree = Empty | Branch Char CTree CTree
           deriving (Eq,Show)

parseTree = do { c <- item
               ; if (c=='.')
                 then return Empty
                 else do { tl <- parseTree
                         ; tr <- parseTree
                         ; return (Branch c tl tr)
                         }
               }
            <|> return Empty
-- Try:  parse parseTree "ab..cd..."
