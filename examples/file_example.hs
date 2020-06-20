{- Project Euler
Problem 22
==========


   Using [1]names.txt, a 46K text file containing over five-thousand first
   names, begin by sorting it into alphabetical order. Then working out the
   alphabetical value for each name, multiply this value by its alphabetical
   position in the list to obtain a name score.

   For example, when the list is sorted into alphabetical order, COLIN, which
   is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. So,
   COLIN would obtain a score of 938 × 53 = 49714.

   What is the total of all the name scores in the file?


   Visible links
   1. names.txt
   Answer: f2c9c91cb025746f781fa4db8be3983f
-}

import System.IO
import Data.Monoid
import Data.Maybe
import Data.Char (ord)
import Data.List (sort)

extract_sum :: String -> Int
extract_sum = sum . zipWith rank [1..] . sort . map numerize . parse
  where
   rank i = (*) i . sum
   numerize = map ((+) (-64) . ord)
   parse = words . mapMaybe replace
     where
        replace n
          | n == ','      = Just ' '
          | bad           = Nothing
          | otherwise     = Just n
          where
            bad = getAny $ mconcat $ map (Any . (==) n) "[]\" "

main :: IO ()
main = do
  handle <- openFile "external/euler/files/names.txt" ReadMode
  contents <- hGetContents handle
  print $ extract_sum contents
  hClose handle
