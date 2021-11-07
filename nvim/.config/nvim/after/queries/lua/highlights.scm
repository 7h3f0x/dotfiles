; (function_call
; (field_expression
; (identifier) @variable.builtin)
; (#vim-match? @variable.builtin "package|bit32|coroutine|string|table|math|io|os|debug")
; )

(field_expression
(identifier) @variable.builtin
(#any-of? @variable.builtin "package" "bit32" "coroutine" "string" "table" "math" "io" "os" "debug" "vim"))

