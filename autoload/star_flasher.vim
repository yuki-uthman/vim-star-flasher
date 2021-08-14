
function! star_flasher#normal()
  call s:star_flasher('n')
endfunction

function! star_flasher#visual()
  call s:star_flasher('v')
endfunction

function! s:is_beginning_of_word() abort "{{{
  let pos = getpos('.')
  normal! bw
  if pos == getpos('.')
    return v:true
  else
    call setpos('.', pos)
    return v:false
  endif
endfunction "}}}

function! s:get_flash_pos(mode) "{{{
  let to_return = []
  if a:mode ==# 'n' && !s:is_beginning_of_word()
    let save_pos = getcurpos()
    normal! b
    let pos = getcurpos()
    let to_return = [pos[1], pos[2], strlen(@/) - 4]
    call setpos('.', save_pos)

  elseif a:mode ==# 'v'
    let [lnum, col] = getpos("'<")[1:2]
    let to_return = [lnum, col, strlen(@/)]

  else
    let pos = getcurpos()
    let to_return = [pos[1], pos[2], strlen(@/) - 4]
  endif
  return to_return
endfunction "}}}

function! s:get_visual_selection() "{{{
  let [l:lnum1, l:col1] = getpos("'<")[1:2]
  let [l:lnum2, l:col2] = getpos("'>")[1:2]
  if &selection !=# 'inclusive'
    let l:col2 -= 1
  endif
  let l:lines = getline(l:lnum1, l:lnum2)
  if !empty(l:lines)
    let l:lines[-1] = l:lines[-1][: l:col2 - 1]
    let l:lines[0] = l:lines[0][l:col1 - 1 : ]
  endif
  return join(l:lines, "\n")
endfunction "}}}

function! s:get_user_config() "{{{
  let to_return = {}

  let highlight = get(g:, 'star_flasher_highlight', 'IncSearch')

  let duration = get(g:, 'star_flasher_duration', 500)

  return { 'duration' : duration , 'highlight': highlight }
endfunction "}}}

function! s:put_in_search_reg(mode) " {{{
  let text = ''
  if a:mode ==# 'n'
    let text = expand('<cword>')
    let @/ = '\<'. text .'\>'

  elseif a:mode ==# 'v'
    let text = s:get_visual_selection()

    " escape dot
    let text = substitute(text, '\.', '\\.', "")
    let @/ = text
  endif

  " add the text to search history
  call histadd('/', @/)

  return text
endfunction "}}}

function! s:stop_timers() "{{{
"  call Decho('stopping timers' . string(s:timers))
  for timer in s:timers
    call timer_stop(timer)
  endfor
  let s:timers = []
endfunction "}}}

function! s:flash(mode, highlight) "{{{
  let s:flash.pos = s:get_flash_pos(a:mode)
  let s:flash.id = matchaddpos(a:highlight, [s:flash.pos], 101) 
  let s:flash.winid = win_getid()
"  call Decho( 'starting flash' . string(s:flash))
endfunction "}}}

function! s:stop_flash(timer_id) "{{{
"  call Decho( 'stopping flash ' . string(s:flash))
  call matchdelete(s:flash.id, s:flash.winid)
  let s:flash = {}
endfunction "}}}

function! s:star_flasher(mode) "{{{

  if !exists('s:timers')
    let s:timers = []
  endif

  if !exists('s:flash')
    let s:flash = {}
  endif

  if !empty(s:flash)
"    call Decho('previous flash ' . string(s:flash))
    call s:stop_flash(0)
  endif

  let s:user_config = s:get_user_config()

  call s:stop_timers()

  call s:put_in_search_reg(a:mode)

  call s:flash(a:mode, s:user_config.highlight)

  let timer_id = timer_start(s:user_config.duration, function('<SID>stop_flash'))
  call add(s:timers, timer_id)

  " jump back to the beginning of the visual selection
  if a:mode ==# 'v'
    normal! `<
  endif

endfunction "}}}

" [TODO](2108140701)
