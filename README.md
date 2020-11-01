# Neovim i18n

Working with i18n without bigi.

![](demo.gif)

#Notes

Right now it only works with yaml files, but I have plans to add more extensions.

## Installation

```vim
Plug 'namadnuno/neoi18n'
```

## Key biddings

```vim
  nmap <leader>t :call NeoI18nShow() <CR>
  nmap <leader>T :call NeoI18nAdd() <CR>
```

## Usage

```vim
:call NeoI18nCheck()
```
It will display an window where you can select you translations file.

```vim
:call NeoI18nShow()
```
Shows the translation for the current word under the cursor.

```vim
:call NeoI18nAdd()
```
Adds an translation for the key under the cursor.


