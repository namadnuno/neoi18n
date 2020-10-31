# Neovim i18n

Working with i18n without bigi.

#Notes

Right now it only works with yaml files, but I have plans to add more extensions.

## Installation

```vim
Plug 'namadnuno/neovim-i18n'
```

## Key biddings

```vim
  nmap <leader>t :call I18nAllyShow() <CR>
  nmap <leader>T :call I18nAllyAdd() <CR>
```

## Usage

```vim
:call I18nAllyCheck()
```
It will display an window where you can select you translations file.

```vim
:call I18nAllyShow()
```
Shows the translation for the current word under the cursor.

```vim
:call I18nAllyAdd()
```
Adds an translation for the key under the cursor.


