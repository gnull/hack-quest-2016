import Data.Char (ord, chr, isPrint)
import Data.List (sortBy)
import Data.Function (fix)
import Control.Applicative ((<$>), (<*>))
import Data.Maybe (fromMaybe)

uncons [] = Nothing
uncons (a:as) = Just (a, as)

g = fix (\k c a bs -> fromMaybe a $ k c <$> (flip c a <$> (fst <$> uncons bs)) <*> (snd <$> uncons bs))

t = toInteger

f s d (b, c) = let k = gcd ((t d - b) ^ 2) (t d * b ^ (1 + s `mod` 2)) == 1
                in (product [(t . fromEnum) k, t d, b], and [k, c, isPrint (chr d)])

test_str s = (.) snd $ g (f s . ord) =<< (,) (t s) . (\k -> (length k == s) && (k == sortBy (flip compare) k))

main = interact $ (\a -> if a then "Flag" else "Fuck you") . test_str 23

