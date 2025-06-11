module Pi.Main

import Data.Array
import Data.Linear.Ref1

import Core.Monad
import Core.Pages
import PC.Trap
import PC.Uart

ontoPairs :
     List (Fin n, a)
  -> (m : Nat)
  -> {auto 0 p : LTE m n}
  -> (arr : MArray s n a)
  -> F1 s (List (Fin n, a))
ontoPairs xs 0 arr t = xs # t
ontoPairs xs (S k) arr t =
  let x     := natToFinLT k
      v # t := get arr x t
      in ontoPairs ((x,v) :: xs) k arr t

toPairs : {n : _} -> MArray s n a ->  F1 s (List (Fin n, a))
toPairs = ontoPairs [] n

count' : {n : _} -> List (Fin n) -> MArray s n Nat -> F1 s (List (Fin n, Nat))
count' []        arr t = toPairs arr t
count' (x :: xs) arr t =
  let v # t := get arr x t
      _ # t := set arr x (S v) t
   in count' xs arr t

countFins : {n:_} -> (List (Fin n)) -> (List (Fin n, Nat))
countFins xs = alloc n 0 (count' xs)

xs : List (Fin 2)
xs = [natToFinLT 1]

main : IO ()
main = runCore $ do
  println "Welcome to PI OS!"
  println "Initialize pages"
  let init_pages = pages
  println $ show $ countFins xs
  println "Finish inialize pages"
  exit



