(module effects-test mzscheme
  
  (require (planet "test.ss" ("schematics" "schemeunit.plt" 2)))
  (require "effects.ss")
  
  (provide effects-tests)
  
  (define effects-tests
    (test-suite
     "All tests for effects"

     (test-case
      "quad->grid"
      (fail "Not implemented"))

     (test-case
      "quad->strip"
      (fail "Not implemented"))
     ))
  )