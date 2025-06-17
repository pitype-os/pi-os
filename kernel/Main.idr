module Main

import Data.IORef
import Pages
import Trap
import Uart

import Data.List

main : IO ()
main = do
  println "Welcome to PI-OS!"
  println "Initialize pages"
  pagesRef <- newIORef pages
  res <- alloc pagesRef 3
  case res of 
    Nothing => println "No memory available"
    Just (pages,i) => do
      println $ show i
      println $ show $ take 10 pages

  res <- alloc pagesRef 4
  case res of 
    Nothing => println "No memory available"
    Just (pages,i) => do
      println $ show i
      println $ show $ take 10 pages

  println "Finish inialize pages"
  exit





