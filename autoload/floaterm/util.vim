" ============================================================================
" FileName: autoload/floaterm/util.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! s:echo(group, msg) abort
  if a:msg ==# '' | return | endif
  execute 'echohl' a:group
  echo a:msg
  echon ' '
  echohl NONE
endfunction

function! s:echon(group, msg) abort
  if a:msg ==# '' | return | endif
  execute 'echohl' a:group
  echon a:msg
  echon ' '
  echohl NONE
endfunction

function! floaterm#util#show_msg(message, ...) abort
  if a:0 == 0
    let msg_type = 'info'
  else
    let msg_type = a:1
  endif

  if type(a:message) != 1
    let message = string(a:message)
  else
    let message = a:message
  endif

  call s:echo('Constant', '[vim-floaterm]')

  if msg_type ==# 'info'
    call s:echon('Normal', message)
  elseif msg_type ==# 'warning'
    call s:echon('WarningMsg', message)
  elseif msg_type ==# 'error'
    call s:echon('Error', message)
  endif
endfunction

function! floaterm#util#get_normalfloat_fg() abort
  let hiGroup = 'NormalFloat'
  while v:true
    let hiInfo = execute('hi ' . hiGroup)
    let fgcolor = matchstr(hiInfo, 'guifg=\zs\S*')
    let hiGroup = matchstr(hiInfo, 'links to \zs\S*')
    if fgcolor !=# '' || hiGroup ==# ''
      break
    endif
  endwhile
  " If the foreground color isn't found eventually, use white
  if fgcolor ==# ''
    let fgcolor = '#FFFFFF'
  endif
  return fgcolor
endfunction

function! floaterm#util#get_normalfloat_bg() abort
  let hiGroup = 'NormalFloat'
  while v:true
    let hiInfo = execute('hi ' . hiGroup)
    let bgcolor = matchstr(hiInfo, 'guibg=\zs\S*')
    let hiGroup = matchstr(hiInfo, 'links to \zs\S*')
    if bgcolor !=# '' || hiGroup ==# ''
      break
    endif
  endwhile
  " If the background color isn't found eventually, use black
  if bgcolor ==# ''
    let bgcolor = '#000000'
  endif
  return bgcolor
endfunction
