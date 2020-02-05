" ============================================================================
" FileName: feature.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! floaterm#feature#has_floatwin() abort
  return has('nvim') && exists('*nvim_win_set_config')
endfunction

function! floaterm#feature#has_terminal() abort
  if !exists(':terminal')
    let message = 'Terminal feature is required, please upgrade your vim/nvim'
    call floaterm#util#show_msg(message, 'error')
    return v:false
  endif
  return v:true
endfunction
