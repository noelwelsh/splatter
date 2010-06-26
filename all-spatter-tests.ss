#lang scheme

(require (planet schematics/schemeunit:3/test)
         "colour-test.ss"
         "stream-test.ss"
         "geometry-test.ss")

(define/provide-test-suite all-spatter-tests
  colour-tests
  stream-tests
  geometry-tests)
