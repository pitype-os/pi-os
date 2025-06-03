module Core.Pages

import Core.Addr
import Core.AdHocMem
import Core.Storable
import Core.Monad
------------------------ INTERFACE -----------------------------------------

data Page a = Ptr a 

data PageBits = Empty | Taken | Last

export
pageSize: Int
pageSize = 4096

-- From osblog

zalloc : Page a -> Core ()
dealloc : Page a -> Core ()

---------------------- PRIVATE IMPLEMENTATION FOLLOWS --------------------

%foreign "C:idris2_heap_size"
prim__idris2_heap_size: Int

export
heapSize : Int
heapSize = prim__idris2_heap_size

%foreign "C:idris2_heap_start"
prim__idris2_heap_start: Ptr Bits8

export
heapStart : Ptr Bits8
heapStart = prim__idris2_heap_start

export
numPages : Int
numPages = cast {to=Int} $ (cast {to=Double} heapSize) / (cast {to=Double} pageSize)

export
pageinit : Core ()
pageinit = helper numPages
  where 
    clear : Int -> Core () 
    clear page = poke (plusAddr heapStart (cast {to=Bits32} page)) 0
    
    helper : Int -> Core ()
    helper 0 = clear 0
    helper i = clear i >> helper (i-1)

export
alloc : Int -> Core ()
alloc pages = firstFreeContiguous 0 pages >>= takePages
  where 
    isFreeContiguous : Int -> Int -> Core Bool
    isFreeContiguous page 0 = do
        val <- peek (plusAddr heapStart (cast {to=Bits32} page))
        pure (val == 0)
    isFreeContiguous page size = do
      val <- peek (plusAddr heapStart (cast {to=Bits32} (page+size)))
      if val == 0
        then isFreeContiguous page (size-1)
        else pure False

    firstFreeContiguous : Int -> Int -> Core (Maybe Int)
    firstFreeContiguous page 1 = do
        val <- peek (plusAddr heapStart (cast {to=Bits32} page))
        if val == 0 
           then pure (Just page)
           else pure Nothing
    firstFreeContiguous page size = do
        val <- isFreeContiguous page size
        if val
           then pure (Just page)
           else firstFreeContiguous (page+1) size

    takePage : Int -> Core ()
    takePage page =  poke (plusAddr heapStart (cast {to=Bits32} page)) 1

    takePages : Maybe Int -> Core ()
    takePages Nothing = pure ()
    takePages (Just page) = helper page

      where helper : Int -> Core ()
            helper n = if n <= page+pages
                       then takePage n >> helper (n+1)
                       else pure ()

    




  




