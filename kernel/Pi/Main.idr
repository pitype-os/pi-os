module Pi.Main

import Core.Monad
import Core.Pages
import PC.Trap
import PC.Uart

main : IO ()
main = runCore $ do
  println "Welcome to PI OS!"
  println "Initialize pages"
  let init_pages = pages
  println "Finish inialize pages"
  exit



