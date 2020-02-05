" ============================================================================
" FileName: terminal.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! floaterm#terminal#create_floating_terminal(found_bufnr, height, width) abort
  let [row, col, vert, hor] = floaterm#util#floating_win_pos(a:width, a:height)

  let border_opts = {
    \ 'relative': 'editor',
    \ 'anchor': vert . hor,
    \ 'row': row,
    \ 'col': col,
    \ 'width': a:width + 2,
    \ 'height': a:height + 2,
    \ 'style':'minimal'
    \ }
  let top = g:floaterm_borderchars[4] .
          \ repeat(g:floaterm_borderchars[0], a:width) .
          \ g:floaterm_borderchars[5]
  let mid = g:floaterm_borderchars[3] .
          \ repeat(' ', a:width) .
          \ g:floaterm_borderchars[1]
  let bot = g:floaterm_borderchars[7] .
          \ repeat(g:floaterm_borderchars[2], a:width) .
          \ g:floaterm_borderchars[6]
  let lines = [top] + repeat([mid], a:height) + [bot]
  let border_bufnr = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_option(border_bufnr, 'synmaxcol', 3000) " #27
  call nvim_buf_set_lines(border_bufnr, 0, -1, v:true, lines)
  call nvim_open_win(border_bufnr, v:false, border_opts)
  " Floating window border highlight
  augroup floaterm_border_highlight
    autocmd!
    autocmd FileType floaterm_border ++once execute printf(
      \ 'syn match Border /.*/ | hi Border guibg=%s guifg=%s',
      \ g:floaterm_border_bgcolor,
      \ g:floaterm_border_color
      \ )
  augroup END
  call nvim_buf_set_option(border_bufnr, 'filetype', 'floaterm_border')

  ""
  " TODO:
  " Use 'relative': 'cursor' for the border window
  " Use 'relative':'win'(which behaviors not as expected...) for content window
  let opts = {
    \ 'relative': 'editor',
    \ 'anchor': vert . hor,
    \ 'row': row + (vert ==# 'N' ? 1 : -1),
    \ 'col': col + (hor ==# 'W' ? 1 : -1),
    \ 'width': a:width,
    \ 'height': a:height,
    \ 'style':'minimal'
    \ }

  if a:found_bufnr > 0
    call nvim_open_win(a:found_bufnr, v:true, opts)
    return [0, border_bufnr]
  else
    let bufnr = nvim_create_buf(v:false, v:true)
    call nvim_open_win(bufnr, v:true, opts)
    let opts = {'on_exit': function('s:hide_border')}
    call termopen(&shell, opts)
    return [bufnr]
  endif
endfunction

function! floaterm#terminal#create_normal_terminal(found_bufnr, height, width) abort
  if a:found_bufnr > 0
    if &lines > 30
      execute 'botright ' . a:height . 'split'
      execute 'buffer ' . a:found_bufnr
    else
      botright split
      execute 'buffer ' . a:found_bufnr
    endif
    return
  else
    if &lines > 30
      if has('nvim')
        execute 'botright ' . a:height . 'split term://' . &shell
      else
        botright terminal
        resize a:height
      endif
    else
      if has('nvim')
        execute 'botright split term://' . &shell
      else
        botright terminal
      endif
    endif
    return bufnr('%')
  endif
endfunction

function! floaterm#terminal#open(bufnr) abort
  let height = g:floaterm_height == v:null ? 0.6 : g:floaterm_height
  if type(height) == v:t_float | let height = height * &lines | endif
  let height = float2nr(height)

  let width = g:floaterm_width == v:null ? 0.6 : g:floaterm_width
  if type(width) == v:t_float | let width = width * &columns | endif
  let width = float2nr(width)

  if floaterm#feature#has_floatwin()
    return floaterm#terminal#create_floating_terminal(a:bufnr, height, width)
  else
    return floaterm#terminal#create_normal_terminal(a:bufnr, height, width)
  endif
endfunction

function! s:on_open() abort
  setlocal cursorline
  setlocal filetype=floaterm

  " Find the true background(not 'hi link') for floating
  if has('nvim')
    execute 'setlocal winblend=' . g:floaterm_winblend
    execute 'hi FloatTermNormal term=NONE guibg='. g:floaterm_background
    setlocal winhighlight=NormalFloat:FloatTermNormal,FoldColumn:FloatTermNormal

    augroup close_floaterm_window
      autocmd!
      autocmd TermClose <buffer> bdelete!
      autocmd BufHidden <buffer> call s:hide_border()
    augroup END
  endif

  startinsert
endfunction
