; not really needed after the query below this
; this one is for the first child of the parameters, if it is cls, for
; decorated_definitions
; ((class_definition
;   body: (block
;   (decorated_definition
;           (function_definition
;             parameters: (parameters . (identifier) @variable.builtin)))))
;  (#vim-match? @variable.builtin "^cls$"))

((identifier) @variable.builtin
 (#match? @variable.builtin "^cls$"))

