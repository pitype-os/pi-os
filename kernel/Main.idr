module Main

import Data.C.Ptr 
import Data.Linear.Ref1
import Syntax.T1
import Data.Vect

import Trap
import Uart
import Pages

import Data.Fin
import Data.Array.Index

fromToList : List Bits8 -> List Bits8
fromToList xs =
  withCArray (length xs) $ \r => T1.do
    writeVect r (fromList xs)

    case isLT 3 (length xs) of
      Yes prf => set r (natToFinLT 0) 50
      _ => pure ()

    v <- withIArray r toVect
    pure (toList v)

xs : List Bits8
xs = [1,2,3,4]

main : IO ()
main = do
  println "Welcome to PI-OS!"
  println "Initialize pages"
  let init_pages = pages
  println $ show $ fromToList xs
  println "Finish inialize pages"
  exit





