module Librairies.Data.List

export
replicate : (n : Int) -> (x : a) -> List a
replicate 0 _ = []
replicate n x = x :: replicate (n-1) x


