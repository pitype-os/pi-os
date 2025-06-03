module Pi.Main

import Core.Monad
import Core.Pages
import PC.Uart

main : IO ()
main = runCore $ do
  println "Welcome to PI OS"
  println "Initialise the heap"
  pageinit
  println "Finish initialise the heap"
  println "Alloc 2 pages"
  alloc 2
  println "Finish alloc 2 pages"



