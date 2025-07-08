module Pages

import Data.C.Ptr
import Data.List
import Data.IORef
import Data.Vect

import Uart
import Trap
import Debug

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

allocStart : AnyPtr
allocStart = prim__inc_ptr heapStart (cast numPages) 1

export
alloc : IORef (List PageBits) -> Nat -> IO AnyPtr
alloc ref Z = do
  println "Cannot allocate size of 0"
  exit
  pure allocStart
alloc ref (S size) = do
  pages <- readIORef ref
  case getFirstFreeSpace pages [] 0 of
       Nothing => do
        println "No memory available"
        exit
        pure allocStart
       Just (pages, location) => do
         writeIORef ref pages
         pure $ prim__inc_ptr allocStart (cast pageSize) (cast location)

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
  let allocStartAddr = cast_AnyPtrNat allocStart
  let ptrAddr = cast_AnyPtrNat ptr
  let pageNum = cast {to=Nat} $ ((cast {to=Double} ptrAddr) - (cast {to=Double} allocStartAddr)) / (cast {to=Double} pageSize)
  println $ "NumPage : " ++ show pageNum
  pages <- readIORef ref
  free (drop pageNum pages) [] >>= \p => writeIORef ref (take pageNum pages ++ p ++ (drop (pageNum + length p) pages))

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
    zero : AnyPtr -> Nat -> Nat -> IO ()
    zero ptr Z location = pure ()
    zero ptr (S n) location = do
      setPtr ptr $ cast {to=Bits8} 0
      zero (prim__inc_ptr ptr (cast n) (cast location))  n location

    zeroPages : AnyPtr -> Nat -> IO ()
    zeroPages ptr Z = pure ()
    zeroPages ptr (S n) = do
      zero ptr pageSize n
      zeroPages ptr n

savePages : IORef (List PageBits) -> IO ()
savePages ref = do
  pages <- readIORef ref
  save pages 0

  where 
    save : List PageBits -> Nat -> IO ()
    save [] n = pure ()
    save (Empty::xs) n = do
     -- setPtr (prim__inc_ptr heapStart (cast n) 1) $ cast {to=Bits8} 0
      save xs (n+1)
    save (Taken::xs) n = save xs (n+1)
    save (Last::xs) n =  save xs (n+1)

export
getPages :  IO (IORef (List PageBits))
getPages = do
  pages <- read numPages
  newIORef (reverse pages)

  where
    read : Nat -> IO (List PageBits)
    read Z = pure []
    read (S n) = do
      let ptr = (prim__inc_ptr heapStart (cast n) 1)
      val <- deref {a=Bits8} ptr
      case val of
        2 => do
          xs <- read n
          pure (Taken::xs)
        3 => do
          xs <- read n
          pure (Last::xs)
        _ => do
          xs <- read n
          pure (Empty::xs)

export
testPages : IO ()
testPages = do
  println "Test pages"
  pagesRef <- newIORef pages
  let ptrAddr = cast_AnyPtrNat heapStart
  println $ show ptrAddr
  savePages pagesRef
  println "Finish test pages"

data EntryBits = 
    None 
  | Valid 
  | Read 
  | Write 
  | Execute 
  | User 
  | Global
  | Access
  | Dirty

  -- Convenience combinations
  | ReadWrite
  | ReadExecute
  | ReadWriteExecute

  -- User Convenience Combinations
  | UserReadWrite
  | UserReadExecute
  | UserReadWriteExecute

{-
  println $ show $ length pages'
  println "Allocate 3 pages and set the first bit to 4"
  ptr <- alloc pagesRef 3
  readIORef pagesRef >>= println . show . take 10
  setPtr ptr $ cast {to=Bits8} 15
  val <- deref {a=Bits8} ptr
  println $ show val
  p' <- readIORef pagesRef
  println $ show $ length p'
  dealloc pagesRef ptr

  println "Allocate 4 pages and set the first bit to 2"
  ptr <- zalloc pagesRef 4
  readIORef pagesRef >>= println . show . take 10
  setPtr ptr $ cast {to=Bits8} 2
  val <- deref {a=Bits8} ptr
  println $ show val
  p'' <- readIORef pagesRef
  println $ show $ length p''

  dealloc pagesRef ptr

-}


map : 
     (root : Vect 512 Bits8) 
  -> (vaddr : Nat) 
  -> EntryBits
  -> (paddr : Nat)
  -> (bits: Bits64)
  -> (level: Nat)
  -> IO ()
map root vaddr entybits paddr bits level = do
  -- Extract out each VPN from the virtual address
	-- On the virtual address, each VPN is exactly 9 bits,
	-- which is why we use the mask 0x1ff = 0b1_1111_1111 (9 bits)
  let vpn = ?vpn_hole
      {- 
      	// VPN[0] = vaddr[20:12]
				(vaddr >> 12) & 0x1ff,
				// VPN[1] = vaddr[29:21]
				(vaddr >> 21) & 0x1ff,
				// VPN[2] = vaddr[38:30]
    (vaddr >> 30) & 0x1ff -} 

  -- Just like the virtual address, extract the physical address
	-- numbers (PPN). However, PPN[2] is different in that it stores
	-- 26 bits instead of 9. Therefore, we use,
	-- 0x3ff_ffff = 0b11_1111_1111_1111_1111_1111_1111 (26 bits).
  let ppn = ?ppn_hole
      {-
      // PPN[0] = paddr[20:12]
				(paddr >> 12) & 0x1ff,
				// PPN[1] = paddr[29:21]
				(paddr >> 21) & 0x1ff,
				// PPN[2] = paddr[55:30]
				(paddr >> 30) & 0x3ff_ffff,
      -}
  {-
   From osblog : 

   // We will use this as a floating reference so that we can set
   // individual entries as we walk the table.
   // let mut v = &mut root.entries[vpn[2]];
   // Now, we're going to traverse the page table and set the bits
   // properly. We expect the root to be valid, however we're required to
   // create anything beyond the root.
   // In Rust, we create a range iterator using the .. operator.
   // The .rev() will reverse the iteration since we need to start with
   // VPN[2] The .. operator is inclusive on start but exclusive on end.
   // So, (0..2) will iterate 0 and 1.

   for i in (level..2).rev() {
	    if !v.is_valid() {
		    // Allocate a page
		    let page = zalloc(1);
		    // The page is already aligned by 4,096, so store it
		    // directly The page is stored in the entry shifted
		    // right by 2 places.
		    // v.set_entry(
					  --(page as i64 >> 2)
					  --| EntryBits::Valid.val(),
		    );
	    }
	    let entry = ((v.get_entry() & !0x3ff) << 2) as *mut Entry;
	    v = unsafe { entry.add(vpn[i]).as_mut().unwrap() };
    }

    // When we get here, we should be at VPN[0] and v should be pointing to
    // our entry.
    // The entry structure is Figure 4.18 in the RISC-V Privileged
    // Specification
    let entry = (ppn[2] << 28) as i64 |   // PPN[2] = [53:28]
			(ppn[1] << 19) as i64 |   // PPN[1] = [27:19]
			(ppn[0] << 10) as i64 |   // PPN[0] = [18:10]
			bits |                    // Specified bits, such as User, Read, Write, etc
			EntryBits::Valid.val();   // Valid bit
			// Set the entry. V should be set to the correct pointer by the loop
			// above.
    v.set_entry(entry);

  -}
  pure ()

virt_to_phys : (root : Vect 512 Bits8) -> (vaddr : Nat) -> Maybe Nat 




