module Pages

import Data.C.Ptr
import Data.List
import Data.IORef

import Uart
import Trap

public export
data PageBits = Empty | Taken | Last

export
Show PageBits where
  show Empty = "Empty"
  show Taken = "Taken"
  show Last = "Last"

export
pageSize: Nat
pageSize = 4096

%foreign "C:idris2_anyptr_nat"
prim_cast_anyptr_nat : AnyPtr -> Nat

export
cast_AnyPtrNat: AnyPtr -> Nat 
cast_AnyPtrNat = prim_cast_anyptr_nat

%foreign "C:idris2_heap_size"
prim__idris2_heap_size: AnyPtr 

export
heapSize : Nat 
heapSize = cast_AnyPtrNat prim__idris2_heap_size

%foreign "C:idris2_heap_start"
prim__idris2_heap_start: AnyPtr

export
heapStart : AnyPtr
heapStart = prim__idris2_heap_start

export
numPages : Nat
numPages = cast {to=Nat} $ (cast {to=Double} heapSize) / (cast {to=Double} pageSize)

export
pages : List PageBits
pages = replicate (cast numPages) Empty

export
alloc : IORef (List PageBits) -> Nat -> IO AnyPtr
alloc ref Z = do
  println "Cannot allocate size of 0"
  exit
  pure heapStart
alloc ref (S size) = do
  pages <- readIORef ref
  case getFirstFreeSpace pages [] 0 of
       Nothing => do
        println "No memory available"
        exit
        pure heapStart
       Just (pages, location) => do
         writeIORef ref pages
         pure $ prim__inc_ptr heapStart (cast pageSize) (cast location)

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
         then Just (reverse res ++ replicate size Taken ++ Last::drop size xs, location)
         else getFirstFreeSpace xs (x::res) (location+1)

export
dealloc : IORef (List PageBits) -> AnyPtr -> IO ()
dealloc ref ptr = do
  let heapStartAddr = cast_AnyPtrNat heapStart
  let ptrAddr = cast_AnyPtrNat ptr
  let pageNum = cast {to=Nat} $ ((cast {to=Double} ptrAddr) - (cast {to=Double} heapStartAddr)) / (cast {to=Double} pageSize)
  println $ "NumPage : " ++ show pageNum
  pages <- readIORef ref
  free (drop pageNum pages) [] >>= \p => writeIORef ref (take pageNum pages ++ p)

  where
    free : List PageBits -> List PageBits -> IO (List PageBits)
    free [] _ = do
      println "Couldn't free"
      exit
      pure []
    free (Last::ps) res = pure $ res ++ (Empty::ps) 
    free (p::ps) rest = free ps (Empty::rest)

export
zalloc : IORef (List PageBits) -> Nat -> IO AnyPtr
zalloc ref size = do
  ptr <- alloc ref size
  zeroPages ptr size
  pure ptr

  where
    zero : AnyPtr -> Nat -> IO ()
    zero ptr Z = setPtr ptr $ cast {to=Bits8} 0
    zero ptr (S n) = do
      setPtr (prim__inc_ptr heapStart (cast n) 1) $ cast {to=Bits8} 0
      zero ptr n

    zeroPages : AnyPtr -> Nat -> IO ()
    zeroPages ptr Z = zero ptr pageSize
    zeroPages ptr (S n) = do
      zero ptr pageSize
      zeroPages ptr n

export
testPages : IO ()
testPages = do
  println "Test pages"
  pagesRef <- newIORef pages
  println "Allocate 3 pages and set the first bit to 4"
  ptr <- alloc pagesRef 3
  readIORef pagesRef >>= println . show . take 10
  setPtr ptr $ cast {to=Bits8} 15
  val <- deref {a=Bits8} ptr
  println $ show val
  dealloc pagesRef ptr

  println "Allocate 4 pages and set the first bit to 2"
  ptr <- zalloc pagesRef 4
  readIORef pagesRef >>= println . show . take 10
  setPtr ptr $ cast {to=Bits8} 2
  val <- deref {a=Bits8} ptr
  println $ show val
  dealloc pagesRef ptr
  
  println "Finish test pages"











