module Pages

import Data.List
import Data.IORef

public export
data PageBits = Empty | Taken | Last

export
Show PageBits where
  show Empty = "Empty"
  show Taken = "Taken"
  show Last = "Last"

export
pageSize: Int
pageSize = 4096

%foreign "C:idris2_heap_size"
prim__idris2_heap_size: Int

export
heapSize : Int
heapSize = prim__idris2_heap_size

%foreign "C:idris2_heap_start"
prim__idris2_heap_start: AnyPtr

export
heapStart : AnyPtr
heapStart = prim__idris2_heap_start

export
numPages : Int
numPages = cast {to=Int} $ (cast {to=Double} heapSize) / (cast {to=Double} pageSize)

export
pages : List PageBits
pages = replicate (cast 10) Empty

export
alloc : IORef (List PageBits) -> Nat -> IO (Maybe (List PageBits, Nat))
alloc ref Z = pure Nothing
alloc ref (S size) = do
  pages <- readIORef ref
  case getFirstFreeSpace pages [] 0 of
       Nothing => pure Nothing
       Just (pages, location) => do
         writeIORef ref pages
         pure $ Just (pages, location)

  where
    isFree : List PageBits -> Nat -> Bool
    isFree (Empty::xs) Z = True
    isFree (Empty::xs) (S n) = isFree xs n
    isFree _ _= False

    getFirstFreeSpace :
         (pages : List PageBits)
      -> (res : List PageBits) 
      -> (location : Nat) 
      -> Maybe (List PageBits, Nat)
    getFirstFreeSpace [] _ _ = Nothing
    getFirstFreeSpace (x::xs) res location = 
      if isFree (x::xs) size
         then Just (reverse res ++ replicate size Taken ++ Last::drop size xs,location)
         else getFirstFreeSpace xs (x::res) (location+1)








