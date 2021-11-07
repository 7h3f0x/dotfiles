

; vim.api.nvim_command [[
; or
; vim.api.nvim_exec  [[
; or
; vim.cmd [[
(function_call
 (field_expression) @_function.name (#match? @_function.name "\(nvim_exec\|cmd\|nvim_command\)$")
 (arguments
  (string) @vim
  (#offset! @vim 0 1 0 -1)
 ))

