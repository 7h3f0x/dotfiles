setlocal winhighlight=Normal:BlackFloat
if !get(g:, "is_transparent", v:false)
    setlocal winblend=15
endif
