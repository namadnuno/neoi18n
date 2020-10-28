fun! I18nAllyShow()
  lua for k in pairs(package.loaded) do if k:match("^i18nallyvim") then package.loaded[k] = nil end end
  lua require('i18nallyvim').show()
endfun

let g:loaded_i18nallyvim = 1

