" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Revision: $Id: eblook.vim,v 1.12 2003/06/06 14:13:02 deton Exp $

scriptencoding cp932

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)

let s:entrybufname = '_eblook_entry_'
let s:contentbufname = '_eblook_content_'

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
  execute "autocmd BufReadCmd " . s:entrybufname . "* call <SID>Empty_BufReadCmd()"
  execute "autocmd BufReadCmd " . s:contentbufname . "* call <SID>Empty_BufReadCmd()"
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

" 保持しておく過去の検索バッファ数の上限
let s:history_max = 10
" entryバッファヒストリ中の現在位置
let s:entrybuf_index = 0
" contentバッファヒストリ中の現在位置
let s:contentbuf_index = 0

" 空のバッファを作る
function! s:Empty_BufReadCmd()
endfunction

" プロンプトを出して、ユーザから入力された文字列を検索する
function! s:SearchInput()
  let str = input('eblook: ')
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
endfunction

" execute eblook's search command
" @param key string to search
function! s:Search(key)
  call s:NewEntryBuffer()
  execute 'redir! >' . s:cmdfile
  let prev_book = ''
  let i = 1
  while exists("g:eblook_dict{i}_name")
    let dname = g:eblook_dict{i}_name
    if exists("g:eblook_dict{i}_book") && g:eblook_dict{i}_book !=# prev_book
      silent echo 'book ' . g:eblook_dict{i}_book
      let prev_book = g:eblook_dict{i}_book
    endif
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

  silent! :g/^Warning: you should specify a book directory first$/d
  silent! :%s/eblook.*> \(eblook.*> \)/\1/g
  let i = 1
  while exists("g:eblook_dict{i}_name")
    let dname = g:eblook_dict{i}_name
    let title = g:eblook_dict{i}_title
    silent! execute ':1/eblook-' . dname . '/;/^eblook/-1s/^/' . title . "\t"
    let i = i + 1
  endwhile
  silent! :%s/eblook.*> //g
  silent! :g/^$/d
  normal! 1G
  if s:GetContent(1) < 0
    let v:errmsg = ''
    silent! :%s/./&/g
    if strlen(v:errmsg) > 0
      bwipeout!
      call s:EntryHistory(-1)
      echomsg 'eblook-vim: pattern not found: <' . a:key . '>'
    endif
  endif
endfunction

" content表示
" @param in_entry_buf entryバッファからcontent表示が実行されたかどうか
" @return -1:content表示失敗, 0:表示成功
function! s:GetContent(in_entry_buf)
  let str = getline('.')
  if a:in_entry_buf
    let title = matchstr(str, '^[^\t]\+')
    if strlen(title) == 0
      return -1
    endif
    let did = s:GetDictIdFromTitle(title)
    if did <= 0
      return -1
    endif
  endif

  let refpat = '[[:xdigit:]]\+:[[:xdigit:]]\+'
  let pos = matchstr(str, refpat)
  " contentバッファの場合は<reference>を取得
  if !a:in_entry_buf
    let m1 = matchend(str, refpat)
    if m1 < 0
      return -1
    endif
    " <reference>が1行に2つ以上ある場合は、カーソルが位置する方を使う
    let m2 = match(str, refpat, m1)
    if m2 >= 0
      let col = col('.')
      let offset = strridx(strpart(str, 0, col), '<')
      if offset >= 0
	let pos = matchstr(str, refpat, offset)
      endif
    endif
  endif
  if strlen(pos) == 0
    return -1
  endif

  call s:OpenBuffer(s:contentbufname)
  if exists("did") && did > 0
    let b:dictid = did
  endif
  execute 'redir! >' . s:cmdfile
  if exists("g:eblook_dict{b:dictid}_book")
    silent echo 'book ' . g:eblook_dict{b:dictid}_book
  endif
  silent echo 'select ' . g:eblook_dict{b:dictid}_name
  silent echo 'content ' . pos . "\n"
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs

  silent! :g/^Warning: you should specify a book directory first$/d
  silent! :%s/eblook> //g
  silent! :g/^$/d
  normal! 1G
  if a:in_entry_buf
    execute "normal! \<C-W>p"
  endif
  return 0
endfunction

function! s:GetDictIdFromTitle(title)
  let i = 1
  while exists("g:eblook_dict{i}_title")
    if a:title ==# g:eblook_dict{i}_title
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

function! s:ToggleContentWindow()
  if s:SelectWindowByName(s:contentbufname) < 0
    execute "silent normal! :split " . s:contentbufname . "\<CR>"
  else
    quit!
  endif
endfunction

function! s:GoWindow(is_entry_buf)
  if a:is_entry_buf
    let bufname = s:entrybufname . s:entrybuf_index
  else
    let bufname = s:contentbufname
  endif
  if s:SelectWindowByName(bufname) < 0
    execute "silent normal! :split " . bufname . "\<CR>"
  endif
endfunction

" contentウィンドウをスクロールする。
" @param down 1の場合下に、0の場合上に。
function! s:ScrollContent(down)
  call s:GoWindow(0)
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
  if s:SelectWindowByName(s:entrybufname . s:entrybuf_index) >= 0
    hide
  endif
endfunction

" entryバッファのヒストリをたどる
" @param dir -1:古い方向へ, 1:新しい方向へ
function! s:EntryHistory(dir)
  let prevbufname = s:entrybufname . s:entrybuf_index
  if a:dir > 0
    let nextbufindex = s:NextEntryBufIndex()
    if !bufexists(s:entrybufname . nextbufindex)
      echomsg 'eblook-vim: not exists next entry buffer'
      return
    endif
  else
    let nextbufindex = s:PrevEntryBufIndex()
    if !bufexists(s:entrybufname . nextbufindex)
      echomsg 'eblook-vim: not exists previous entry buffer'
      return
    endif
  endif
  let s:entrybuf_index = nextbufindex
  if s:SelectWindowByName(prevbufname) < 0
    execute "silent normal! :sbuffer " . s:entrybufname . nextbufindex . "\<CR>"
  else
    execute "silent normal! :buffer " . s:entrybufname . nextbufindex . "\<CR>"
  endif
endfunction

function! s:NextEntryBufIndex()
  let i = s:entrybuf_index + 1
  if i > s:history_max
    let i = 1
  endif
  return i
endfunction

function! s:PrevEntryBufIndex()
  let i = s:entrybuf_index - 1
  if i < 1
    let i = s:history_max
  endif
  return i
endfunction

function! s:NewEntryBuffer()
  let oldbufname = s:entrybufname . s:entrybuf_index
  let s:entrybuf_index = s:NextEntryBufIndex()
  let newbufname = s:entrybufname . s:entrybuf_index
  if bufexists(newbufname)
    let bufexists = 1
  else
    let bufexists = 0
  endif
  if s:SelectWindowByName(oldbufname) < 0
    if bufexists
      execute "silent normal! :sbuffer " . newbufname . "\<CR>"
    else
      execute "silent normal! :split " . newbufname . "\<CR>"
    endif
  else
    if bufexists
      execute "silent normal! :buffer " . newbufname . "\<CR>"
    else
      execute "silent normal! :edit " . newbufname . "\<CR>"
    endif
  endif
  if bufexists
    silent execute "normal! :%d\<CR>"
  else
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    set nobuflisted
    nnoremap <buffer> <silent> <CR> :call <SID>GetContent(1)<CR>
    nnoremap <buffer> <silent> J j:call <SID>GetContent(1)<CR>
    nnoremap <buffer> <silent> K k:call <SID>GetContent(1)<CR>
    nnoremap <buffer> <silent> x :call <SID>ToggleContentWindow()<CR>
    nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
    nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
    nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
    nnoremap <buffer> <silent> r :call <SID>GoWindow(0)<CR>
    nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
    nnoremap <buffer> <silent> <C-P> :call <SID>EntryHistory(-1)<CR>
    nnoremap <buffer> <silent> <C-N> :call <SID>EntryHistory(1)<CR>
  endif
  silent execute "normal! 4\<C-W>_"
endfunction

function! s:OpenBuffer(bufname)
  if s:SelectWindowByName(a:bufname) < 0
    execute "silent normal! :split " . a:bufname . "\<CR>"
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    if a:bufname ==# s:entrybufname
      nnoremap <buffer> <silent> <CR> :call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> J j:call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> K k:call <SID>GetContent(1)<CR>
      nnoremap <buffer> <silent> x :call <SID>ToggleContentWindow()<CR>
      nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
      nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
      nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
      nnoremap <buffer> <silent> r :call <SID>GoWindow(0)<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
    else
      nnoremap <buffer> <silent> <CR> :call <SID>GetContent(0)<CR>
      nnoremap <buffer> <silent> <Space> <PageDown>
      nnoremap <buffer> <silent> <BS> <PageUp>
      nnoremap <buffer> <silent> <Tab> /<reference/<CR>
      nnoremap <buffer> <silent> r :call <SID>GoWindow(1)<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
    endif
  endif
  silent execute "normal! :%d\<CR>"
  if a:bufname ==# s:entrybufname
    silent execute "normal! 4\<C-W>\<C-_>"
  endif
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
