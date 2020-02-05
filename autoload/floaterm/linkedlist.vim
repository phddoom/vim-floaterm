" ============================================================================
" FileName: linkedlist.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

let s:none = {}
let s:node = {
  \ 'next': s:node,
  \ 'prev': s:node,
  \ }

let s:size = 0

function! s:node.new(data) dict abort
  let node = deepcopy(self)
  let node.data = a:data
  return node
endfunction

function! s:node.set_next(node) dict abort
  let self.next = a:node
  if !s:is_none(a:node)
    let a:node.prev = self
  endif
endfunction

function! s:node.set_prev(node) dict abort
  let self.prev = a:node
  if !s:is_none(a:node)
    let a:node.next = self
  endif
endfunction

let s:linkedlist = {'head': s:none, 'end': s:none}

function! s:linkedlist.new() dict abort
  return deepcopy(self)
endfunction

function! s:linkedlist.find_next() dict abort
  " code
endfunction

function! s:linkedlist.find_prev() dict abort
  " code
endfunction

function! s:linkedlist.find_curr() dict abort
  let index = s:linkedlist.index
  let bufnr = index.data.bufnr
  if !bufexists(bufnr)
    return self.find_next()
  endif
  return bufnr
endfunction

function! floaterm#linkedlist#new() abort
  return s:linkedlist.new()
endfunction

function! s:linkedlist.add_first(data) dict abort
  " let new_node = s:node.new()
  " call new_node.set_next(self.head)
endfunction

function! s:linkedlist.add_last(data) abort
  " code
endfunction

function! s:linkedlist.remove_first() dict abort
  " code
endfunction

function! s:linkedlist.add() abort
  " code
endfunction

function! s:linkedlist.add(index, data) dict abort
  " code
endfunction

function! s:linkedlist.to_string() abort
  let str = '['
  let current = self.head
  if !s:is_none(current)
    let str .= string(current.data)
    let current = current.next
  endif
  while !s:is_none(current)
    let str .= ', ' . string(current.data)
    let current = current.data
  endwhile
  let str .= ']'
  return str
endfunction
