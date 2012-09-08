" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2012-09-08
" License: MIT License {{{
" Copyright (c) 2012 KIHARA, Hideto
"
" Permission is hereby granted, free of charge, to any person obtaining a copy of
" this software and associated documentation files (the "Software"), to deal in
" the Software without restriction, including without limitation the rights to
" use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
" the Software, and to permit persons to whom the Software is furnished to do so,
" subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
" FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
" COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
" IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
" CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

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
"   :EblookSearch         指定した単語の検索を行う
"   :EblookListGroup      辞書グループの一覧を表示する
"   :EblookGroup          count非指定時の検索対象辞書グループ番号を設定
"   :EblookListDict       辞書の一覧を表示する
"   :EblookSkipDict       指定した辞書番号の辞書を一時的に検索対象から外す
"   :EblookNotSkipDict    指定した辞書番号の辞書を一時的に検索対象に入れる
"   :EblookPasteDictList  辞書設定をペーストする(eblook-vim-1.1.0への移行用)
"
" nmap:
"   <Leader><C-Y>       検索単語を入力して検索を行う
"   <Leader>y           カーソル位置にある単語を検索する
"
" vmap:
"   <Leader>y           選択した文字列を検索する
"
" entryバッファのnmap
"   <CR>                カーソル行のentryに対応するcontentを表示する
"   J                   カーソルを下の行に移動してcontentを表示する
"   K                   カーソルを上の行に移動してcontentを表示する
"   <Space>             contentウィンドウでPageDownを行う
"   <BS>                contentウィンドウでPageUpを行う
"   q                   entryウィンドウとcontentウィンドウを閉じる
"   s                   新しい単語を入力して検索する(<Leader><C-Y>と同じ)
"   S                   直前の検索語を[count]で指定する辞書グループで再検索する
"   p                   contentウィンドウに移動する
"   R                   reference一覧を表示する
"   <C-P>               検索履歴中の一つ前のバッファを表示する
"   <C-N>               検索履歴中の一つ次のバッファを表示する
"   O                   contentウィンドウ内の長い行を|gq|で整形する
"   o                   contentウィンドウを最大化する
"
" contentバッファのnmap
"   <CR>                カーソル位置のreferenceを表示する
"   <Space>             PageDownを行う
"   <BS>                PageUpを行う
"   <Tab>               次のreferenceにカーソルを移動する
"   <S-Tab>             前のreferenceにカーソルを移動する
"   q                   entryウィンドウとcontentウィンドウを閉じる
"   s                   新しい単語を入力して検索する(<Leader><C-Y>と同じ)
"   S                   直前の検索語を[count]で指定する辞書グループで再検索する
"   p                   entryウィンドウに移動する
"   R                   reference一覧を表示する
"   <C-P>               検索履歴中の一つ前のバッファを表示する
"   <C-N>               検索履歴中の一つ次のバッファを表示する
"   O                   contentウィンドウ内の長い行を|gq|で整形する
"   o                   contentウィンドウを最大化する
"
" オプション:
"    'eblook_group'
"      |[count]|が指定されていない時に検索対象にする辞書グループ番号。
"      省略値: 1
"
"    'eblook_dictlist{n}'
"      辞書グループ{n}のEPWING辞書の|List|。{n}は1以上。
"      Listの各要素は以下のkeyを持つ|Dictionary|。
"
"      'title'
"         辞書の識別子を指定。entryウィンドウ中で辞書を識別するために使う。
"         (eblook.vim内部では辞書番号かtitleで辞書を識別する。)
"         辞書を識別するために使うだけなので、
"         他の辞書とぶつからない文字列を適当につける。
"
"      'book'
"         eblookプログラムの`book'コマンドに渡すパラメータ。
"         辞書のあるディレクトリ(catalogsファイルのあるディレクトリ)を指定。
"
"      'appendix' (省略可能)
"         Appendixを使う場合は、Appendixディレクトリを指定。
"         eblookプログラムの`book'コマンドに渡す2番目のパラメータ。
"
"      'name'
"         eblookプログラムの`select'コマンドに渡すパラメータ。
"         辞書名を指定。eblookプログラムのlistコマンドで調べる。
"
"      'skip' (省略可能)
"         0でない値を設定すると、この辞書は検索しない。
"         ('skip'キーが未指定の場合は0とみなす)
"
"      'autoformat' (省略可能)
"         content表示時に長い行を|gq|で整形するかどうか。
"         ('autoformat'キーが未指定の場合は0とみなす)
"
"      例:
"        let eblook_dictlist1 = [
"          \{
"            \'title': '広辞苑第五版',
"            \'book': '/usr/local/epwing/tougou99',
"            \'name': 'kojien',
"          \},
"          \{
"            \'title': 'ジーニアス英和大辞典',
"            \'book': '/usr/local/epwing/GENIUS',
"            \'appendix': '/usr/local/epwing/appendix/genius2-1.1',
"            \'name': 'genius'
"          \},
"          \{
"            \'title': '現代用語の基礎知識',
"            \'book': '/usr/local/epwing/tougou99',
"            \'name': 'gn99ep01',
"            \'skip': 1,
"            \'autoformat': 1,
"          \},
"        \]
"
"    'eblook_stemming'
"       指定文字列で何も見つからなかった時に、活用語尾などを取り除いた
"       文字列を使って検索し直すかどうか。省略値: 0
"
"    'eblook_decorate'
"       eblook 1.6.1+mediaのdecorate-modeを有効にすると出力される、
"       content中のインデント指定に基づいて、インデントを行うかどうか。
"       省略値: 1(eblook 1.6.1+mediaの場合), 0(それ以外の場合)
"
"    'eblook_decorate_indmin'
"       この値を越えたインデント量がcontent中で指定された場合に、
"       越えた文字数分のインデントを行う。省略値: 1
"
"    'eblook_entrywin_height'
"       entryウィンドウの行数(目安)。省略値: 4
"
"    'eblook_history_max'
"       保持しておく過去の検索履歴バッファ数の上限。省略値: 10
"
"    'eblook_visited_max'
"       表示変更用に保持しておく訪問済リンク数の上限。省略値: 100
"
"    'eblook_autoformat_default'
"       contentウィンドウ内の長い行を|gq|で整形するかどうかのデフォルト値。
"       全辞書を常に整形したい場合向け(全辞書について'autoformat'プロパティ
"       を指定するのは面倒なので)。省略値: 0
"
"    'eblook_show_refindex'
"       contentウィンドウ内のreference番号をconceal syntaxを使って非表示に
"       するかどうか。省略値: 0
"
"    'eblook_statusline_entry'
"       entryウィンドウ用のstatusline。
"       省略値: %{b:group}Eblook entry {%{b:word}}%< [%L]
"
"    'eblook_statusline_content'
"       contentウィンドウ用のstatusline。
"       省略値: %{b:group}Eblook content {%{b:caption}} %{b:dtitle}%<
"
"    'eblook_viewers'
"       画像や音声再生用の外部ビューアコマンド。
"
"    'eblookprg'
"       このスクリプトから呼び出すeblookプログラムの名前。省略値: eblook
"
"    'eblookenc'
"       eblookプログラムの出力を読み込むときのエンコーディング。
"       設定可能な値は|'encoding'|参照。省略値: &encoding
"
"    '<Plug>EblookInput'
"       検索単語を入力して検索を行うためのキー。省略値: <Leader><C-Y>
"       <Leader><C-Y>を指定する場合の例:
"         map <Leader><C-Y> <Plug>EblookInput
"
"    '<Plug>EblookSearch'
"       カーソル位置にある単語(nmap)/選択した文字列(vmap)を検索するためのキー。
"       省略値: <Leader>y
"       <Leader>yを指定する場合の例:
"         map <Leader>y <Plug>EblookSearch
"
"    'mapleader'
"       キーマッピングのプレフィックス。|mapleader|を参照。省略値: CTRL-K
"       CTRL-Kを指定する場合の例:
"         let mapleader = "\<C-K>"
"
"    'plugin_eblook_disable'
"       このプラグインを読み込みたくない場合に次のように設定する。
"         let plugin_eblook_disable = 1

if exists('plugin_eblook_disable') || exists('g:loaded_eblook')
  finish
endif
let g:loaded_eblook = 1

let s:save_cpo = &cpo
set cpo&vim

" entryウィンドウの行数
if !exists('eblook_entrywin_height')
  let eblook_entrywin_height = 4
endif

" 保持しておく過去の検索バッファ数の上限
if !exists('eblook_history_max')
  let eblook_history_max = 10
endif

" 表示変更用に保持しておく訪問済リンク数の上限
if !exists('eblook_visited_max')
  let eblook_visited_max = 100
endif

if !exists('eblook_autoformat_default')
  let eblook_autoformat_default = 0
endif
if !exists('eblook_show_refindex')
  let eblook_show_refindex = 0
endif
if !exists('eblook_stemming')
  let eblook_stemming = 0
endif
if !exists('g:eblook_decorate_indmin')
  let g:eblook_decorate_indmin = 1
endif

if !exists('eblook_statusline_content')
  let eblook_statusline_content = '%{b:group}Eblook content {%{b:caption}} %{b:dtitle}%<'
endif
if !exists('eblook_statusline_entry')
  let eblook_statusline_entry = '%{b:group}Eblook entry {%{b:word}}%< [%L]'
endif

" eblookプログラムの名前
if !exists('eblookprg')
  let eblookprg = 'eblook'
endif

if !exists('eblook_viewers')
  if has('win32') || has('win64')
    " 第1引数に""を指定しないとコマンドプロンプトが開くだけ
    let eblook_viewers = {
      \'jpeg': ' start ""',
      \'bmp': ' start ""',
      \'pbm': ' start ""',
      \'wav': ' start ""',
      \'mpg': ' start ""',
    \}
  else
    " XXX: mailcapを読み込んで設定する?
    let eblook_viewers = {
      \'jpeg': 'xdg-open %s &',
      \'bmp': 'xdg-open %s &',
      \'pbm': 'xdg-open %s &',
      \'wav': 'xdg-open %s &',
      \'mpg': 'xdg-open %s &',
    \}
  endif
endif

" eblookプログラムの出力を読み込むときのエンコーディング
if !exists('eblookenc')
  let eblookenc = &encoding
endif
" eblookenc値(vimのencoding)からeblook --encodingオプション値への変換テーブル
let s:eblookenc2opt = {
\  'euc-jp': 'euc',
\  'cp932': 'sjis',
\  'sjis': 'sjis',
\  'utf-8': 'utf8',
\  'utf8': 'utf8'
\}
let s:eblookopt = ""
if has_key(s:eblookenc2opt, eblookenc)
  let s:eblookopt = '-e ' . s:eblookenc2opt[eblookenc]
endif
unlet s:eblookenc2opt

if !exists(":EblookSearch")
  command -range=0 -nargs=1 EblookSearch call <SID>Search(<count>, <q-args>, 0)
endif
if !exists(":EblookListGroup")
  command -count=0 EblookListGroup call <SID>ListGroup(<count>)
endif
if !exists(":EblookGroup")
  command -count=0 EblookGroup call <SID>SetDefaultGroup(<count>)
endif
if !exists(":EblookListDict")
  command -count=0 EblookListDict call <SID>ListDict(<count>)
endif
if !exists(":EblookSkipDict")
  command -range=0 -nargs=+ EblookSkipDict call <SID>SetDictSkip(<count>, 1, <f-args>)
endif
if !exists(":EblookNotSkipDict")
  command -range=0 -nargs=+ EblookNotSkipDict call <SID>SetDictSkip(<count>, 0, <f-args>)
endif
if !exists(":EblookPasteDictList")
  command -count=0 EblookPasteDictList call <SID>PasteDictList(<count>)
endif

" eblookにリダイレクトするコマンドを保持する一時ファイル名
let s:cmdfile = tempname()
" entryバッファ名のベース
let s:entrybufname = fnamemodify(s:cmdfile, ':p:h') . '/_eblook_entry_'
let s:entrybufname = substitute(s:entrybufname, '\\', '/', 'g')
" contentバッファ名のベース
let s:contentbufname = fnamemodify(s:cmdfile, ':p:h') . '/_eblook_content_'
let s:contentbufname = substitute(s:contentbufname, '\\', '/', 'g')
" バッファヒストリ中の現在位置
let s:bufindex = 0
" 直前に検索した文字列
let s:lastword = ''
" 表示済referenceアドレスリスト(訪問済リンクの表示変更用)
let s:visited = []
" stemming後の検索文字列。最初の要素がstemming前の文字列
let s:stemmedwords = []
" stemmedwords内の検索中index
let s:stemindex = -1

" マッピング
let s:set_mapleader = 0
if !exists('g:mapleader')
  let g:mapleader = "\<C-K>"
  let s:set_mapleader = 1
endif
" (<Plug>EblookSearchと<Plug>EblookSearchInputにすると、
"  <Plug>EblookSearchの方が|'timeout'|待ちになる)
if !hasmapto('<Plug>EblookInput')
  map <unique> <Leader><C-Y> <Plug>EblookInput
endif
noremap <unique> <script> <Plug>EblookInput <SID>Input
noremap <SID>Input :<C-U>call <SID>SearchInput(v:count, g:eblook_group, 0)<CR>
if !hasmapto('<Plug>EblookSearch', 'n')
  nmap <unique> <Leader>y <Plug>EblookSearch
endif
nnoremap <unique> <script> <Plug>EblookSearch <SID>SearchN
nnoremap <silent> <SID>SearchN :<C-U>call <SID>Search(v:count, expand('<cword>'), 0)<CR>
if !hasmapto('<Plug>EblookSearch', 'v')
  vmap <unique> <Leader>y <Plug>EblookSearch
endif
vnoremap <unique> <script> <Plug>EblookSearch <SID>SearchV
vnoremap <silent> <SID>SearchV :<C-U>call <SID>SearchVisual(v:count)<CR>
if s:set_mapleader
  unlet g:mapleader
endif
unlet s:set_mapleader

augroup Eblook
autocmd!
execute "autocmd BufReadCmd " . s:entrybufname . "* call <SID>Empty_BufReadCmd()"
execute "autocmd BufReadCmd " . s:contentbufname . "* call <SID>Empty_BufReadCmd()"
execute "autocmd BufEnter " . s:entrybufname . "* call <SID>Entry_BufEnter()"
execute "autocmd BufEnter " . s:contentbufname . "* call <SID>Content_BufEnter()"
augroup END

" eblook-vim-1.0.5までの辞書指定形式を読み込む
if !exists("g:eblook_dictlist1")
  let g:eblook_dictlist1 = []
  let s:i = 1
  while exists("g:eblook_dict{s:i}_name")
    let dict = { 'name': g:eblook_dict{s:i}_name }
    if exists("g:eblook_dict{s:i}_book")
      let dict.book = g:eblook_dict{s:i}_book
      " appendixが指定されている場合、bookとは分離する(扱いやすくするため)
      let bookapp = matchlist(dict.book, '^\("[^"]\+"\)\s\+\(.\+\)\|^\([^"]\+\)\s\+\(.\+\)')
      if len(bookapp) > 1
	if strlen(bookapp[1]) > 0
	  let dict.book = bookapp[1]
	  if strlen(bookapp[2]) > 0
	    let dict.appendix = bookapp[2]
	  endif
	elseif strlen(bookapp[3]) > 0
	  let dict.book = bookapp[3]
	  if strlen(bookapp[4]) > 0
	    let dict.appendix = bookapp[4]
	  endif
	endif
      endif
    endif
    if exists("g:eblook_dict{s:i}_title")
      let dict.title = g:eblook_dict{s:i}_title
    else
      " 辞書のtitleが設定されていなかったら、辞書番号とnameを設定しておく
      let dict.title = s:i . dict.name
    endif
    if exists("g:eblook_dict{s:i}_skip")
      let dict.skip = g:eblook_dict{s:i}_skip
    endif
    call add(g:eblook_dictlist1, dict)
    let s:i = s:i + 1
  endwhile
  unlet s:i
endif

if !exists('g:eblook_group')
  let g:eblook_group = 1
endif

" entryバッファに入った時に実行。set nobuflistedする。
function! s:Entry_BufEnter()
  set buftype=nofile
  set bufhidden=hide
  set noswapfile
  set nobuflisted
  set nolist
  set filetype=eblook
  if has("conceal")
    setlocal conceallevel=2 concealcursor=nc
  endif
  if strlen(g:eblook_statusline_entry) > 0
    setlocal statusline=%!g:eblook_statusline_entry
  else
    setlocal statusline=
  endif
  nnoremap <buffer> <silent> <CR> :<C-U>call <SID>GetContent(v:count)<CR>
  nnoremap <buffer> <silent> J j:call <SID>GetContent(0)<CR>
  nnoremap <buffer> <silent> K k:call <SID>GetContent(0)<CR>
  nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
  nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
  nnoremap <buffer> <silent> o :call <SID>MaximizeContentHeight()<CR>
  nnoremap <buffer> <silent> O :call <SID>GetAndFormatContent()<CR>
  nnoremap <buffer> <silent> p :call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :<C-U>call <SID>ListReferences(v:count)<CR>
  nnoremap <buffer> <silent> s :<C-U>call <SID>SearchInput(v:count, b:group, 0)<CR>
  nnoremap <buffer> <silent> S :<C-U>call <SID>SearchOtherGroup(v:count, b:group)<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>
  nnoremap <buffer> <silent> <Tab> :call search("\t")<CR>
  nnoremap <buffer> <silent> <S-Tab> :call search("\t", 'b')<CR>
  if has("gui_running")
    nnoremap <buffer> <silent> <2-LeftMouse> :call <SID>GetContent(0)<CR>
    nnoremap <buffer> <silent> <C-RightMouse> :call <SID>History(-1)<CR>
    nnoremap <buffer> <silent> <C-LeftMouse> :call <SID>History(1)<CR>
  endif
endfunction

" contentバッファに入った時に実行。set nobuflistedする。
function! s:Content_BufEnter()
  set buftype=nofile
  set bufhidden=hide
  set noswapfile
  set nobuflisted
  set nolist
  set filetype=eblook
  if has("conceal")
    setlocal conceallevel=2 concealcursor=nc
  endif
  if strlen(g:eblook_statusline_content) > 0
    setlocal statusline=%!g:eblook_statusline_content
  else
    setlocal statusline=
  endif
  nnoremap <buffer> <silent> <CR> :<C-U>call <SID>SelectReference(v:count)<CR>
  nnoremap <buffer> <silent> x :<C-U>call <SID>ShowMedia(v:count)<CR>
  nnoremap <buffer> <silent> <Space> <PageDown>
  nnoremap <buffer> <silent> <BS> <PageUp>
  nnoremap <buffer> <silent> <Tab> :call search('<\d\+[\|!]')<CR>
  nnoremap <buffer> <silent> <S-Tab> :call search('<\d\+[\|!]', 'b')<CR>
  nnoremap <buffer> <silent> o :wincmd _<CR>
  nnoremap <buffer> <silent> O :call <SID>GetContentSub(1)<CR>
  nnoremap <buffer> <silent> p :call <SID>GoWindow(1)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :<C-U>call <SID>FollowReference(v:count)<CR>
  nnoremap <buffer> <silent> s :<C-U>call <SID>SearchInput(v:count, b:group, 0)<CR>
  nnoremap <buffer> <silent> S :<C-U>call <SID>SearchOtherGroup(v:count, b:group)<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
  if has("gui_running")
    nnoremap <buffer> <silent> <2-LeftMouse> :call <SID>SelectReference(v:count)<CR>
    nnoremap <buffer> <silent> <C-RightMouse> :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
    nnoremap <buffer> <silent> <C-LeftMouse> :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
    menu .1 PopUp.[eblook]\ Back :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
    menu .2 PopUp.[eblook]\ Forward :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
    menu .3 PopUp.[eblook]\ SearchVisual :<C-U>call <SID>SearchVisual(v:count)<CR>
    menu .4 PopUp.-SEP_EBLOOK-	<Nop>
  endif
endfunction

" プロンプトを出して、ユーザから入力された文字列を検索する
" @param {Number} group 対象の辞書グループ番号
" @param {Number} defgroup 対象の辞書グループ番号(デフォルト)
" @param {Boolean} uselastword 直前の検索文字列をデフォルト文字列として入れるか
"   (<Leader>yで取得・検索した文字列を一部変更して再検索できるように。
"   input()のプロンプトで|c_CTRL-R_=|の後s:lastwordと入力することで実現可能)
function! s:SearchInput(group, defgroup, uselastword)
  let gr = a:group
  if a:group == 0
    let gr = a:defgroup
  endif
  if a:uselastword
    let word = s:lastword
  else
    let word = ''
  endif
  let str = input(':' . gr . 'EblookSearch ', word)
  if strlen(str) == 0 || str ==# word && gr == a:defgroup
    return
  endif
  call s:Search(gr, str, 0)
endfunction

" (entry/contentウィンドウから)直前の検索文字列を他の辞書グループで再検索する
" @param {Number} group 対象の辞書グループ番号
" @param {Number} defgroup 現在の辞書グループ番号
function! s:SearchOtherGroup(group, defgroup)
  let gr = s:ExpandDefaultGroup(a:group)
  if gr == a:defgroup
    return
  endif
  call s:Search(gr, s:lastword, 0)
endfunction

" Visual modeで選択されている文字列を検索する
" @param {Number} group 対象の辞書グループ番号
function! s:SearchVisual(group)
  let save_reg = @@
  silent execute 'normal! `<' . visualmode() . '`>y'
  call s:Search(a:group, substitute(@@, '\n', '', 'g'), 0)
  let @@ = save_reg
endfunction

" 指定された単語の検索を行う。
" entryバッファに検索結果のリストを表示し、
" そのうち先頭のentryの内容をcontentバッファに表示する。
" @param {Number} group 対象の辞書グループ番号
" @param {String} word 検索する単語
" @param {Boolean} isstem stemmingした単語の検索中かどうか
function! s:Search(group, word, isstem)
  if strlen(a:word) == 0
    echomsg 'eblook-vim: 検索語が空文字列なので、検索を中止します'
    return -1
  endif
  let s:lastword = a:word
  let gr = s:ExpandDefaultGroup(a:group)
  let dictlist = s:GetDictList(gr)
  if len(dictlist) == 0
    echomsg 'eblook-vim: 辞書グループ(g:eblook_dictlist' . gr . ')には辞書がありません'
    return -1
  endif
  let hasoldwin = bufwinnr(s:entrybufname . s:bufindex)
  if hasoldwin < 0
    let hasoldwin = bufwinnr(s:contentbufname . s:bufindex)
  endif
  if s:RedirSearchCommand(dictlist, a:word) < 0
    return -1
  endif
  if s:NewBuffers(gr) < 0
    return -1
  endif
  let b:word = a:word
  call s:ExecuteEblook()

  silent! :g/eblook.*> \(eblook.*> \)/s//\1/g
  " 必要なgaiji mapファイルのみ読み込む: <gaiji=のある辞書番号をリストアップ
  silent! normal! G$
  let gaijidnums = []
  while search('<gaiji=', 'bW') != 0
    if search('eblook-\d\+>', 'bW') != 0
      let dnum = matchstr(getline('.'), 'eblook-\zs\d\+\ze>')
      if strlen(dnum) > 0
        call add(gaijidnums, str2nr(dnum))
      endif
    endif
  endwhile

  let i = 0
  while i < len(dictlist)
    let dict = dictlist[i]
    if get(dict, 'skip')
      let i = i + 1
      continue
    endif
    let title = get(dict, 'title', '')
    if strlen(title) == 0
      " 辞書のtitleが設定されていなかったら、辞書番号とnameを設定する
      let dict.title = i . dict.name
      let title = dict.title
    endif
    if index(gaijidnums, i) >= 0
      let gaijimap = s:GetGaijiMap(dict)
      silent! execute 'g/eblook-' . i . '>/;/^eblook/-1s/<gaiji=\([^>]*\)>/\=s:GetGaiji(gaijimap, submatch(1))/g'
    endif
    silent! execute 'g/eblook-' . i . '>/;/^eblook/-1s/^/' . title . "\t"
    let i = i + 1
  endwhile
  silent! :g/eblook.*> /s///g
  silent! :g/^$/d _

  " 各行のreference先を配列に格納して、バッファからは削除
  " (concealしてもカウントされるので、行が途中で折り返されていまいちなので)
  let b:refs = []
  silent! :g/^\(.\{-}\)\t *\d\+\. \(\x\+:\x\+\)\t\(.*\)/s//\=s:MakeEntryReferenceString(submatch(1), submatch(2), submatch(3))/

  if a:isstem
    silent! execute "g/\t/s//\t[" . s:stemmedwords[0] . ' ->] /'
  endif

  setlocal nomodifiable
  if s:GetContent(1) < 0
    if search('.', 'w') == 0
      bwipeout!
      silent! call s:History(-1)
      if hasoldwin < 0
	call s:Quit()
      endif
      let word = a:word
      if a:isstem
	let s:stemindex += 1
	if s:stemindex < len(s:stemmedwords)
	  call s:Search(gr, s:stemmedwords[s:stemindex], 1)
	  return
	else
	  let word = s:stemmedwords[0]
	endif
      elseif g:eblook_stemming
	let s:stemmedwords = s:Stem(a:word)
	call filter(s:stemmedwords, 'v:val !=# "' . a:word . '"')
	if len(s:stemmedwords) > 0
	  call insert(s:stemmedwords, a:word) " 元の単語を先頭に入れておく
	  let s:stemindex = 1
	  call s:Search(gr, s:stemmedwords[s:stemindex], 1)
	  return
	endif
      endif
      "redraw | echomsg 'eblook-vim(' . gr . '): 何も見つかりませんでした: <' . word . '>'
      let str = input(':' . gr . 'EblookSearch(何も見つかりませんでした) ', word)
      if strlen(str) == 0 || str ==# word
	return
      endif
      call s:Search(gr, str, 0)
    endif
  endif
endfunction

" stemming/語尾補正した候補文字列のListを取得する
" @param {String} word 対象文字列
" @return 候補文字列のList
function! s:Stem(word)
  if a:word =~ '[^ -~]'
    return eblook#stem_ja#Stem(a:word)
    " XXX: ebviewと同様に、漢字部分のみを追加する
  else
    return eblook#stem_en#Stem(a:word)
  endif
endfunction

" eblookプログラムにリダイレクトするための検索コマンドファイルを作成する
" @param dictlist 対象の辞書グループ
" @param {String} word 検索する単語
function! s:RedirSearchCommand(dictlist, word)
  if s:OpenWindow('new') < 0
    return -1
  endif
  setlocal nobuflisted
  let prev_book = ''
  let i = 0
  while i < len(a:dictlist)
    let dict = a:dictlist[i]
    if get(dict, 'skip')
      let i = i + 1
      continue
    endif
    if exists('dict.book') && dict.book !=# prev_book
      execute 'normal! obook ' . s:MakeBookArgument(dict) . "\<Esc>"
      let prev_book = dict.book
    endif
    execute 'normal! oselect ' . dict.name . "\<CR>"
      \ . 'set prompt "eblook-' . i . '> "' . "\<CR>"
      \ . 'search "' . a:word . '"' . "\<CR>\<Esc>"
    let i = i + 1
  endwhile
  setlocal noswapfile
  silent execute 'write! ++enc=' . g:eblookenc . ' ' . s:cmdfile
  bwipeout!
  return 0
endfunction

" 指定された辞書グループの辞書リストを取得する
" @param {Number} group 対象の辞書グループ番号
" @return 辞書リスト
function! s:GetDictList(group)
  let gr = s:ExpandDefaultGroup(a:group)
  if exists("g:eblook_dictlist{gr}")
    let dictlist = g:eblook_dictlist{gr}
  else
    let dictlist = []
  endif
  return dictlist
endfunction

" eblook 1.6.1+media版かどうかを調べる
function! s:IsEblookMediaVersion()
  if !exists('s:eblookmedia')
    let l:version = system(g:eblookprg . ' -version')
    if match(l:version, '^eblook 1\.6\.1+media-') >= 0
      let s:eblookmedia = 1
    else
      let s:eblookmedia = 0
    endif
  endif
  return s:eblookmedia
endfunction

" eblookのbookに指定するための引数値を作る
" @param {Dictionary} dict 辞書情報
" @return {String} bookに指定する引数
function! s:MakeBookArgument(dict)
  if exists('a:dict.appendix')
    return a:dict.book . ' ' . a:dict.appendix
  endif
  " 直前のbook用に指定したappendixが引き継がれないようにappendixは必ず付ける
  " (eblook 1.6.1+media版では対処されているので不要)
  if !exists('s:has_appendix_problem')
    if s:IsEblookMediaVersion()
      let s:has_appendix_problem = 0
    else
      let s:has_appendix_problem = 1
    endif
  endif
  if s:has_appendix_problem
    return a:dict.book . ' ' . a:dict.book
  else
    return a:dict.book
  endif
endfunction

" eblookプログラムを実行する
function! s:ExecuteEblook()
  " ++encを指定しないとEUCでの短い出力をCP932と誤認識することがある
  silent execute 'read! ++enc=' . g:eblookenc . ' "' . g:eblookprg . '" ' . s:eblookopt . ' < "' . s:cmdfile . '"'
  if &encoding !=# g:eblookenc
    setlocal fileencoding=&encoding
  endif

  silent! :g/^Warning: you should specify a book directory first$/d _
endfunction

" 新しく検索を行うために、entryバッファとcontentバッファを作る。
" @param {Number} group 対象の辞書グループ番号
function! s:NewBuffers(group)
  " entryバッファとcontentバッファは一対で扱う。
  let oldindex = s:bufindex
  let s:bufindex = s:NextBufIndex()
  if s:CreateBuffer(s:entrybufname, oldindex) < 0
    let s:bufindex = oldindex
    return -1
  endif
  let b:group = a:group
  let b:word = ''
  if s:CreateBuffer(s:contentbufname, oldindex) < 0
    call s:Quit()
    let s:bufindex = oldindex
    return -1
  endif
  let b:group = a:group
  " eblook内でエラーが発生して、結果が無い状態でstatuslineを表示しようとして
  " Undefined variable: b:captionエラーが発生するのを回避
  let b:caption = ''
  let b:dtitle = ''
  if s:GoWindow(1) < 0
    call s:Quit()
    let s:bufindex = oldindex
    return -1
  endif
  execute g:eblook_entrywin_height . 'wincmd _'
  return 0
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
  if s:SelectWindowByName(oldbufname) < 0
    if s:OpenWindow('split ' . newbufname) < 0
      return -1
    endif
  else
    silent execute "edit" newbufname
  endif
  setlocal modifiable
  if bufexists
    silent %d _
  endif
  return 0
endfunction

" entryバッファの指定行に対応する内容をcontentバッファに表示する
" @param count 対象の行番号。0の場合は現在行
" @return -1:content表示失敗, 0:表示成功
function! s:GetContent(count)
  if (a:count > 0)
    silent! execute 'normal! ' . a:count . 'G/\t' . "\<CR>"
  endif
  let lnum = line('.')
  let str = getline(lnum)
  let title = matchstr(str, '^[^\t]\+')
  if strlen(title) == 0
    return -1
  endif
  let dnum = s:GetDictNumFromTitle(b:group, title)
  if dnum < 0
    return -1
  endif
  let ref = get(b:refs, lnum - 1)
  if type(ref) != type([])
    return -1
  endif
  let refid = ref[0]

  if s:GoWindow(0) < 0
    return -1
  endif
  let b:caption = ref[1]
  let b:dtitle = title
  let b:dictnum = dnum
  let b:refid = refid

  call s:GetContentSub(0)
  call s:GoWindow(1)
  return 0
endfunction

" contentを取得してcontentバッファに表示する
" @param doformat 整形するかどうか
function! s:GetContentSub(doformat)
  setlocal modifiable
  silent %d _
  let dictlist = s:GetDictList(b:group)
  let dict = dictlist[b:dictnum]
  if !exists('g:eblook_decorate')
    if s:IsEblookMediaVersion()
      let g:eblook_decorate = 1
    else
      let g:eblook_decorate = 0
    endif
  endif
  execute 'redir! >' . s:cmdfile
    if g:eblook_decorate
      silent echo 'set decorate-mode on'
    endif
    if exists("dict.book")
      silent echo 'book ' . s:MakeBookArgument(dict)
    endif
    silent echo 'select ' . dict.name
    silent echo 'content ' . b:refid . "\n"
  redir END
  call s:ExecuteEblook()
  "return 0 " DEBUG: 整形前の内容を確認する

  silent! :g/eblook> /s///g
  if search('<gaiji=', 'nw') != 0
    call s:ReplaceGaiji(dict)
  endif
  if g:eblook_decorate
    " 未対応のタグは削除
    silent! :g/<\/\?no-newline>/s///g
    call s:ReplaceTag() " <sup>,<sub>
    " TODO: <em>,<font=bold>,<font=italic>のsyntax対応
    silent! :g/<\/\?em>/s///g
    silent! :g/<font=\%(bold\|italic\)>/s///g
    silent! :g/<\/font>/s///g
  endif
  silent! :g/^$/d _
  call s:FormatReference()
  if exists('dict.autoformat')
    if dict.autoformat
      call s:FormatContent()
    elseif g:eblook_decorate
      call s:FormatIndent()
    endif
  elseif a:doformat || g:eblook_autoformat_default
    call s:FormatContent()
  elseif g:eblook_decorate
    call s:FormatIndent()
  endif
  setlocal nomodifiable
  normal! 1G
  if search('.', 'w') > 0 " any result?
    let maxover = len(s:visited) - g:eblook_visited_max + 1
    if maxover > 0
      unlet s:visited[:maxover]
    endif
    call add(s:visited, b:dtitle . "\t" . b:refid)
  endif
endfunction

" 上付き文字(<sup>１</sup>)、下付き文字<sub>を置き換える
function! s:ReplaceTag()
  silent! :g/<sup>\([^<]*\)<\/sup>/s//\=s:GetReplaceTagStr('sup', submatch(1))/g
  silent! :g/<sub>\([^<]*\)<\/sub>/s//\=s:GetReplaceTagStr('sub', submatch(1))/g
endfunction

" タグの置換文字列を取得する。
" @param tag タグ。'sup'か'sub'
" @param str 元の文字列
" @return 置換文字列
function! s:GetReplaceTagStr(tag, str)
  if &encoding != 'utf-8'
    return a:str
  else
    return get(g:eblook#supsubmap_utf8#{a:tag}map, a:str, a:str)
  endif
endfunction

" <gaiji=xxxxx>を置き換える。
function! s:ReplaceGaiji(dict)
  let gaijimap = s:GetGaijiMap(a:dict)
  silent! :g/<gaiji=\([^>]*\)>/s//\=s:GetGaiji(gaijimap, submatch(1))/g
endfunction

" 外字置換表を取得する
" @param dict 辞書
" @return 外字置換表
function! s:GetGaijiMap(dict)
  if !exists("a:dict.gaijimap")
    try
      let a:dict.gaijimap = s:LoadGaijiMapFile(a:dict)
    catch /load-error/
      " ウィンドウを閉じて空きを作って再度検索し直した時に外字取得できるように
      return {}
    endtry
  endif
  return a:dict.gaijimap
endfunction

" EBWin形式の外字定義ファイルを読み込む
" http://hishida.s271.xrea.com/manual/EBPocket/0_0_4_4.html
" @param dict 辞書
" @return 読み込んだ外字置換表。{'ha121':[unicode, ascii], ...}
function! s:LoadGaijiMapFile(dict)
  let name = a:dict.name
  let dir = matchstr(a:dict.book, '"\zs[^"]\+\ze"\|\S\+')
  " "{dir}/{NAME}_{encoding}.map"が無ければ"{dir}/{NAME}.map"をcp932で読み込み
  let mapfilebase = dir . '/' . toupper(name)
  let encmapfile = mapfilebase . '_' . &encoding . '.map'
  let mapfile = mapfilebase . '.map'
  let gaijimap = {}
  if filereadable(encmapfile)
    let mapfile = encmapfile
    let enc = &encoding
  elseif filereadable(mapfile)
    let enc = 'cp932'
  else
    return gaijimap
  endif
  " 現在のウィンドウ(entry/content)の高さが足りない場合、
  " OpenWindow()により、高さに余裕のあるウィンドウ上でsviewする可能性があるので
  " closeした後で元のウィンドウに明示的に切り替える必要あり
  let curbuf = bufnr('')
  if s:OpenWindow('sview ++enc=' . enc . ' ' . mapfile) < 0
    throw 'load-error'
  endif
  setlocal buftype=nowrite
  setlocal bufhidden=wipe
  setlocal nobuflisted
  for line in getline(1, '$')
    if line !~ '^[hzcg]\x\{4}'
      continue
    endif
    " 例: hA121	u00E0	a	# comment
    let lst = split(line)
    let gaiji = tolower(get(lst, 0))
    let unicode = get(lst, 1, '-')
    let ascii = get(lst, 2, '')
    if &encoding ==# 'utf-8'
      let unicode = substitute(unicode, ',', '', 'g')
      let unicode = substitute(unicode, 'u\(\x\{4}\)', '\=nr2char("0x" . submatch(1))', 'g')
    endif
    let gaijimap[gaiji] = [unicode, ascii]
  endfor
  bwipeout!
  execute bufwinnr(curbuf) . 'wincmd w'
  return gaijimap
endfunction

" 外字置換文字列を取得する。
" @param gaijimap 外字置換表
" @param key 外字キー
" @return 置換文字列
function! s:GetGaiji(gaijimap, key)
  " XXX:GetGaiji()内からGetGaijiMap()を呼びたいが、
  " substitute()で\=が再帰的に呼ばれる形になってしまうため動作せず
  if !exists("a:gaijimap[a:key]")
    return '_'
    "return '_' . a:key . '_'     " DEBUG
  endif
  let gaiji = a:gaijimap[a:key]
  if &encoding ==# 'utf-8'
    let res = gaiji[0]
    if res ==# 'null'
      return ''
    elseif res ==# '-'
      let res = gaiji[1]
    endif
  else
    let res = gaiji[1]
  endif
  if strlen(res) == 0
    return '_'
    "return '_' . a:key . '_'     " DEBUG
  endif
  return res
endfunction

" contentバッファ中の<reference>等を短縮形式に置換する
function! s:FormatReference()
  let b:contentrefsm = []
  " <img=jpeg>...</img=589:334>
  silent! :g;<img=\([^>]*\)>\(\_.\{-}\)</img=\([^>]*\)>;s;;\=s:MakeCaptionString(submatch(2), 'img', submatch(1), submatch(3));g
  silent! :g;<inline=\([^>]*\)>\(\_.\{-}\)</inline=\([^>]*\)>;s;;\=s:MakeCaptionString(submatch(2), 'inline', submatch(1), submatch(3));g
  " <snd=wav:433:2032-535:111>
  silent! :g;<snd=\(.\{-}\):\([^>]*\)>\(\_.\{-}\)</snd>;s;;\=s:MakeCaptionString(submatch(3), 'snd', submatch(1), submatch(2));g
  " <mov=mpg:590357301,590357297,590488370,590684976>
  silent! :g;<mov=\(.\{-}\):\([^>]*\)>\(\_.\{-}\)</mov>;s;;\=s:MakeCaptionString(submatch(3), 'mov', submatch(1), submatch(2));g

  let b:contentrefs = []
  silent! :g;<reference>\(.\{-}\)</reference=\(\x\+:\x\+\)>;s;;\=s:MakeReferenceString(submatch(1), submatch(2));g
  " /のhistoryに<reference>\(.\{-}\)</reference=\(\x\+:\x\+\)>が出ないように
  call histdel('/', -1)
endfunction

" <img>等のcaptionを〈〉等でくくる。
" <img>等のタグはconcealにするので画像なのか音声/動画なのかを識別できるように。
" @param caption caption文字列。空文字列の可能性あり
" @param tag captionの種類:'inline','img','snd','mov'
" @return 整形後の文字列
function! s:MakeCaptionString(caption, tag, ftype, addr)
  let len = strlen(a:caption)
  " captionが空の場合は補完:
  " eblook 1.6.1+mediaで『理化学辞典第５版』を表示した場合、
  " 数式部分でcaptionが空の<inline>が出現。非表示にすると
  " 文章がつながらなくなる。(+media無しのeblookの場合は<img>で出現)
  if a:tag ==# 'img' || a:tag ==# 'inline'
    let markbeg = '〈'
    let capstr = (len ? a:caption : '画像')
    let markend = '〉'
  elseif a:tag ==# 'snd'
    let markbeg = '《'
    let capstr = (len ? a:caption : '音声')
    let markend = '》'
  elseif a:tag ==# 'mov'
    let markbeg = '《'
    let capstr = (len ? a:caption : '動画')
    let markend = '》'
  else
    return a:cation
  endif
  call add(b:contentrefsm, [a:ftype, a:addr, capstr])
  return '<' . len(b:contentrefsm) . markbeg . capstr . markend . '>'
endfunction

" '<reference>caption</reference=xxxx:xxxx>'を
" '<1|caption|>'だけにした文字列を返す。
" concealしても表示されないだけで、整形時にはカウントされているので、
" <reference></reference=xxxx:xxxx>だと長すぎて、
" 行の折り返しがかなり早めにされているように見えるので。
" @param caption caption文字列。空文字列の可能性あり
" @param addr reference先アドレス文字列
" @return 変換後の文字列
function! s:MakeReferenceString(caption, addr)
  let len = strlen(a:caption)
  let capstr = len ? a:caption : '参照'
  call add(b:contentrefs, [a:addr, capstr])
  return '<' . len(b:contentrefs) . s:Visited(b:dtitle, a:addr) . capstr . '|>'
endfunction

" 訪問済リンクかどうか調べて、'!'か'|'を返す
function! s:Visited(title, addr)
  if match(s:visited, a:title . "\t" . a:addr) >= 0
    return '!'
  else
    return '|'
  endif
endfunction

" entryバッファの参照先文字列の置換用関数
function! s:MakeEntryReferenceString(title, addr, caption)
  call add(b:refs, [a:addr, a:caption])
  return a:title . "\t<" . len(b:refs) . s:Visited(a:title, a:addr) . a:caption . '|>'
endfunction

" entryバッファ上からcontentバッファを整形する
function! s:GetAndFormatContent()
  let save = g:eblook_autoformat_default
  let g:eblook_autoformat_default = 1
  if s:GetContent(0) < 0
    let g:eblook_autoformat_default = save
    return -1
  endif
  let g:eblook_autoformat_default = save
  call s:GoWindow(1)
endfunction

" <ind=[1-9]>で指定されるindent量を使用して現在行をindnet
" @param indcur 現在のindent量
function! s:FormatHeadIndent(indcur)
  let ind = a:indcur
  let indnew = matchstr(getline('.'), '^<ind=\zs[0-9]\ze>')
  " 行頭に<ind=>がある場合は、indent量を更新
  while indnew != ''
    let ind = indnew
    s/^<ind=[0-9]>//
    " ^<ind=1><ind=3>のような場合があるのでループしてチェック
    let indnew = matchstr(getline('.'), '^<ind=\zs[0-9]\ze>')
  endwhile
  if ind > g:eblook_decorate_indmin
    s/^/\=printf('%*s', ind - g:eblook_decorate_indmin, '')/
  endif
  return ind
endfunction

" contentバッファ内の<ind=[1-9]>を整形する
function! s:FormatIndent()
  silent! :g/^<\%(next\|prev\)>/s/^/<ind=0>/
  let ind = 0
  let lnum = 1
  let lastline = line('$')
  while lnum <= lastline
    call cursor(lnum, 1)
    let ind = s:FormatHeadIndent(ind)

    " 行の途中に<ind=>がある場合は、次行以降のindent量を更新
    let indnew = matchstr(getline('.'), '<ind=\zs[0-9]\ze>')
    while indnew != ''
      s/<ind=[0-9]>//
      let ind = indnew
      let indnew = matchstr(getline('.'), '<ind=\zs[0-9]\ze>')
    endwhile
    let lnum = lnum + 1
  endwhile
endfunction

" contentバッファを整形する
function! s:FormatContent()
  let tw = &textwidth
  if tw == 0 && &wrapmargin
    let tw = winwidth(0) - &wrapmargin
  else
    let tw = winwidth(0) - 1
  endif
  if tw <= 0
    return
  endif

  setlocal modifiable
  if g:eblook_decorate
    silent! :g/^<\%(next\|prev\)>/s/^/<ind=0>/
  endif
  let ind = 0
  normal! 1G$
  while 1
    if g:eblook_decorate
      let ind = s:FormatHeadIndent(ind)

      " 行の途中にある<ind=>を考慮して長い行を分割する
      normal! ^
      while search('<ind=[0-9]>', 'c', line('.')) > 0
	let indnew = matchstr(getline('.'), '<ind=\zs[0-9]\ze>')
	let vcol = virtcol('.')
	if vcol > tw
	  let startline = line('.')
	  let stopline = s:FormatLine(tw, 0, ind)
	  call cursor(startline, 1)
	  let indline = search('<ind=[0-9]>', 'c', stopline)
	  s/<ind=[0-9]>//
	  " <ind=[0-9]>を削った後、再整形のため行結合
	  if indline < stopline
	    let n = stopline - indline + 1
	    execute "normal! " . n . "J"
	  endif
	else
	  s/<ind=[0-9]>//
	endif
	let ind = indnew
      endwhile
      normal! $
    endif
    if virtcol('$') > tw
      call s:FormatLine(tw, 0, ind)
    endif
    if line('.') == line('$')
      break
    endif
    normal! j$
  endwhile
  setlocal nomodifiable
  normal! 1G
endfunction

" 長い行を分割する。
" @param width 上限幅
" @param joined 直前に行を結合したかどうか
" @param ind インデント量
" @return 分割後の複数行のうちの最終行の行番号(line('.')と同じ)
function! s:FormatLine(width, joined, ind)
  let first = line('.')
  let indprev = matchstr(getline('.'), '^ *')
  normal! gqq
  let last = line('.')
  if last == first
    return last
  endif
  " gqqが付けたindentは削除。<ind=[1-9]>をもとにindentを付けるので、余分。
  if g:eblook_decorate && indprev != ""
    silent! execute (first + 1) . ',' . last . 's/^' . indprev . '//'
  endif
  call cursor(first, 1)
  " <reference>置換後の<1|...|>が行をまたいだ場合には未対応のため、1行に収める:
  " <1|直前に改行を入れて次の行と結合した後、再度分割し直す。
  let openrefline = search('<\d\+[|!][^>]*$', 'cW', last)
  if openrefline > 0
    let c = virtcol('.')
    if c > 1
      execute "normal! i\<CR>\<Esc>"
    endif
    let n = last - openrefline + 1
    execute "normal! " . n . "J$"
    " 行結合後、再帰呼び出しされてて、<1|が行頭→これ以上再帰しても無駄
    if a:joined && c == 1
      return line('.')
    endif
    if virtcol('.') > a:width
      call s:FormatLine(a:width, 1, a:ind)
    endif
  endif
endfunction

" contentバッファ中のカーソル位置付近のreferenceを抽出して、
" その内容を表示する。
" @param count [count]で指定された、表示対象のreferenceのindex番号
function! s:SelectReference(count)
  if a:count > 0
    let index = a:count
    if a:count > len(b:contentrefs)
      let index = len(b:contentrefs)
    endif
  else
    let index = s:GetIndexHere('<\zs\d\+\ze[|!]', '.')
    if strlen(index) == 0
      return
    endif
  endif
  call s:FollowReference(index)
endfunction

" contentバッファ中のカーソル位置付近のrefpatを抽出して、
" refpatに含まれるindex番号を返す。
function! s:GetIndexHere(refpat, lnum)
  let str = getline(a:lnum)
  let index = matchstr(str, a:refpat)
  let m1 = matchend(str, a:refpat)
  if m1 < 0
    return ''
  endif
  " referenceが1行に2つ以上ある場合は、カーソルが位置する方を使う
  let m2 = match(str, a:refpat, m1)
  if m2 >= 0
    if a:lnum == '.'
      let col = col('.')
    elseif line('.') > a:lnum
      let col = col('$')
    else
      let col = 1
    endif
    let offset = strridx(strpart(str, 0, col), '<')
    if offset >= 0
      let index = matchstr(str, a:refpat, offset)
    endif
  endif
  return index
endfunction

" entryバッファでカーソル行のエントリに含まれるreferenceのリストを表示
" @param count [count]で指定された、表示対象のreferenceのindex番号
function! s:ListReferences(count)
  if s:GetContent(0) < 0
    return -1
  endif
  call s:FollowReference(a:count)
endfunction

" referenceをリストアップしてentryバッファに表示し、
" 指定されたreferenceの内容をcontentバッファに表示する。
" @param count [count]で指定された、表示対象のreferenceのindex番号
function! s:FollowReference(count)
  if s:GoWindow(0) < 0
    return
  endif
  let dnum = b:dictnum
  let contentrefs = b:contentrefs
  let contentcaption = b:caption

  if s:NewBuffers(b:group) < 0
    return -1
  endif
  let dictlist = s:GetDictList(b:group)
  let title = dictlist[dnum].title
  let j = 0
  while j < len(contentrefs)
    let refstr = '<' . (j + 1) . s:Visited(title, contentrefs[j][0]) . contentrefs[j][1] . '|>'
    execute 'normal! o' . title . "\<C-V>\<Tab>" . refstr . "\<Esc>"
    let j = j + 1
  endwhile
  let b:refs = contentrefs
  let b:word = contentcaption
  silent! :g/^$/d _
  setlocal nomodifiable

  normal! gg
  call s:GetContent(a:count)
endfunction

" contentバッファ中のカーソル位置付近のimg等を抽出して、
" その内容を外部プログラムで表示する。
" @param count [count]で指定された、表示対象のindex番号
function! s:ShowMedia(count)
  if a:count > 0
    let index = a:count
    if a:count > len(b:contentrefsm)
      let index = len(b:contentrefsm)
    endif
  else
    let index = s:GetIndexHere('<\zs\d\+\ze[〈《]', '.')
    if strlen(index) == 0
      " 画像や動画の場合、captionが複数行にわたる場合があり、
      " 2行目以降で操作した場合でも表示できるようにする
      let lnum = search('<\d\+[〈《]', 'bnW')
      if lnum == 0
	return
      endif
      let index = s:GetIndexHere('<\zs\d\+\ze[〈《]', lnum)
      if strlen(index) == 0
	return
      endif
    endif
  endif

  let ref = get(b:contentrefsm, index - 1)
  if type(ref) != type([])
    return
  endif
  let ftype = ref[0]
  let refid = ref[1]

  let tmpext = substitute(ftype, ':.*', '', '')
  if tmpext ==# 'mono'
    let tmpext = 'pbm'
  endif
  " mspaintはパス区切りが\でないと駄目
  let tmpfshell = tempname() . '.' . tmpext
  " eblook内ではパス区切りは\では駄目
  let tmpfeb = substitute(tmpfshell, '\\', '/', 'g')

  let dictlist = s:GetDictList(b:group)
  let dict = dictlist[b:dictnum]
  execute 'redir! >' . s:cmdfile
    if exists("dict.book")
      silent echo 'book ' . s:MakeBookArgument(dict)
    endif
    silent echo 'select ' . dict.name
    if tmpext ==# 'pbm'
      let m = matchlist(ftype, 'mono:\(\d\+\)x\(\d\+\)')
      silent echo 'pbm ' . refid . ' ' . m[1] . ' ' . m[2]
    elseif tmpext ==# 'wav'
      let m = matchlist(refid, '\(\d\+:\d\+\)-\(\d\+:\d\+\)')
      silent echo 'wav ' . m[1] . ' ' . m[2] . ' "' . tmpfeb . '"'
    elseif tmpext ==# 'mpg'
      let m = matchlist(refid, '\(\d\+\),\(\d\+\),\(\d\+\),\(\d\+\)')
      silent echo printf('mpeg %s %s %s %s "%s"', m[1], m[2], m[3], m[4], tmpfeb)
    else " bmp || jpeg
      silent echo tmpext . ' ' . refid . ' "' . tmpfeb . '"'
    endif
  redir END
  let res = system('"' . g:eblookprg . '" ' . s:eblookopt . ' < "' . s:cmdfile . '"')
  let ngmsg = matchstr(res, 'eblook> \zsNG: .*\ze\n')
  if v:shell_error || strlen(ngmsg) > 0
    echomsg tmpext . 'ファイル抽出失敗: ' . (v:shell_error ? res : ngmsg)
    return
  endif
  if tmpext ==# 'pbm'
    let pbm = substitute(res, 'Warning: you should specify a book directory first', '', '')
    let pbm = substitute(pbm, 'eblook> ', '', 'g')
    let pbm = substitute(pbm, '\%^\n\n', '', '')
    execute 'redir! > ' . tmpfshell
      silent echon pbm
    redir END
  endif

  let viewer = get(g:eblook_viewers, tmpext, '')
  if strlen(viewer) == 0
    echomsg tmpext . '用ビューアがg:eblook_viewersに設定されていません'
    return
  endif
  if match(viewer, '%s') >= 0
    let cmdline = substitute(viewer, '%s', shellescape(tmpfshell), '')
  else
    let cmdline = viewer . ' ' . shellescape(tmpfshell)
  endif
  " hit-enter promptが出ると面倒なのでsilent
  execute 'silent !' . cmdline
endfunction

" バッファのヒストリをたどる。
" @param dir -1:古い方向へ, 1:新しい方向へ
function! s:History(dir)
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
  if s:SelectWindowByName(s:entrybufname . s:bufindex) < 0
    call s:OpenWindow('split ' . s:entrybufname . ni)
  else
    silent execute "edit " . s:entrybufname . ni
  endif
  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    call s:OpenWindow('split ' . s:contentbufname . ni)
  else
    silent execute "edit " . s:contentbufname . ni
  endif
  let s:bufindex = ni
  call s:GoWindow(1)
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
  if has("gui_running")
    unmenu PopUp.[eblook]\ Back
    unmenu PopUp.[eblook]\ Forward
    unmenu PopUp.[eblook]\ SearchVisual
    unmenu PopUp.-SEP_EBLOOK-
  endif
  if s:SelectWindowByName(s:contentbufname . s:bufindex) >= 0
    hide
  endif
  if s:SelectWindowByName(s:entrybufname . s:bufindex) >= 0
    hide
  endif
  call delete(s:cmdfile)
endfunction

" entryウィンドウからcontentウィンドウをスクロールする。
" @param down 1の場合下に、0の場合上に。
function! s:ScrollContent(down)
  if s:GoWindow(0) < 0
    return
  endif
  if a:down
    execute "normal! \<PageDown>"
  else
    execute "normal! \<PageUp>"
  endif
  call s:GoWindow(1)
endfunction

" entryウィンドウ/contentウィンドウに移動する
" @param to_entry_buf 1:entryウィンドウに移動, 0:contentウィンドウに移動
function! s:GoWindow(to_entry_buf)
  if a:to_entry_buf
    let bufname = s:entrybufname . s:bufindex
  else
    let bufname = s:contentbufname . s:bufindex
  endif
  if s:SelectWindowByName(bufname) < 0
    if s:OpenWindow('split ' . bufname) < 0
      return -1
    endif
  endif
  return 0
endfunction

" entryウィンドウ上から、contentウィンドウの高さを最大化する
function! s:MaximizeContentHeight()
  if s:GoWindow(0) < 0
    return
  endif
  wincmd _
  call s:GoWindow(1)
endfunction

" title文字列から辞書番号を返す
" @param title 辞書のtitle文字列
" @return 辞書番号
function! s:GetDictNumFromTitle(group, title)
  let dictlist = s:GetDictList(a:group)
  let i = 0
  while i < len(dictlist)
    if a:title ==# dictlist[i].title
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

" 辞書一覧を表示する
" @param {Number} group 対象の辞書グループ番号
function! s:ListDict(group)
  let gr = s:ExpandDefaultGroup(a:group)
  let dictlist = s:GetDictList(gr)
  echo '辞書グループ: ' . gr
  " EblookSkipDict等では辞書番号を指定するので、辞書番号付きで表示する
  let i = 0
  while i < len(dictlist)
    let dict = dictlist[i]
    let skip = '    '
    if get(dict, 'skip')
      let skip = 'skip'
    endif
    let book = get(dict, 'book', '')
    let appendix = get(dict, 'appendix', '')
    echo skip . ' ' . i . ' ' . dict.title . ' ' . dict.name . ' ' . book . ' ' . appendix
    let i = i + 1
  endwhile
endfunction

" 辞書をスキップするかどうかを一時的に設定する。
" @param {Number} group 対象の辞書グループ番号
" @param is_skip スキップするかどうか。1:スキップする, 0:スキップしない
" @param ... 辞書番号のリスト
function! s:SetDictSkip(group, is_skip, ...)
  let dictlist = s:GetDictList(a:group)
  for dnum in a:000
    let dictlist[dnum].skip = a:is_skip
  endfor
endfunction

" 辞書グループの一覧を表示する
" @param {Number} max チェックする辞書グループ番号の最大値
function! s:ListGroup(max)
  let maxnum = a:max
  if maxnum == 0
    let maxnum = 99
  endif
  let i = 1
  while i <= maxnum
    if exists("g:eblook_dictlist{i}")
      let dictlist = g:eblook_dictlist{i}
      let titles = []
      let skipdicts = 0
      let j = 0
      while j < len(dictlist)
	let dict = dictlist[j]
	if get(dict, 'skip')
	  call add(titles, '(' . dict.title . ')')
	  let skipdicts += 1
	else
	  call add(titles, dict.title)
	endif
	let j = j + 1
      endwhile
      let ndicts = len(dictlist)
      if skipdicts > 0
	let ndicts .= '(' . skipdicts . ')'
      endif
      echo i . ' ' . ndicts . ' ' . join(titles, ', ')
    endif
    let i = i + 1
  endwhile
endfunction

" countが指定されていない時に検索対象にする辞書グループ番号を設定する
" @param {Number} group 対象の辞書グループ番号
function! s:SetDefaultGroup(group)
  if a:group == 0
    echomsg 'eblook-vim: g:eblook_group=' . g:eblook_group
  else
    let g:eblook_group = a:group
  endif
endfunction

" group番号が0(未指定)であれば、g:eblook_groupの値を返す。
" (countを指定せずに操作した時に、どの辞書グループが使われたかが、
" ユーザにわかるようにするため)
function! s:ExpandDefaultGroup(group)
  if a:group == 0
    return g:eblook_group
  else
    return a:group
  endif
endfunction

" SelectWindowByName(name)
"   Acitvate selected window by a:name.
function! s:SelectWindowByName(name)
  let num = bufwinnr('^' . a:name . '$')
  if num > 0 && num != winnr()
    execute num . 'wincmd w'
  endif
  return num
endfunction

" 新しいウィンドウを開く
function! s:OpenWindow(cmd)
  if winheight(0) > 2
    silent execute a:cmd
    return winnr()
  else
    " 'noequalalways'の場合、高さが足りずにsplitがE36エラーになる場合あるので、
    " 一番高さのあるwindowで再度splitを試みる
    let maxheight = 2
    let maxnr = 0
    for i in range(1, winnr('$'))
      let height = winheight(i)
      if height > maxheight
	let maxheight = height
	let maxnr = i
      endif
    endfor
    if maxnr > 0
      execute maxnr . 'wincmd w'
      silent execute a:cmd
      return winnr()
    else
      redraw
      echomsg 'eblook-vim: 画面上の空きが足りないため新規ウィンドウを開くのに失敗しました。ウィンドウを閉じて空きを作ってください(:' . a:cmd . ')'
      return -1
    endif
  endif
endfunction

" 空のバッファを作る
function! s:Empty_BufReadCmd()
endfunction

" eblook-vim-1.1.0からの辞書指定形式をペーストする。
" eblook-vim-1.0.5からの形式変換用。
" @param {Number} group 対象の辞書グループ番号
function! s:PasteDictList(group)
  let gr = s:ExpandDefaultGroup(a:group)
  let dictlist = s:GetDictList(gr)
  let save_paste = &paste
  let &paste = 1
  execute 'normal! olet eblook_dictlist' . gr . " = [\<Esc>"
  for dict in dictlist
    execute 'normal! o'
      \ . "  \\{ 'title': '" . dict.title . "',\<CR>"
      \ . "    \\'book': '" . dict.book . "',\<CR>"
      \ . "    \\'name': '" . dict.name . "',\<Esc>"
    if exists('dict.appendix')
      execute 'normal! o'
      \ . "    \\'appendix': '" . dict.appendix . "',\<Esc>"
    endif
    if exists('dict.skip')
      execute 'normal! o'
      \ . "    \\'skip': " . dict.skip . ",\<Esc>"
    endif
    execute 'normal! o'
      \ . "  \\},\<Esc>"
  endfor
  execute 'normal! o\]' . "\<Esc>"
  let &paste = save_paste
endfunction

let &cpo = s:save_cpo
