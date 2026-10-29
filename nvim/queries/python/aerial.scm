; Outline for F4 (aerial) in Python, like Tagbar: imports, constants, variables,
; classes with methods and attributes, functions. Local variables inside functions are left out.
; Replaces aerial's default Python query (this file comes first in the runtimepath).

; --- imports ---------------------------------------------------------------
(import_statement
  name: (dotted_name) @name
  (#set! "kind" "Module")) @symbol

(import_statement
  name: (aliased_import alias: (identifier) @name)
  (#set! "kind" "Module")) @symbol

(import_from_statement
  name: (dotted_name) @name
  (#set! "kind" "Module")) @symbol

(import_from_statement
  name: (aliased_import alias: (identifier) @name)
  (#set! "kind" "Module")) @symbol

; --- classes and functions (methods are functions inside a class) ----------
(class_definition
  name: (identifier) @name
  (#set! "kind" "Class")) @symbol

(function_definition
  name: (identifier) @name
  (#set! "kind" "Function")) @symbol

; --- module-level constants (UPPER_CASE) and variables ---------------------
(module
  (expression_statement
    (assignment
      left: (identifier) @name
      (#match? @name "^[A-Z][A-Z0-9_]*$")
      (#set! "kind" "Constant")) @symbol))

(module
  (expression_statement
    (assignment
      left: (identifier) @name
      (#not-match? @name "^[A-Z][A-Z0-9_]*$")
      (#set! "kind" "Variable")) @symbol))

; --- class attributes ------------------------------------------------------
(class_definition
  body: (block
    (expression_statement
      (assignment
        left: (identifier) @name
        (#set! "kind" "Field")) @symbol)))
