" Star-Flasher - for the star that flashes
"
" Author: Yuki Yoshimine <yuki.uthman@gmail.com>
" Source: https://github.com/yuki-uthman/vim-star-flasher


if exists("g:loaded_star_flasher")
  finish
endif
let g:loaded_star_flasher = 1

let s:save_cpo = &cpo
set cpo&vim

noremap <silent><Plug>(star_flasher-normal) :call star_flasher#normal()<CR>
noremap <silent><Plug>(star_flasher-visual) :call star_flasher#visual()<CR>

if !exists("g:star_flasher_no_mappings") || ! g:star_flasher_no_mappings
  nmap * <Plug>(star_flasher-normal)
  vmap * <Plug>(star_flasher-visual)
endif


let &cpo = s:save_cpo
unlet s:save_cpo
