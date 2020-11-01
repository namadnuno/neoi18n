let s:save_cpo = &cpo
set cpo&vim

if !exists("g:neoi18n_file")
  lua for k in pairs(package.loaded) do if k:match("^neoi18n") then package.loaded[k] = nil end end
  let g:neoi18n_file = './example/pt_PT.yaml'
endif

fun! NeoI18nShow()
  lua for k in pairs(package.loaded) do if k:match("^neoi18n") then package.loaded[k] = nil end end
  lua require('neoi18n').show()
endfun

fun! NeoI18nAdd()
  lua for k in pairs(package.loaded) do if k:match("^neoi18n") then package.loaded[k] = nil end end
  lua require('neoi18n').add()
endfun

fun! NeoI18nCheck()
  lua for k in pairs(package.loaded) do if k:match("^neoi18n") then package.loaded[k] = nil end end
  lua require('neoi18n').check_for_translations_file()
endfun

function! I18nSelectCurrent()
  lua for k in pairs(package.loaded) do if k:match("^neoi18n") then package.loaded[k] = nil end end
  let g:neoi18n_file = expand('%:p')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_neoi18n = 1

