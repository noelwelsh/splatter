(module all-spatter-tests mzscheme
  
  (require
   (planet "test.ss" ("schematics" "schemeunit.plt" 2))
   (file "colour-test.ss")
   (file "stream-test.ss")
   (file "geometry-test.ss"))
  
  (provide all-spatter-tests)
  
  (define all-spatter-tests
    (test-suite 
     "all-spatter-tests"
     colour-tests
     stream-tests
     geometry-tests))
  )