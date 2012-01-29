" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2012-01-28

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

" entryバッファの行数
if !exists('eblook_entrybuf_height')
  let eblook_entrybuf_height = 4
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

" 辞書のtitleが設定されていなかったら、辞書番号とnameを設定しておく
let s:i = 1
while exists("g:eblook_dict{s:i}_name")
  if !exists("g:eblook_dict{s:i}_title")
    let g:eblook_dict{s:i}_title = s:i . g:eblook_dict{s:i}_name
  endif
  " 直前のbook用に指定したappendixが引き継がれないようにappendixは必ず付ける
  " (XXX: eblook 1.6.1+media版では対処されているので不要)
  if g:eblook_dict{s:i}_book !~ '\S\+\s\+\S\+'
    let g:eblook_dict{s:i}_book = g:eblook_dict{s:i}_book . ' ' . g:eblook_dict{s:i}_book
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
  let str = input('eblook: ')
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
  call s:NewBuffers()
  call s:RedirSearchCommand(a:key)
  call s:ExecuteEblook()

  silent! :g/eblook.*> \(eblook.*> \)/s//\1/g
  let i = 1
  while exists("g:eblook_dict{i}_name")
    if exists("g:eblook_dict{i}_skip") && g:eblook_dict{i}_skip
      let i = i + 1
      continue
    endif
    let dname = g:eblook_dict{i}_name
    let title = g:eblook_dict{i}_title
    let gaijimap = s:GetGaijiMap(i)
    silent! execute ':g/eblook-' . i . '>/;/^eblook/-1s/<gaiji=\([^>]*\)>/\=s:GetGaiji(gaijimap, submatch(1))/g'
    silent! execute ':g/eblook-' . i . '>/;/^eblook/-1s/^/' . title . "\t"
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
    silent echo 'set prompt "eblook-' . i . '> "'
    silent echo 'search "' . a:key . "\"\n"
    let i = i + 1
  endwhile
  redir END
endfunction

" eblookプログラムを実行する
function! s:ExecuteEblook()
  " ++encを指定しないとEUCでの短い出力をCP932と誤認識することがある
  silent execute 'read! ++enc=' . g:eblookenc . ' "' . g:eblookprg . '" ' . s:eblookopt . ' < "' . s:cmdfile . '"'
  if &encoding ==# 'utf-8' && s:eblookopt !=# '-e utf8'
    setlocal fileencoding=utf-8
  endif

  silent! :g/^Warning: you should specify a book directory first$/d _
  silent! :g/<snd=[^>]*>.*<\/snd>/s///g
endfunction

" 新しく検索を行うために、entryバッファとcontentバッファを作る。
function! s:NewBuffers()
  " entryバッファとcontentバッファは一対で扱う。
  let oldindex = s:bufindex
  let s:bufindex = s:NextBufIndex()
  call s:CreateBuffer(s:entrybufname, oldindex)
  call s:CreateBuffer(s:contentbufname, oldindex)
  execute "normal! \<C-W>p" . g:eblook_entrybuf_height . "\<C-W>_"
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
    execute "silent normal! :split " . newbufname . "\<CR>"
  else
    execute "silent normal! :edit " . newbufname . "\<CR>"
  endif
  if bufexists
    silent execute "normal! :%d _\<CR>"
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

  silent execute "normal! :%d _\<CR>"
  let b:dictnum = dnum
  execute 'redir! >' . s:cmdfile
  if exists("g:eblook_dict{b:dictnum}_book")
    silent echo 'book ' . g:eblook_dict{b:dictnum}_book
  endif
  silent echo 'select ' . g:eblook_dict{b:dictnum}_name
  silent echo 'content ' . refid . "\n"
  redir END
  call s:ExecuteEblook()

  let height = winheight(0)
  silent! :g/eblook> /s///g
  call s:ReplaceGaiji(dnum)
  silent! :g/^$/d _
  normal! 1G
  " utf-8への外字置換をするとなぜかウィンドウ高さが1行になるので元に戻す
  execute 'normal! ' . height . "\<C-W>_\<C-W>p"
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
  if !exists("g:eblook_dict{a:dnum}_gaijimap")
    let g:eblook_dict{a:dnum}_gaijimap = s:LoadGaijiMapFile(a:dnum)
  endif
  return g:eblook_dict{a:dnum}_gaijimap
endfunction

" EBWin形式の外字定義ファイルを読み込む
" http://hishida.s271.xrea.com/manual/EBPocket/0_0_4_4.html
" @param dnum 辞書番号
function! s:LoadGaijiMapFile(dnum)
  let name = g:eblook_dict{a:dnum}_name
  let dir = substitute(g:eblook_dict{a:dnum}_book, '\s\+.*', '', '')
  let mapfile = dir . '/' . toupper(name) . '.map'
  let gaijimap = {}
  if !filereadable(mapfile)
    return gaijimap
  endif
  execute 'silent normal! :sview ' . mapfile . "\<CR>"
  setlocal nobuflisted
  for line in getline(1, '$')
    if line !~ '^[hzcg][[:xdigit:]]\{4\}'
      continue
    endif
    " 例: hA121	u00E0	a	# comment
    let lst = split(line)
    let gaiji = tolower(get(lst, 0))
    let unicode = get(lst, 1, '-')
    let unicode = substitute(unicode, ',', '', 'g')
    let ascii = get(lst, 2, '')
    let value = [unicode, ascii]
    " {'ha121':['u00E1','a'], ...}
    " => {'ha121':['u00E1','a','u00E1に対応する文字'], ... }
    if &encoding ==# 'utf-8'
      let u8str = substitute(unicode, 'u\([[:xdigit:]]\{4}\)', '\=nr2char("0x" . submatch(1))', 'g')
      call add(value, u8str)
    endif
    let gaijimap[gaiji] = value
  endfor
  bdelete!
  return gaijimap
endfunction

" 外字置換文字列を取得する。
" @param gaijimap 外字置換表
" @param key 外字キー
" @return 置換文字列
function! s:GetGaiji(gaijimap, key)
  let gaiji = get(a:gaijimap, a:key)
  if !gaiji
    return '_' . a:key . '_'     " DEBUG
    "return '_'
  endif
  if &encoding ==# 'utf-8'
    let res = gaiji[2]
    if res ==# 'null'
      return ''
    elseif res ==# '-'
      let res = gaiji[1]
    endif
  else
    let res = gaiji[1]
  endif
  if strlen(res) == 0
    return '_' . a:key . '_'     " DEBUG
    "return '_'
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
    execute "silent normal! :split " . s:contentbufname . s:bufindex . "\<CR>"
  endif
  let dnum = b:dictnum
  let save_line = line('.')
  let save_col = virtcol('.')
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
    execute 'normal! o' . g:eblook_dict{dnum}_title . "\<C-V>\<Tab>" . entry{j} . "\<C-V>\<Tab>" . label{j} . "\<Esc>"
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
    execute "silent normal! :split " . s:entrybufname . ni . "\<CR>"
  else
    execute "silent normal! :edit " . s:entrybufname . ni . "\<CR>"
  endif
  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    execute "silent normal! :split " . s:contentbufname . ni . "\<CR>"
  else
    execute "silent normal! :edit " . s:contentbufname . ni . "\<CR>"
  endif
  execute "normal! \<C-W>p"
  let s:bufindex = ni
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
    let bufname = s:entrybufname . s:bufindex
  else
    let bufname = s:contentbufname . s:bufindex
  endif
  if s:SelectWindowByName(bufname) < 0
    execute "silent normal! :split " . bufname . "\<CR>"
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
