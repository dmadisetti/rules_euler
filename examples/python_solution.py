#!/usr/bin/env python3
""" Project Euler
Problem 1
=========


   If we list all the natural numbers below 10 that are multiples of 3 or 5,
   we get 3, 5, 6 and 9. The sum of these multiples is 23.

   Find the sum of all the multiples of 3 or 5 below 1000.


   Answer: e1edf9d1967ca96767dcc2b2d6df69f4
"""


def triangle(n):
    return n * (n + 1) // 2


def main():
    return (5 * triangle(999 // 5) + 3 * triangle(999 // 3) -
            15 * triangle(999 // 15))


if __name__ == "__main__":
    print(main())
