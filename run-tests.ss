(require (planet "test.ss" ("schematics" "schemeunit.plt" 2)))
(require (planet "text-ui.ss" ("schematics" "schemeunit.plt" 2)))
(require "all-spatter-tests.ss")

(test/text-ui all-spatter-tests)