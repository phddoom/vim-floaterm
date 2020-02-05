" ============================================================================
" FileName: floatwin.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! floaterm#floatwin#floatwin_pos(width, height) abort
  if g:floaterm_position ==# 'topright'
    let row = 0
    let col = &columns
    let vert = 'N'
    let hor = 'E'
  elseif g:floaterm_position ==# 'topleft'
    let row = 0
    let col = 0
    let vert = 'N'
    let hor = 'W'
  elseif g:floaterm_position ==# 'bottomright'
    let row = &lines
    let col = &columns
    let vert = 'S'
    let hor = 'E'
  elseif g:floaterm_position ==# 'bottomleft'
    let row = &lines
    let col = 0
    let vert = 'S'
    let hor = 'W'
  elseif g:floaterm_position ==# 'center'
    let row = (&lines - a:height)/2
    let col = (&columns - a:width)/2
    let vert = 'N'
    let hor = 'W'

    if row < 0
      let row = 0
    endif
    if col < 0
      let col = 0
    endif
  else " at the cursor place
    let curr_pos = getpos('.')
    let row = curr_pos[1] - line('w0')
    let col = curr_pos[2]

    if row + a:height <= &lines
      let vert = 'N'
    else
      let vert = 'S'
    endif

    if col + a:width <= &columns
      let hor = 'W'
    else
      let hor = 'E'
    endif
  endif

  return [row, col, vert, hor]
endfunction
