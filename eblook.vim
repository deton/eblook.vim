" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Revision: $Id: eblook.vim,v 1.4 2003/06/02 14:08:21 deton Exp $

scriptencoding cp932

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)

let s:entrybufname = '__eblook__entry__'
let s:contentbufname = '__eblook__content__'

" マッピングを有効化
function! s:MappingOn()
  let set_mapleader = 0
  if !exists('g:mapleader')
    let g:mapleader = "\<C-K>"
    let set_mapleader = 1
  endif
  let s:mapleader = g:mapleader
  nnoremap <silent> <Leader><C-Y> :<C-U>call <SID>SearchInput()<CR>
  nnoremap <silent> <Leader>y :<C-U>call <SID>Search(expand('<cword>'))<CR>
  if set_mapleader
    unlet g:mapleader
  endif

  augroup Eblook
  autocmd!
  execute "autocmd BufReadCmd " . s:entrybufname . " call <SID>Empty_BufReadCmd()"
  execute "autocmd BufReadCmd " . s:contentbufname . " call <SID>Empty_BufReadCmd()"
  augroup END
endfunction

" マッピングを無効化
function! s:MappingOff()
  let set_mapleader = 0
  if !exists('g:mapleader')
    let g:mapleader = "\<C-K>"
    let set_mapleader = 1
  else
    let save_mapleader = g:mapleader
  endif
  let g:mapleader = s:mapleader
  silent! nunmap <Leader><C-Y>
  silent! nunmap <Leader>y
  if set_mapleader
    unlet g:mapleader
  else
    let g:mapleader = save_mapleader
  endif

  augroup Eblook
  autocmd!
  augroup END
endfunction

call s:MappingOn()

" file name to store commands for eblook
let s:cmdfile = tempname()

" 空のバッファを作る
function! s:Empty_BufReadCmd()
endfunction

" プロンプトを出して、ユーザから入力された文字列を検索する
function! s:SearchInput()
  let str = input('eblook: ', expand('<cword>'))
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
endfunction

" execute eblook's search command
" @param key string to search
function! s:Search(key)
  call s:OpenBuffer(s:entrybufname)
  execute 'redir! >' . s:cmdfile
  let i = 1
  while exists("g:eblook_dict{i}")
    let dname = g:eblook_dict{i}
    silent echo 'select ' . dname
    silent echo 'set prompt "eblook-' . dname . '> "'
    silent echo 'search ' . a:key . "\n"
    let i = i + 1
  endwhile
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs
  silent! execute ':1/eblook-' . dname . '/;/^eblook/-1s/^/' . dname . '  '
  silent! :%s/eblook.*> //g
  silent! :g/^$/d
  normal! 1G
  call s:GetContent(1)
endfunction

let s:dictname = ''

" content表示
" @param in_entry_buf entryバッファからcontent表示が実行されたかどうか
function! s:GetContent(in_entry_buf)
  let str = getline('.')
  let pos = matchstr(str, '[0-9a-f]\+:[0-9a-f]\+')
  if strlen(pos) == 0
    return
  endif
  if a:in_entry_buf
    let dname = matchstr(str, '^[^ ]\+')
    if strlen(dname) == 0 || !s:IsValidDictName(dname)
      let s:dictname = ''
      return
    endif
    let s:dictname = dname
  endif
  if strlen(s:dictname) == 0
    return
  endif
  call s:OpenBuffer(s:contentbufname)
  execute 'redir! >' . s:cmdfile
  "silent echo 'set prompt ""'
  silent echo 'select ' . s:dictname
  silent echo 'content ' . pos . "\n"
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs
  silent! :%s/eblook> //g
  silent! :g/^$/d
  normal! 1G
  if a:in_entry_buf
    execute "normal! \<C-W>p"
  endif
endfunction

function! s:IsValidDictName(dname)
  let i = 1
  while exists("g:eblook_dict{i}")
    if a:dname ==# g:eblook_dict{i}
      return 1
    endif
    let i = i + 1
  endwhile
  return 0
endfunction

function! s:ToggleContentWindow()
  if s:SelectWindowByName(s:contentbufname) < 0
    execute "silent normal! :split " . s:contentbufname . "\<CR>"
  else
    quit!
  endif
endfunction

function! s:GoContentWindow()
  if s:SelectWindowByName(s:contentbufname) < 0
    execute "silent normal! :split " . s:contentbufname . "\<CR>"
  endif
endfunction

function! s:GoEntryWindow()
  if s:SelectWindowByName(s:entrybufname) < 0
    execute "silent normal! :split " . s:entrybufname . "\<CR>"
  endif
endfunction

" contentウィンドウをスクロールする。
" @param down 1の場合下に、0の場合上に。
function! s:ScrollContent(down)
  call s:GoContentWindow()
  if a:down
    execute "normal! \<PageDown>"
  else
    execute "normal! \<PageUp>"
  endif
  execute "normal! \<C-W>p"
endfunction

function! s:Quit()
  if s:SelectWindowByName(s:contentbufname) >= 0
    quit!
  endif
  if s:SelectWindowByName(s:entrybufname) >= 0
    quit!
  endif
endfunction

function! s:OpenBuffer(bufname)
  if s:SelectWindowByName(a:bufname) < 0
    execute "silent normal! :split " . a:bufname . "\<CR>"
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    if a:bufname ==# s:entrybufname
      nnoremap <buffer> <silent> <CR> :call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> n j:call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> p k:call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> v :call <SID>ToggleContentWindow()<CR>
      nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
      nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
      nnoremap <buffer> <silent> f :call <SID>SearchInput()<CR>
      nnoremap <buffer> <silent> h :call <SID>GoContentWindow()<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
    else
      nnoremap <buffer> <silent> <CR> :call <SID>GetContent(0)<CR>
      nnoremap <buffer> <silent> <Space> <PageDown>
      nnoremap <buffer> <silent> <BS> <PageUp>
      nnoremap <buffer> <silent> h :call <SID>GoEntryWindow()<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
    endif
  endif
  execute "normal! :%d\<CR>5\<C-W>\<C-_>"
endfunction

" SelectWindowByName(name)
"   Acitvate selected window by a:name.
function! s:SelectWindowByName(name)
  let num = bufwinnr(a:name)
  if num >= 0 && num != winnr()
    execute 'normal! ' . num . "\<C-W>\<C-W>"
  endif
  return num
endfunction
