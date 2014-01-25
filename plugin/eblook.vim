" vi:set ts=8 sts=2 sw=2 tw=0:
"
" plugin/eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2014-01-25

scriptencoding utf-8

if exists('plugin_eblook_disable') || exists('g:loaded_eblook')
  finish
endif
let g:loaded_eblook = 1

if !exists(":EblookSearch")
  command -range=0 -nargs=1 EblookSearch call eblook#Search(<count>, <q-args>, 0)
endif
if !exists(":EblookListGroup")
  command -count=0 EblookListGroup call eblook#ListGroup(<count>)
endif
if !exists(":EblookGroup")
  command -count=0 EblookGroup call eblook#SetDefaultGroup(<count>)
endif
if !exists(":EblookListDict")
  command -count=0 EblookListDict call eblook#ListDict(<count>)
endif
if !exists(":EblookSkipDict")
  command -range=0 -nargs=+ EblookSkipDict call eblook#SetDictSkip(<count>, 1, <f-args>)
endif
if !exists(":EblookNotSkipDict")
  command -range=0 -nargs=+ EblookNotSkipDict call eblook#SetDictSkip(<count>, 0, <f-args>)
endif
if !exists(":EblookPasteDictList")
  command -count=0 EblookPasteDictList call eblook#PasteDictList(<count>)
endif

" (<Plug>EblookSearchと<Plug>EblookSearchInputにすると、
"  <Plug>EblookSearchの方が|'timeout'|待ちになる)
noremap <unique> <script> <Plug>EblookInput <SID>Input
noremap <SID>Input :<C-U>call eblook#SearchInput(v:count, g:eblook_group, 0)<CR>
nnoremap <unique> <script> <Plug>EblookSearch <SID>SearchN
nnoremap <silent> <SID>SearchN :<C-U>call eblook#Search(v:count, expand('<cword>'), 0)<CR>
vnoremap <unique> <script> <Plug>EblookSearch <SID>SearchV
vnoremap <silent> <SID>SearchV :<C-U>call eblook#SearchVisual(v:count)<CR>

if !get(g:, 'eblook_no_default_key_mappings', 0)
  let s:set_mapleader = 0
  if !exists('g:mapleader')
    let g:mapleader = "\<C-K>"
    let s:set_mapleader = 1
  endif
  if !hasmapto('<Plug>EblookInput')
    map <unique> <Leader><C-Y> <Plug>EblookInput
  endif
  if !hasmapto('<Plug>EblookSearch', 'n')
    nmap <unique> <Leader>y <Plug>EblookSearch
  endif
  if !hasmapto('<Plug>EblookSearch', 'v')
    vmap <unique> <Leader>y <Plug>EblookSearch
  endif
  if s:set_mapleader
    unlet g:mapleader
  endif
  unlet s:set_mapleader
endif
