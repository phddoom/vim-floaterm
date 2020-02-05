" ============================================================================
" FileName: autocmd/floaterm.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

" `hidden` option must be set, otherwise the floating terminal would be wiped
" out, see #17
set hidden

function s:init()
  if g:floaterm_border_color == v:null
    let g:floaterm_border_color = floaterm#util#get_normalfloat_fg()
  endif

  if g:floaterm_background == v:null
    let g:floaterm_background = floaterm#util#get_normalfloat_bg()
  endif

  if g:floaterm_border_bgcolor == v:null
    let g:floaterm_border_bgcolor = g:floaterm_background
  endif
endfunction
call s:init()

let s:linkedlist = floaterm#linkedlist#new()

function! floaterm#new() dict abort
  call s:hide()
  let bufnr = floaterm#terminal#open(0)
  call s:linkedlist.add({'bufnr': bufnr})
endfunction

function! floaterm#remove() dict abort
  " call s:linkedlist.remove()
endfunction

function! floaterm#next() dict abort
  call s:hide()
  let next_node = s:linkedlist.find_next()
  let bufnr = next_node.data.bufnr
  if bufnr != 0 && bufexists(bufnr)
    call floaterm#terminal#open(bufnr)
  endif

  " while v:true
  "   if self.count == 0
  "     call floaterm#util#show_msg('No more terminal buffers', 'warning')
  "     return
  "   endif
  "   " If the current node is the end node(whose next node is HEAD),
  "   " skip and point to the HEAD's next node
  "   if self.index.next == self.head
  "     let self.index = self.head.next
  "   else
  "     let self.index = self.index.next
  "   endif
  "   let next_bufnr = self.index.bufnr
  "   if next_bufnr != 0 && bufexists(next_bufnr)
  "     call self.open(next_bufnr)
  "     return
  "   else
  "     call self.kickout()
  "   endif
  " endwhile
endfunction

function! floaterm#prev() dict abort
  call s:hide()
  let next_node = s:linkedlist.find_prev()
  let bufnr = next_node.data.bufnr
  if bufnr != 0 && bufexists(bufnr)
    call floaterm#terminal#open(bufnr)
  endif

  " while v:true
  "   if self.count == 0
  "     call floaterm#util#show_msg('No more terminal buffers', 'warning')
  "     return
  "   endif
  "   " If the current node is the node after HEAD(whose previous node is HEAD),
  "   " skip and point to the HEAD's prev node(the end node)
  "   if self.index.prev == self.head
  "     let self.index = self.head.prev
  "   else
  "     let self.index = self.index.prev
  "   endif
  "   let prev_bufnr = self.index.bufnr
  "   if prev_bufnr != 0 && bufexists(prev_bufnr)
  "     call self.open(prev_bufnr)
  "     return
  "   else
  "     call self.kickout()
  "   endif
  " endwhile
endfunction

" Hide the current terminal before opening another terminal window
" Therefore, you cannot have two terminals displayed at once
function! s:hide() dict abort
  while v:true
    let found_winnr = self.find_term_win()
    if found_winnr > 0
      execute found_winnr . ' wincmd q'
    else
      break
    endif
  endwhile
endfunction

function! floaterm#toggle() dict abort
  let found_winnr = self.find_term_win()
  if found_winnr > 0
    if &buftype ==# 'terminal'
      execute found_winnr . ' wincmd q'
    else
      execute found_winnr . ' wincmd w | startinsert'
    endif
  else
    let curr_node = s:linkedlist.find_curr()
    call floaterm#terminal#open(curr_node)
  endif
    " while v:true
    "   if self.count == 0
    "     call self.open(0)
    "     return
    "   endif
    "   " If the current node is HEAD(which doesn't have 'bufnr' key),
    "   " skip and point to the node after HEAD
    "   if self.index == self.head
    "     let self.index = self.head.next
    "   endif
    "   let found_bufnr = self.index.bufnr
    "   if found_bufnr != 0 && bufexists(found_bufnr)
    "     call self.open(found_bufnr)
    "     return
    "   else
    "     call self.kickout()
    "     let self.index = self.index.next
    "   endif
    " endwhile
endfunction

" Gather active floaterm for vim-clap
function! g:floaterm.gather() dict abort
  let lst = []
  let self.index = self.head.next
  while self.index != self.head
    let bufnr = self.index.bufnr
    if bufnr != 0 && bufexists(bufnr)
      call add(lst, bufnr)
    else
      call self.kickout()
    endif
    let self.index = self.index.next
  endwhile
  return lst
endfunction

" Jump to terminal buffer bufnr, for vim-clap
function! g:floaterm.jump(bufnr) dict abort
  let self.index = self.head.next
  while self.index != self.head
    if a:bufnr == self.index.bufnr
      call self.open(a:bufnr)
      return
    endif
    let self.index = self.index.next
  endwhile
endfunction

" Find if there is a terminal among all opened windows
" If found, hide it or jump into it
function! g:floaterm.find_term_win() abort
  let found_winnr = 0
  for winnr in range(1, winnr('$'))
    if getbufvar(winbufnr(winnr), '&filetype') ==# 'floaterm'
      let found_winnr = winnr
    endif
  endfor
  return found_winnr
endfunction

function! s:hide_border(...) abort
  if exists('g:floaterm.index.border_bufnr')
    \ && bufexists(g:floaterm.index.border_bufnr)
    \ && g:floaterm.index.border_bufnr != 0
    execute 'bw ' . g:floaterm.index.border_bufnr
  endif
endfunction

function! floaterm#start(action) abort
  if !floaterm#feature#has_terminal()
    return
  endif

  if a:action ==# 'new'
    call floaterm#new()
  elseif a:action ==# 'next'
    call floaterm#next()
  elseif a:action ==# 'prev'
    call floaterm#prev()
  elseif a:action ==# 'toggle'
    call floaterm#toggle()
  endif
endfunction

function! s:is_none(node) abort
  return a:node == {}
endfunction
