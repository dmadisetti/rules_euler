{- Project Euler
Problem 2
=========


   Each new term in the Fibonacci sequence is generated by adding the
   previous two terms. By starting with 1 and 2, the first 10 terms will be:

                     1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

   By considering the terms in the Fibonacci sequence whose values do not
   exceed four million, find the sum of the even-valued terms.


   Answer: 4194eb91842c8e7e6df099ca73c38f28
-}

cond a
  | even a          = a
  | otherwise       = 0

fib :: Int -> Int -> Int
fib a b
  | a > 4000000      = cond a
  | otherwise        = cond a + fib b (a + b)

main :: IO ()
main = print $ fib 1 1