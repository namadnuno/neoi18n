let s:save_cpo = &cpo
set cpo&vim

if !exists("g:i18nallyvim_file")
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  let g:i18nallyvim_file = './example/pt_PT.yaml'
endif

fun! I18nAllyShow()
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  lua require('i18nallyvim').show()
endfun

fun! I18nAllyAdd()
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  lua require('i18nallyvim').add()
endfun

fun! I18nAllyCheck()
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  lua require('i18nallyvim').check_for_translations_file()
endfun

function! I18nSelectCurrent()
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  let g:i18nallyvim_file = expand('%:p')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_i18nallyvim = 1

