" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Revision: $Id: eblook.vim,v 1.23 2003/06/12 14:04:05 deton Exp $

scriptencoding cp932

" Description:
"   `eblook'プログラムを使ってEPWING/電子ブック辞書を検索する。
"   このスクリプトを使うためには、
"   `eblook'プログラム<http://openlab.jp/edict/eblook/>とEPWING辞書が必要。
"
"   <Leader><C-Y>を押して検索語を入力すると、検索結果がentryウィンドウと
"   contentウィンドウに表示される。
"
" コマンド:
"   :EblookSearch       指定した単語の検索を行う
"   :EblookListDict     辞書の一覧を表示する
"   :EblookSkipDict     指定した辞書番号の辞書を一時的に検索対象から外す
"   :EblookNotSkipDict  指定した辞書番号の辞書を一時的に検索対象に入れる
"
" nmap:
"   <Leader><C-Y>       検索単語を入力して検索を行う
"   <Leader>y           カーソル位置にある単語を検索する
"
" entryバッファのnmap
"   <CR>                カーソル行のentryに対応するcontentを表示する
"   J                   カーソルを下の行に移動してcontentを表示する
"   K                   カーソルを上の行に移動してcontentを表示する
"   <Space>             contentウィンドウでPageDownを行う
"   <BS>                contentウィンドウでPageUpを行う
"   q                   entryウィンドウとcontentウィンドウを閉じる
"   s                   新しい単語を入力して検索する(<Leader><C-Y>と同じ)
"   p                   contentウィンドウに移動する
"   R                   reference一覧を表示する
"   <C-P>               検索履歴中の一つ前のバッファを表示する
"   <C-N>               検索履歴中の一つ次のバッファを表示する
"
" contentバッファのnmap
"   <CR>                カーソル位置のreferenceを表示する
"   <Space>             PageDownを行う
"   <BS>                PageUpを行う
"   <Tab>               次のreferenceにカーソルを移動する
"   q                   entryウィンドウとcontentウィンドウを閉じる
"   s                   新しい単語を入力して検索する(<Leader><C-Y>と同じ)
"   p                   entryウィンドウに移動する
"   R                   reference一覧を表示する
"   <C-P>               検索履歴中の一つ前のバッファを表示する
"   <C-N>               検索履歴中の一つ次のバッファを表示する
"
" オプション:
"    'eblook_dict{n}_title'
"    'eblook_dict{n}_book'
"    'eblook_dict{n}_name'
"    'eblook_dict{n}_skip'
"       EPWING辞書の設定。{n}は1, 2, 3, ...。使いたい辞書分指定する。
"       ここで指定した数字(辞書番号)の順に検索を行う。
"       数字は連続している必要がある。
"       eblook_dict{n}_skip以外は必須。
"
"      'eblook_dict{n}_title'
"         辞書の識別子を指定。entryウィンドウ中で辞書を識別するために使う。
"         (eblook.vim内部では辞書番号かtitleで辞書を識別する。)
"         辞書を識別するために使うだけなので、
"         他の辞書とぶつからない文字列を適当につける。
"         例:
"           let eblook_dict1_title = '広辞苑第五版'
"
"      'eblook_dict{n}_book'
"         eblookプログラムの`book'コマンドに渡すパラメータ。
"         辞書のあるディレクトリ(catalogsファイルのあるディレクトリ)を指定。
"         Appendixがある場合は、
"         辞書ディレクトリに続けてAppendixディレクトリを指定。
"         例:
"           let eblook_dict1_book = '/usr/local/epwing'
"
"      'eblook_dict{n}_name'
"         eblookプログラムの`select'コマンドに渡すパラメータ。
"         辞書名を指定。eblookプログラムのlistコマンドで調べる。
"         例:
"           let eblook_dict1_name = 'kojien'
"
"      'eblook_dict{n}_skip'
"         0でない値を設定すると、この辞書は検索しない。
"         例:
"           let eblook_dict1_skip = 1
"
"
"    'eblook_history_max'
"       保持しておく過去の検索履歴バッファ数の上限。省略値: 10
"
"    'mapleader'
"       キーマッピングのプレフィックス。|mapleader|を参照。省略値: CTRL-K
"       CTRL-Kを指定する場合の例:
"         let mapleader = "\<C-K>"
"
"    'plugin_eblook_disable'
"       このプラグインを読み込みたくない場合に次のように設定する。
"         let plugin_eblook_disable = 1

if exists('plugin_eblook_disable')
  finish
endif

" 保持しておく過去の検索バッファ数の上限
if !exists('eblook_history_max')
  let eblook_history_max = 10
endif

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)
command! EblookListDict call <SID>ListDict()
command! -nargs=* EblookSkipDict call <SID>SetDictSkip(1, <f-args>)
command! -nargs=* EblookNotSkipDict call <SID>SetDictSkip(0, <f-args>)

" entryバッファ名のベース
let s:entrybufname = '_eblook_entry_'
" contentバッファ名のベース
let s:contentbufname = '_eblook_content_'
" </reference=>で指定されるentryのpattern
let s:refpat = '[[:xdigit:]]\+:[[:xdigit:]]\+'
" eblookにリダイレクトするコマンドを保持する一時ファイル名
let s:cmdfile = tempname()
" バッファヒストリ中の現在位置
let s:bufindex = 0

" マッピング
let s:set_mapleader = 0
if !exists('g:mapleader')
  let g:mapleader = "\<C-K>"
  let s:set_mapleader = 1
endif
nnoremap <silent> <Leader><C-Y> :<C-U>call <SID>SearchInput()<CR>
nnoremap <silent> <Leader>y :<C-U>call <SID>Search(expand('<cword>'))<CR>
if s:set_mapleader
  unlet g:mapleader
endif
unlet s:set_mapleader

augroup Eblook
autocmd!
execute "autocmd BufReadCmd " . s:entrybufname . "* call <SID>Empty_BufReadCmd()"
execute "autocmd BufReadCmd " . s:contentbufname . "* call <SID>Empty_BufReadCmd()"
augroup END

" 辞書のtitleが設定されていなかったら、辞書番号とnameを設定しておく
let s:i = 1
while exists("g:eblook_dict{s:i}_name")
  if !exists("g:eblook_dict{s:i}_title")
    let g:eblook_dict{s:i}_title = s:i . g:eblook_dict{s:i}_name
  endif
  let s:i = s:i + 1
endwhile
unlet s:i

" プロンプトを出して、ユーザから入力された文字列を検索する
function! s:SearchInput()
  let str = input('eblook: ')
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
endfunction

" 指定された単語の検索を行う。
" entryバッファに検索結果のリストを表示し、
" そのうち先頭のentryの内容をcontentバッファに表示する。
" @param key 検索する単語
function! s:Search(key)
  let hasoldwin = bufwinnr(s:entrybufname . s:bufindex)
  if hasoldwin < 0
    let hasoldwin = bufwinnr(s:contentbufname . s:bufindex)
  endif
  call s:NewBuffers()
  execute 'redir! >' . s:cmdfile
  let prev_book = ''
  let i = 1
  while exists("g:eblook_dict{i}_name")
    if exists("g:eblook_dict{i}_skip") && g:eblook_dict{i}_skip
      let i = i + 1
      continue
    endif
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
  " &encがeuc-jpで&fencsにcp932が入っている場合、検索結果が短いと、eblookは
  " euc-jpで結果を返しているのにcp932とみなされて文字化けすることがあるので、
  " 一時的に&fecnsには&encだけ入れてeblookプログラムの結果を読み込む。
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
  if s:GetContent() < 0
    let v:errmsg = ''
    silent! :%s/./&/g
    if strlen(v:errmsg) > 0
      bwipeout!
      silent! call s:History(-1)
      if hasoldwin < 0
	call s:Quit()
      endif
      echomsg 'eblook-vim: 何も見つかりませんでした: <' . a:key . '>'
    endif
  endif
endfunction

" 新しく検索を行うために、entryバッファとcontentバッファを作る。
function! s:NewBuffers()
  " entryバッファとcontentバッファは一対で扱う。
  let oldindex = s:bufindex
  let s:bufindex = s:NextBufIndex()
  call s:CreateBuffer(s:entrybufname, oldindex)
  call s:CreateBuffer(s:contentbufname, oldindex)
  execute "normal! \<C-W>p4\<C-W>_"
endfunction

" entryバッファかcontentバッファのいずれかを作る
" @param bufname s:entrybufnameかs:contentbufnameのいずれか
" @param oldindex 現在のentry,contentバッファのインデックス番号
function! s:CreateBuffer(bufname, oldindex)
  let oldbufname = a:bufname . a:oldindex
  let newbufname = a:bufname . s:bufindex
  if bufexists(newbufname)
    let bufexists = 1
  else
    let bufexists = 0
  endif
  if a:bufname ==# s:entrybufname
    call s:OpenEntryWindow(a:oldindex)
    let cmd = 'edit '
  else
    if s:SelectWindowByName(oldbufname) < 0
      let cmd = 'split '
    else
      let cmd = 'edit '
    endif
  endif
  execute 'silent normal! :' . cmd . newbufname . "\<CR>"
  if bufexists
    silent execute "normal! :%d\<CR>"
  else
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    set nobuflisted
    if a:bufname ==# s:entrybufname
      nnoremap <buffer> <silent> <CR> :call <SID>GetContent()<CR>
      nnoremap <buffer> <silent> J j:call <SID>GetContent()<CR>
      nnoremap <buffer> <silent> K k:call <SID>GetContent()<CR>
      nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
      nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
      nnoremap <buffer> <silent> <Tab> /[[:xdigit:]]\+:[[:xdigit:]]\+<CR>
      nnoremap <buffer> <silent> p :call <SID>GoWindow(0)<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
      nnoremap <buffer> <silent> R :call <SID>ListReferences()<CR>
      nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
      nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>
      nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>
    else
      let b:dictnum = -1
      let b:refid = ''
      nnoremap <buffer> <silent> <CR> :call <SID>SelectReference()<CR>
      nnoremap <buffer> <silent> <Space> <PageDown>
      nnoremap <buffer> <silent> <BS> <PageUp>
      nnoremap <buffer> <silent> <Tab> /<reference/<CR>
      nnoremap <buffer> <silent> p :call <SID>GoWindow(1)<CR>
      nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
      nnoremap <buffer> <silent> R :call <SID>FollowReference('')<CR>
      nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
      nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
      nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
    endif
  endif
endfunction

" entryバッファのカーソル行に対応する内容をcontentバッファに表示する
" @return -1:content表示失敗, 0:表示成功
function! s:GetContent()
  let str = getline('.')
  let title = matchstr(str, '^[^\t]\+')
  if strlen(title) == 0
    return -1
  endif
  let dnum = s:GetDictNumFromTitle(title)
  if dnum <= 0
    return -1
  endif
  let refid = matchstr(str, s:refpat)
  if strlen(refid) == 0
    return -1
  endif

  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    execute "silent normal! :split " . s:contentbufname . s:bufindex . "\<CR>"
  endif
  if b:dictnum == dnum && b:refid ==# refid
    execute "normal! \<C-W>p"
    return 0
  endif

  silent execute "normal! :%d\<CR>"
  let b:dictnum = dnum
  let b:refid = refid
  execute 'redir! >' . s:cmdfile
  if exists("g:eblook_dict{b:dictnum}_book")
    silent echo 'book ' . g:eblook_dict{b:dictnum}_book
  endif
  silent echo 'select ' . g:eblook_dict{b:dictnum}_name
  silent echo 'content ' . refid . "\n"
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs

  silent! :g/^Warning: you should specify a book directory first$/d
  silent! :%s/eblook> //g
  silent! :g/^$/d
  normal! 1G
  execute "normal! \<C-W>p"
  return 0
endfunction

" contentバッファ中のカーソル位置付近の<reference>を抽出して、
" その内容を表示する。
function! s:SelectReference()
  let str = getline('.')
  let refid = matchstr(str, s:refpat)
  let m1 = matchend(str, s:refpat)
  if m1 < 0
    return
  endif
  " <reference>が1行に2つ以上ある場合は、カーソルが位置する方を使う
  let m2 = match(str, s:refpat, m1)
  if m2 >= 0
    let col = col('.')
    let offset = strridx(strpart(str, 0, col), '<')
    if offset >= 0
      let refid = matchstr(str, refpat, offset)
    endif
  endif
  if strlen(refid) == 0
    return
  endif
  call s:FollowReference(refid)
endfunction

" entryバッファでカーソル行のエントリに含まれる<reference>のリストを表示
function! s:ListReferences()
  call s:GetContent()
  call s:FollowReference('')
endfunction

" <reference>をリストアップしてentryバッファに表示し、
" 指定された<reference>の内容をcontentバッファに表示する。
" @param refid 表示する内容を示す文字列。''の場合はリストの最初のものを表示
function! s:FollowReference(refid)
  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    execute "silent normal! :split " . s:contentbufname . s:bufindex . "\<CR>"
  endif
  let dnum = b:dictnum
  let save_line = line('.')
  let save_col = col('.')
  " ggでバッファ先頭に移動してからsearch()で検索すると、
  " バッファ冒頭の検索対象文字列にヒットしないので、末尾からwrap aroundして検索
  normal! G$
  let searchflag = 'w'
  let i = 1
  while search('<reference>', searchflag) > 0
    let line = getline('.')
    let col = col('.') - 1
    let label{i} = matchstr(line, '<reference>\zs.\{-}\ze</reference', col)
    let entry{i} = matchstr(line, s:refpat, col)
    let i = i + 1
    let searchflag = 'W'
  endwhile
  if i <= 1
    return
  endif
  execute 'normal! ' . save_line . 'G' . save_col . '|'

  call s:NewBuffers()
  let j = 1
  while j < i
    execute 'normal! o' . g:eblook_dict{dnum}_title . "\<Tab>" . entry{j} . "\<Tab>" . label{j} . "\<Esc>"
    let j = j + 1
  endwhile
  silent! :g/^$/d

  normal! gg
  if strlen(a:refid) > 0
    execute 'normal! /' . a:refid . "\<CR>"
  endif
  call s:GetContent()
endfunction

" バッファのヒストリをたどる。
" @param dir -1:古い方向へ, 1:新しい方向へ
function! s:History(dir)
  let prevcontentbufname = s:contentbufname . s:bufindex
  if a:dir > 0
    let ni = s:NextBufIndex()
    if !bufexists(s:entrybufname . ni) || !bufexists(s:contentbufname . ni)
      echomsg 'eblook-vim: 次のバッファはありません'
      return
    endif
  else
    let ni = s:PrevBufIndex()
    if !bufexists(s:entrybufname . ni) || !bufexists(s:contentbufname . ni)
      echomsg 'eblook-vim: 前のバッファはありません'
      return
    endif
  endif
  call s:OpenEntryWindow(s:bufindex)
  let s:bufindex = ni
  execute "silent normal! :edit " . s:entrybufname . ni . "\<CR>"
  if s:SelectWindowByName(prevcontentbufname) < 0
    execute "silent normal! :split " . s:contentbufname . ni . "\<CR>"
  else
    execute "silent normal! :edit " . s:contentbufname . ni . "\<CR>"
  endif
  execute "normal! \<C-W>p"
endfunction

" 次のバッファのインデックス番号を返す
" @return 次のバッファのインデックス番号
function! s:NextBufIndex()
  let i = s:bufindex + 1
  if i > g:eblook_history_max
    let i = 1
  endif
  return i
endfunction

" 前のバッファのインデックス番号を返す
" @return 前のバッファのインデックス番号
function! s:PrevBufIndex()
  let i = s:bufindex - 1
  if i < 1
    let i = g:eblook_history_max
  endif
  return i
endfunction

" entryウィンドウとcontentウィンドウを隠す
function! s:Quit()
  if s:SelectWindowByName(s:contentbufname . s:bufindex) >= 0
    hide
  endif
  if s:SelectWindowByName(s:entrybufname . s:bufindex) >= 0
    hide
  endif
endfunction

" entryウィンドウからcontentウィンドウをスクロールする。
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

" entryウィンドウ/contentウィンドウに移動する
" @param to_entry_buf 1:entryウィンドウに移動, 0:contentウィンドウに移動
function! s:GoWindow(to_entry_buf)
  if a:to_entry_buf
    call s:OpenEntryWindow(s:bufindex)
  else
    let bufname = s:contentbufname . s:bufindex
    if s:SelectWindowByName(bufname) < 0
      execute "silent normal! :split " . bufname . "\<CR>"
    endif
  endif
endfunction

" title文字列から辞書番号を返す
" @param title 辞書のtitle文字列
" @return 辞書番号
function! s:GetDictNumFromTitle(title)
  let i = 1
  while exists("g:eblook_dict{i}_title")
    if a:title ==# g:eblook_dict{i}_title
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

" 辞書一覧を表示する
function! s:ListDict()
  let i = 1
  while exists("g:eblook_dict{i}_name")
    let skip = ''
    if exists("g:eblook_dict{i}_skip") && g:eblook_dict{i}_skip
      let skip = 'skip'
    endif
    let title = g:eblook_dict{i}_title
    let dname = g:eblook_dict{i}_name
    let book = ''
    if exists("g:eblook_dict{i}_book")
      let book = g:eblook_dict{i}_book
    endif
    echo skip . "\t" . i . "\t" . title . "\t" . dname . "\t" . book
    let i = i + 1
  endwhile
endfunction

" 辞書をスキップするかどうかを一時的に設定する。
" @param is_skip スキップするかどうか。1:スキップする, 0:スキップしない
" @param ... 辞書番号のリスト
function! s:SetDictSkip(is_skip, ...)
  let i = 1
  while i <= a:0
    if a:is_skip
      let g:eblook_dict{a:{i}}_skip = 1
    else
      unlet! g:eblook_dict{a:{i}}_skip
    endif
    let i = i + 1
  endwhile
endfunction

" entryウィンドウを開く
" @param index 開くバッファのインデックス番号
function! s:OpenEntryWindow(index)
  let bufname = s:entrybufname . a:index
  if s:SelectWindowByName(bufname) < 0
    let cmd = ''
    " entryバッファとcontentバッファの位置が上下逆になったりしないようにする
    if s:SelectWindowByName(s:contentbufname . a:index) > 0
      if &splitbelow
	let cmd = 'aboveleft '
      else
	let cmd = 'belowright '
      endif
    endif
    let cmd = cmd . 'split '
    execute 'silent normal! :' . cmd . bufname . "\<CR>"
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

" 空のバッファを作る
function! s:Empty_BufReadCmd()
endfunction
