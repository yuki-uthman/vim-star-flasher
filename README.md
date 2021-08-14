# star-flasher

The default behavior of * is to put the word under the cursor (<cword>) into the 
search register and jump to the next occurence. This plugin modifies this 
behvior in two ways.

  1. the cursor does not move
  2. gives a visual feedback by flashing the text

## Installation

vim-plug:
```vimL
Plug 'yuki-uthman/vim-scroller'
```

vundle:
```vimL
Plugin 'yuki-uthman/vim-scroller'
```

minpac:
```vimL
call minpac#add('yuki-uthman/vim-scroller')
```

## Configuration

To change the duration of the flash:
```vimL
" default is set to 500 (unit is in milliseconds)
let g:star_flasher_duration = 500
```

The default color of the flash is set to 'Search' highlight group. This is the 
same color as hlsearch highlight. The exact color would depend on your 
colorscheme. You can change to any highlight group by changing the main 
highlight group:
```vimL
" default is set to 'Search'
let g:star_flasher_main_highlight = 'Visual'
```

The flash becomes invisible when you are flashing over some text that are 
already highlighted by hlsearch. You can define a different color by setting the 
secondary highlight group:
```vimL
" default is set to 'IncSearch'
let g:star_flasher_secondary_highlight = 'ErrorMsg'
```

To see all the highlight groups already defined:
```vimL
:highlight
```

If you want to define your own highlight group:
```vimL
" for terminal
" ctermfg as the color of the letters
" ctermbg as the color of the background
highlight flasherColor ctermfg='White' ctermbg='Black'

" for gui
" guifg as the color of the letters
" guibg as the color of the background
highlight flasherColor guifg='White' guibg='Black'

let g:star_flasher_main_highlight = 'flasherColor'
```
The following colors are available in most systems:
  - Black
  - Brown
  - Gray
  - Blue
  - Green
  - Cyan
  - Red
  - Magenta
  - Yellow
  - White

To see more colors:
```vimL
h cterm-colors
h gui-colors
```

To set custom color using RGB:
```vimL
:highlight flasherColor guifg=#11f0c3 guibg=#ff00ff
```
