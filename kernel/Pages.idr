module Pages

------------------------ INTERFACE -----------------------------------------


data PageBits = Empty | Taken | Last

export
pageSize: Int
pageSize = 4096

-- From osblog

zalloc : Page a -> IO ()
dealloc : Page a -> UI ()

---------------------- PRIVATE IMPLEMENTATION FOLLOWS --------------------

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





