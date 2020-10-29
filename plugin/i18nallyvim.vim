if !exists("g:i18nallyvim_file")
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

let g:loaded_i18nallyvim = 1

