" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2012-02-09

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
"    'eblook_dictlist'
"      EPWING辞書の|List|。Listの各要素は以下のkeyを持つ|Dictionary|。
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
"         Appendixがある場合は、
"         辞書ディレクトリに続けてAppendixディレクトリを指定。
"
"      'name'
"         eblookプログラムの`select'コマンドに渡すパラメータ。
"         辞書名を指定。eblookプログラムのlistコマンドで調べる。
"
"      'skip'
"         0でない値を設定すると、この辞書は検索しない。
"         ('skip'キーが未指定の場合は0とみなす)
"
"      例:
"        let eblook_dictlist =
"        \[
"        \  {
"        \    'title': '広辞苑第五版',
"        \    'book': '/usr/local/epwing/tougou99',
"        \    'name': 'kojien',
"        \    'skip': 0
"        \  },
"        \  {
"        \    'title': 'ジーニアス英和大辞典',
"        \    'book': '/usr/local/epwing/GENIUS /usr/local/epwing/appendix/genius2-1.1',
"        \    'name': 'genius'
"        \  }
"        \]
"
"    'eblook_entrywin_height'
"       entryウィンドウの行数(目安)。省略値: 4
"
"    'eblook_history_max'
"       保持しておく過去の検索履歴バッファ数の上限。省略値: 10
"
"    'eblookprg'
"       このスクリプトから呼び出すeblookプログラムの名前。省略値: eblook
"
"    'eblookenc'
"       eblookプログラムの出力を読み込むときのエンコーディング。
"       設定可能な値は|'encoding'|参照。省略値: &encoding
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

" entryウィンドウの行数
if !exists('eblook_entrywin_height')
  let eblook_entrywin_height = 4
endif

" 保持しておく過去の検索バッファ数の上限
if !exists('eblook_history_max')
  let eblook_history_max = 10
endif

" eblookプログラムの名前
if !exists('eblookprg')
  let eblookprg = 'eblook'
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

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)
command! EblookListDict call <SID>ListDict()
command! -nargs=* EblookSkipDict call <SID>SetDictSkip(1, <f-args>)
command! -nargs=* EblookNotSkipDict call <SID>SetDictSkip(0, <f-args>)

" </reference=>で指定されるentryのpattern
let s:refpat = '[[:xdigit:]]\+:[[:xdigit:]]\+'
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

" マッピング
let s:set_mapleader = 0
if !exists('g:mapleader')
  let g:mapleader = "\<C-K>"
  let s:set_mapleader = 1
endif
nnoremap <silent> <Leader><C-Y> :<C-U>call <SID>SearchInput()<CR>
nnoremap <silent> <Leader>y :<C-U>call <SID>Search(expand('<cword>'))<CR>
vnoremap <silent> <Leader>y :<C-U>call <SID>SearchVisual()<CR>
"vnoremap <silent> <Leader>y ""y:<C-U>call <SID>Search("<C-R>"")<CR>
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

if !exists("g:eblook_dictlist")
  let g:eblook_dictlist = []
  let s:i = 1
  while exists("g:eblook_dict{s:i}_name")
    let dict = { 'name': g:eblook_dict{s:i}_name }
    if exists("g:eblook_dict{s:i}_book")
      let dict.book = g:eblook_dict{s:i}_book
    endif
    if exists("g:eblook_dict{s:i}_title")
      let dict.title = g:eblook_dict{s:i}_title
    endif
    if exists("g:eblook_dict{s:i}_skip")
      let dict.skip = g:eblook_dict{s:i}_skip
    else
      let dict.skip = 0
    endif
    call add(g:eblook_dictlist, dict)
    let s:i = s:i + 1
  endwhile
  unlet s:i
endif

let s:i = 0
while s:i < len(g:eblook_dictlist)
  let dict = g:eblook_dictlist[s:i]
  " 辞書のtitleが設定されていなかったら、辞書番号とnameを設定しておく
  if !exists('dict.title')
    let dict.title = s:i . dict.name
  endif
  " 直前のbook用に指定したappendixが引き継がれないようにappendixは必ず付ける
  " (XXX: eblook 1.6.1+media版では対処されているので不要)
  if dict.book !~ '^"[^"]\+"\s\+\S\+\|^[^"]\+\s\+\S\+'
    let dict.book = dict.book . ' ' . dict.book
  endif
  let s:i = s:i + 1
endwhile
unlet s:i

" entryバッファに入った時に実行。set nobuflistedする。
function! s:Entry_BufEnter()
  set buftype=nofile
  set bufhidden=hide
  set noswapfile
  set nobuflisted
  set filetype=eblook
  if has("conceal")
    setlocal conceallevel=2 concealcursor=nc
  endif
  nnoremap <buffer> <silent> <CR> :call <SID>GetContent()<CR>
  nnoremap <buffer> <silent> J j:call <SID>GetContent()<CR>
  nnoremap <buffer> <silent> K k:call <SID>GetContent()<CR>
  nnoremap <buffer> <silent> <Space> :call <SID>ScrollContent(1)<CR>
  nnoremap <buffer> <silent> <BS> :call <SID>ScrollContent(0)<CR>
  nnoremap <buffer> <silent> p :call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :call <SID>ListReferences()<CR>
  nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>
  execute 'nnoremap <buffer> <silent> <Tab> /' . s:refpat . '<CR>'
endfunction

" contentバッファに入った時に実行。set nobuflistedする。
function! s:Content_BufEnter()
  set buftype=nofile
  set bufhidden=hide
  set noswapfile
  set nobuflisted
  set filetype=eblook
  if has("conceal")
    setlocal conceallevel=2 concealcursor=nc
  endif
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
endfunction

" プロンプトを出して、ユーザから入力された文字列を検索する
function! s:SearchInput()
  let str = input('eblook-vim: ')
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
endfunction

" Visual modeで選択されている文字列を検索する
function! s:SearchVisual()
  let save_reg = @@
  silent execute 'normal! `<' . visualmode() . '`>y'
  call s:Search(substitute(@@, '\n', '', 'g'))
  let @@ = save_reg
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
  if s:RedirSearchCommand(a:key) < 0
    return -1
  endif
  if s:NewBuffers() < 0
    return -1
  endif
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
  while i < len(g:eblook_dictlist)
    let dict = g:eblook_dictlist[i]
    if get(dict, 'skip')
      let i = i + 1
      continue
    endif
    if index(gaijidnums, i) >= 0
      let gaijimap = s:GetGaijiMap(i)
      silent! execute ':g/eblook-' . i . '>/;/^eblook/-1s/<gaiji=\([^>]*\)>/\=s:GetGaiji(gaijimap, submatch(1))/g'
    endif
    silent! execute ':g/eblook-' . i . '>/;/^eblook/-1s/^/' . dict.title . "\t"
    let i = i + 1
  endwhile
  silent! :g/eblook.*> /s///g
  silent! :g/^$/d _
  normal! 1G
  if s:GetContent() < 0
    if search('.', 'w') == 0
      bwipeout!
      silent! call s:History(-1)
      if hasoldwin < 0
	call s:Quit()
      endif
      redraw | echomsg 'eblook-vim: 何も見つかりませんでした: <' . a:key . '>'
    endif
  endif
endfunction

" eblookプログラムにリダイレクトするための検索コマンドファイルを作成する
function! s:RedirSearchCommand(key)
  if s:OpenWindow('new') < 0
    return -1
  endif
  setlocal nobuflisted
  let prev_book = ''
  let i = 0
  while i < len(g:eblook_dictlist)
    let dict = g:eblook_dictlist[i]
    if get(dict, 'skip')
      let i = i + 1
      continue
    endif
    if exists('dict.book') && dict.book !=# prev_book
      execute 'normal! obook ' . dict.book . "\<Esc>"
      let prev_book = dict.book
    endif
    execute 'normal! oselect ' . dict.name . "\<CR>"
      \ . 'set prompt "eblook-' . i . '> "' . "\<CR>"
      \ . 'search "' . a:key . '"' . "\<CR>\<Esc>"
    let i = i + 1
  endwhile
  silent execute 'write! ++enc=' . g:eblookenc . ' ' . s:cmdfile
  close!
  return 0
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
function! s:NewBuffers()
  " entryバッファとcontentバッファは一対で扱う。
  let oldindex = s:bufindex
  let s:bufindex = s:NextBufIndex()
  if s:CreateBuffer(s:entrybufname, oldindex) < 0
    let s:bufindex = oldindex
    return -1
  endif
  if s:CreateBuffer(s:contentbufname, oldindex) < 0
    call s:Quit()
    let s:bufindex = oldindex
    return -1
  endif
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
    execute "silent normal! :edit " . newbufname . "\<CR>"
  endif
  if bufexists
    silent execute "normal! :%d _\<CR>"
  endif
  return 0
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
  if dnum < 0
    return -1
  endif
  let refid = matchstr(str, s:refpat)
  if strlen(refid) == 0
    return -1
  endif

  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    if s:OpenWindow('split ' . s:contentbufname . s:bufindex) < 0
      return -1
    endif
  endif

  silent execute "normal! :%d _\<CR>"
  let b:dictnum = dnum
  execute 'redir! >' . s:cmdfile
  if exists("g:eblook_dictlist[b:dictnum].book")
    silent echo 'book ' . g:eblook_dictlist[b:dictnum].book
  endif
  silent echo 'select ' . g:eblook_dictlist[b:dictnum].name
  silent echo 'content ' . refid . "\n"
  redir END
  call s:ExecuteEblook()

  silent! :g/eblook> /s///g
  if search('<gaiji=', 'nw') != 0
    call s:ReplaceGaiji(dnum)
  endif
  silent! :g/^$/d _
  normal! 1G
  call s:GoWindow(1)
  return 0
endfunction

" <gaiji=xxxxx>を置き換える。
function! s:ReplaceGaiji(dnum)
  let gaijimap = s:GetGaijiMap(a:dnum)
  silent! :g/<gaiji=\([^>]*\)>/s//\=s:GetGaiji(gaijimap, submatch(1))/g
endfunction

" 外字置換表を取得する
" @param dnum 辞書番号
" @return 外字置換表
function! s:GetGaijiMap(dnum)
  if !exists("g:eblook_dictlist[a:dnum].gaijimap")
    try
      let g:eblook_dictlist[a:dnum].gaijimap = s:LoadGaijiMapFile(a:dnum)
    catch /load-error/
      " ウィンドウを閉じて空きを作って再度検索し直した時に外字取得できるように
      return {}
    endtry
  endif
  return g:eblook_dictlist[a:dnum].gaijimap
endfunction

" EBWin形式の外字定義ファイルを読み込む
" http://hishida.s271.xrea.com/manual/EBPocket/0_0_4_4.html
" @param dnum 辞書番号
" @return 読み込んだ外字置換表。{'ha121':[unicode, ascii], ...}
function! s:LoadGaijiMapFile(dnum)
  let name = g:eblook_dictlist[a:dnum].name
  let dir = matchstr(g:eblook_dictlist[a:dnum].book, '"\zs[^"]\+\ze"\|\S\+')
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
  setlocal nobuflisted
  for line in getline(1, '$')
    if line !~ '^[hzcg][[:xdigit:]]\{4}'
      continue
    endif
    " 例: hA121	u00E0	a	# comment
    let lst = split(line)
    let gaiji = tolower(get(lst, 0))
    let unicode = get(lst, 1, '-')
    let ascii = get(lst, 2, '')
    if &encoding ==# 'utf-8'
      let unicode = substitute(unicode, ',', '', 'g')
      let unicode = substitute(unicode, 'u\([[:xdigit:]]\{4}\)', '\=nr2char("0x" . submatch(1))', 'g')
    endif
    let gaijimap[gaiji] = [unicode, ascii]
  endfor
  close!
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
      let refid = matchstr(str, s:refpat, offset)
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
    if s:OpenWindow('split ' . s:contentbufname . s:bufindex) < 0
      return
    endif
  endif
  let dnum = b:dictnum
  let save_line = line('.')
  let save_col = virtcol('.')
  " ggでバッファ先頭に移動してからsearch()で検索すると、
  " バッファ冒頭の検索対象文字列にヒットしないので、末尾からwrap aroundして検索
  normal! G$
  let searchflag = 'w'
  let label = []
  let entry = []
  while search('<reference>', searchflag) > 0
    let line = getline('.')
    let col = col('.') - 1
    call add(label, matchstr(line, '<reference>\zs.\{-}\ze</reference', col))
    call add(entry, matchstr(line, s:refpat, col))
    let searchflag = 'W'
  endwhile
  if len(label) == 0
    return
  endif
  execute 'normal! ' . save_line . 'G' . save_col . '|'

  if s:NewBuffers() < 0
    return -1
  endif
  let title = g:eblook_dictlist[dnum].title
  let j = 0
  while j < len(label)
    execute 'normal! o' . title . "\<C-V>\<Tab>" . entry[j] . "\<C-V>\<Tab>" . label[j] . "\<Esc>"
    let j = j + 1
  endwhile
  silent! :g/^$/d _

  normal! gg
  if strlen(a:refid) > 0
    execute 'normal! /' . a:refid . "\<CR>"
  endif
  call s:GetContent()
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
    execute "silent normal! :edit " . s:entrybufname . ni . "\<CR>"
  endif
  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    call s:OpenWindow('split ' . s:contentbufname . ni)
  else
    execute "silent normal! :edit " . s:contentbufname . ni . "\<CR>"
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

" title文字列から辞書番号を返す
" @param title 辞書のtitle文字列
" @return 辞書番号
function! s:GetDictNumFromTitle(title)
  let i = 0
  while i < len(g:eblook_dictlist)
    if a:title ==# g:eblook_dictlist[i].title
      return i
    endif
    let i = i + 1
  endwhile
  return -1
endfunction

" 辞書一覧を表示する
function! s:ListDict()
  let i = 0
  while i < len(g:eblook_dictlist)
    let dict = g:eblook_dictlist[i]
    let skip = ''
    if get(dict, 'skip')
      let skip = 'skip'
    endif
    let book = get(dict, 'book', '')
    echo skip . "\t" . i . "\t" . dict.title . "\t" . dict.name . "\t" . book
    let i = i + 1
  endwhile
endfunction

" 辞書をスキップするかどうかを一時的に設定する。
" @param is_skip スキップするかどうか。1:スキップする, 0:スキップしない
" @param ... 辞書番号のリスト
function! s:SetDictSkip(is_skip, ...)
  for dnum in a:000
    let g:eblook_dictlist[dnum].skip = a:is_skip
  endfor
endfunction

" SelectWindowByName(name)
"   Acitvate selected window by a:name.
function! s:SelectWindowByName(name)
  let num = bufwinnr('^' . a:name . '$')
  if num > 0 && num != winnr()
    execute 'normal! ' . num . "\<C-W>\<C-W>"
  endif
  return num
endfunction

" 新しいウィンドウを開く
function! s:OpenWindow(cmd)
  if winheight(0) > 2
    execute "silent normal! :" . a:cmd . "\<CR>"
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
      execute "silent normal! :" . a:cmd . "\<CR>"
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
