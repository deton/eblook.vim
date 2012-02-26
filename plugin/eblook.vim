" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2012-02-26
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
"   `eblook'�v���O�������g����EPWING/�d�q�u�b�N��������������B
"   ���̃X�N���v�g���g�����߂ɂ́A
"   `eblook'�v���O����<http://openlab.jp/edict/eblook/>��EPWING�������K�v�B
"
"   <Leader><C-Y>�������Č��������͂���ƁA�������ʂ�entry�E�B���h�E��
"   content�E�B���h�E�ɕ\�������B
"
" �R�}���h:
"   :EblookSearch         �w�肵���P��̌������s��
"   :EblookListGroup      �����O���[�v�̈ꗗ��\������
"   :EblookGroup          count��w�莞�̌����Ώێ����O���[�v�ԍ���ݒ�
"   :EblookListDict       �����̈ꗗ��\������
"   :EblookSkipDict       �w�肵�������ԍ��̎������ꎞ�I�Ɍ����Ώۂ���O��
"   :EblookNotSkipDict    �w�肵�������ԍ��̎������ꎞ�I�Ɍ����Ώۂɓ����
"   :EblookPasteDictList  �����ݒ���y�[�X�g����(eblook-vim-1.1.0�ւ̈ڍs�p)
"
" nmap:
"   <Leader><C-Y>       �����P�����͂��Č������s��
"   <Leader>y           �J�[�\���ʒu�ɂ���P�����������
"
" vmap:
"   <Leader>y           �I���������������������
"
" entry�o�b�t�@��nmap
"   <CR>                �J�[�\���s��entry�ɑΉ�����content��\������
"   J                   �J�[�\�������̍s�Ɉړ�����content��\������
"   K                   �J�[�\������̍s�Ɉړ�����content��\������
"   <Space>             content�E�B���h�E��PageDown���s��
"   <BS>                content�E�B���h�E��PageUp���s��
"   q                   entry�E�B���h�E��content�E�B���h�E�����
"   s                   �V�����P�����͂��Č�������(<Leader><C-Y>�Ɠ���)
"   S                   ���O�̌������[count]�Ŏw�肷�鎫���O���[�v�ōČ�������
"   p                   content�E�B���h�E�Ɉړ�����
"   R                   reference�ꗗ��\������
"   <C-P>               �������𒆂̈�O�̃o�b�t�@��\������
"   <C-N>               �������𒆂̈���̃o�b�t�@��\������
"   O                   content�E�B���h�E���̒����s��|gq|�Ő��`����
"
" content�o�b�t�@��nmap
"   <CR>                �J�[�\���ʒu��reference��\������
"   <Space>             PageDown���s��
"   <BS>                PageUp���s��
"   <Tab>               ����reference�ɃJ�[�\�����ړ�����
"   q                   entry�E�B���h�E��content�E�B���h�E�����
"   s                   �V�����P�����͂��Č�������(<Leader><C-Y>�Ɠ���)
"   S                   ���O�̌������[count]�Ŏw�肷�鎫���O���[�v�ōČ�������
"   p                   entry�E�B���h�E�Ɉړ�����
"   R                   reference�ꗗ��\������
"   <C-P>               �������𒆂̈�O�̃o�b�t�@��\������
"   <C-N>               �������𒆂̈���̃o�b�t�@��\������
"   O                   content�E�B���h�E���̒����s��|gq|�Ő��`����
"
" �I�v�V����:
"    'eblook_group'
"      |[count]|���w�肳��Ă��Ȃ����Ɍ����Ώۂɂ��鎫���O���[�v�ԍ��B
"      �ȗ��l: 1
"
"    'eblook_dictlist{n}'
"      �����O���[�v{n}��EPWING������|List|�B{n}��1�ȏ�B
"      List�̊e�v�f�͈ȉ���key������|Dictionary|�B
"
"      'title'
"         �����̎��ʎq���w��Bentry�E�B���h�E���Ŏ��������ʂ��邽�߂Ɏg���B
"         (eblook.vim�����ł͎����ԍ���title�Ŏ��������ʂ���B)
"         ���������ʂ��邽�߂Ɏg�������Ȃ̂ŁA
"         ���̎����ƂԂ���Ȃ��������K���ɂ���B
"
"      'book'
"         eblook�v���O������`book'�R�}���h�ɓn���p�����[�^�B
"         �����̂���f�B���N�g��(catalogs�t�@�C���̂���f�B���N�g��)���w��B
"
"      'appendix' (�ȗ��\)
"         Appendix���g���ꍇ�́AAppendix�f�B���N�g�����w��B
"         eblook�v���O������`book'�R�}���h�ɓn��2�Ԗڂ̃p�����[�^�B
"
"      'name'
"         eblook�v���O������`select'�R�}���h�ɓn���p�����[�^�B
"         ���������w��Beblook�v���O������list�R�}���h�Œ��ׂ�B
"
"      'skip' (�ȗ��\)
"         0�łȂ��l��ݒ肷��ƁA���̎����͌������Ȃ��B
"         ('skip'�L�[�����w��̏ꍇ��0�Ƃ݂Ȃ�)
"
"      'autoformat' (�ȗ��\)
"         content�\�����ɒ����s��|gq|�Ő��`���邩�ǂ����B
"         ('autoformat'�L�[�����w��̏ꍇ��0�Ƃ݂Ȃ�)
"
"      ��:
"        let eblook_dictlist1 = [
"          \{
"            \'title': '�L������ܔ�',
"            \'book': '/usr/local/epwing/tougou99',
"            \'name': 'kojien',
"          \},
"          \{
"            \'title': '�W�[�j�A�X�p�a�厫�T',
"            \'book': '/usr/local/epwing/GENIUS',
"            \'appendix': '/usr/local/epwing/appendix/genius2-1.1',
"            \'name': 'genius'
"          \},
"          \{
"            \'title': '����p��̊�b�m��',
"            \'book': '/usr/local/epwing/tougou99',
"            \'name': 'gn99ep01',
"            \'skip': 1,
"            \'autoformat': 1,
"          \},
"        \]
"
"    'eblook_entrywin_height'
"       entry�E�B���h�E�̍s��(�ڈ�)�B�ȗ��l: 4
"
"    'eblook_history_max'
"       �ێ����Ă����ߋ��̌��������o�b�t�@���̏���B�ȗ��l: 10
"
"    'eblook_autoformat_default'
"       content�E�B���h�E���̒����s��|gq|�Ő��`���邩�ǂ����̃f�t�H���g�l�B
"       �S��������ɐ��`�������ꍇ����(�S�����ɂ���'autoformat'�v���p�e�B
"       ���w�肷��͖̂ʓ|�Ȃ̂�)�B�ȗ��l: 0
"
"    'eblookprg'
"       ���̃X�N���v�g����Ăяo��eblook�v���O�����̖��O�B�ȗ��l: eblook
"
"    'eblookenc'
"       eblook�v���O�����̏o�͂�ǂݍ��ނƂ��̃G���R�[�f�B���O�B
"       �ݒ�\�Ȓl��|'encoding'|�Q�ƁB�ȗ��l: &encoding
"
"    '<Plug>EblookInput'
"       �����P�����͂��Č������s�����߂̃L�[�B�ȗ��l: <Leader><C-Y>
"       <Leader><C-Y>���w�肷��ꍇ�̗�:
"         map <Leader><C-Y> <Plug>EblookInput
"
"    '<Plug>EblookSearch'
"       �J�[�\���ʒu�ɂ���P��(nmap)/�I������������(vmap)���������邽�߂̃L�[�B
"       �ȗ��l: <Leader>y
"       <Leader>y���w�肷��ꍇ�̗�:
"         map <Leader>y <Plug>EblookSearch
"
"    'mapleader'
"       �L�[�}�b�s���O�̃v���t�B�b�N�X�B|mapleader|���Q�ƁB�ȗ��l: CTRL-K
"       CTRL-K���w�肷��ꍇ�̗�:
"         let mapleader = "\<C-K>"
"
"    'plugin_eblook_disable'
"       ���̃v���O�C����ǂݍ��݂����Ȃ��ꍇ�Ɏ��̂悤�ɐݒ肷��B
"         let plugin_eblook_disable = 1

if exists('plugin_eblook_disable') || exists('g:loaded_eblook')
  finish
endif
let g:loaded_eblook = 1

let s:save_cpo = &cpo
set cpo&vim

" entry�E�B���h�E�̍s��
if !exists('eblook_entrywin_height')
  let eblook_entrywin_height = 4
endif

" �ێ����Ă����ߋ��̌����o�b�t�@���̏��
if !exists('eblook_history_max')
  let eblook_history_max = 10
endif

if !exists('eblook_autoformat_default')
  let eblook_autoformat_default = 0
endif

" eblook�v���O�����̖��O
if !exists('eblookprg')
  let eblookprg = 'eblook'
endif

" eblook�v���O�����̏o�͂�ǂݍ��ނƂ��̃G���R�[�f�B���O
if !exists('eblookenc')
  let eblookenc = &encoding
endif
" eblookenc�l(vim��encoding)����eblook --encoding�I�v�V�����l�ւ̕ϊ��e�[�u��
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
  command -range=0 -nargs=1 EblookSearch call <SID>Search(<count>, <q-args>)
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

let s:refpat = '</reference=\zs\x\+:\x\+\ze>'
" eblook�Ƀ��_�C���N�g����R�}���h��ێ�����ꎞ�t�@�C����
let s:cmdfile = tempname()
" entry�o�b�t�@���̃x�[�X
let s:entrybufname = fnamemodify(s:cmdfile, ':p:h') . '/_eblook_entry_'
let s:entrybufname = substitute(s:entrybufname, '\\', '/', 'g')
" content�o�b�t�@���̃x�[�X
let s:contentbufname = fnamemodify(s:cmdfile, ':p:h') . '/_eblook_content_'
let s:contentbufname = substitute(s:contentbufname, '\\', '/', 'g')
" �o�b�t�@�q�X�g�����̌��݈ʒu
let s:bufindex = 0
" ���O�Ɍ�������������
let s:lastkey = ''

" �}�b�s���O
let s:set_mapleader = 0
if !exists('g:mapleader')
  let g:mapleader = "\<C-K>"
  let s:set_mapleader = 1
endif
" (<Plug>EblookSearch��<Plug>EblookSearchInput�ɂ���ƁA
"  <Plug>EblookSearch�̕���|'timeout'|�҂��ɂȂ�)
if !hasmapto('<Plug>EblookInput')
  map <unique> <Leader><C-Y> <Plug>EblookInput
endif
noremap <unique> <script> <Plug>EblookInput <SID>Input
noremap <SID>Input :<C-U>call <SID>SearchInput(v:count, g:eblook_group, 0)<CR>
if !hasmapto('<Plug>EblookSearch', 'n')
  nmap <unique> <Leader>y <Plug>EblookSearch
endif
nnoremap <unique> <script> <Plug>EblookSearch <SID>SearchN
nnoremap <silent> <SID>SearchN :<C-U>call <SID>Search(v:count, expand('<cword>'))<CR>
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

" eblook-vim-1.0.5�܂ł̎����w��`����ǂݍ���
if !exists("g:eblook_dictlist1")
  let g:eblook_dictlist1 = []
  let s:i = 1
  while exists("g:eblook_dict{s:i}_name")
    let dict = { 'name': g:eblook_dict{s:i}_name }
    if exists("g:eblook_dict{s:i}_book")
      let dict.book = g:eblook_dict{s:i}_book
      " appendix���w�肳��Ă���ꍇ�Abook�Ƃ͕�������(�����₷�����邽��)
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
      " ������title���ݒ肳��Ă��Ȃ�������A�����ԍ���name��ݒ肵�Ă���
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

" entry�o�b�t�@�ɓ��������Ɏ��s�Bset nobuflisted����B
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
  nnoremap <buffer> <silent> O :call <SID>GetAndFormatContent()<CR>
  nnoremap <buffer> <silent> p :call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :call <SID>ListReferences()<CR>
  nnoremap <buffer> <silent> s :<C-U>call <SID>SearchInput(v:count, b:group, 0)<CR>
  nnoremap <buffer> <silent> S :<C-U>call <SID>SearchOtherGroup(v:count, b:group)<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>
  nnoremap <buffer> <silent> <Tab> /\t<CR>
endfunction

" content�o�b�t�@�ɓ��������Ɏ��s�Bset nobuflisted����B
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
  nnoremap <buffer> <silent> O :call <SID>FormatContent()<CR>
  nnoremap <buffer> <silent> p :call <SID>GoWindow(1)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :call <SID>FollowReference('')<CR>
  nnoremap <buffer> <silent> s :<C-U>call <SID>SearchInput(v:count, b:group, 0)<CR>
  nnoremap <buffer> <silent> S :<C-U>call <SID>SearchOtherGroup(v:count, b:group)<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
endfunction

" �v�����v�g���o���āA���[�U������͂��ꂽ���������������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {Number} defgroup �Ώۂ̎����O���[�v�ԍ�(�f�t�H���g)
" @param {Boolean} uselastkey ���O�̌�����������f�t�H���g������Ƃ��ē���邩
"   (<Leader>y�Ŏ擾�E����������������ꕔ�ύX���čČ����ł���悤��)
function! s:SearchInput(group, defgroup, uselastkey)
  let gr = a:group
  if a:group == 0
    let gr = a:defgroup
  endif
  if a:uselastkey
    let key = s:lastkey
  else
    let key = ''
  endif
  let str = input(':' . gr . 'EblookSearch ', key)
  if strlen(str) == 0 || str ==# key && gr == a:defgroup
    return
  endif
  call s:Search(gr, str)
endfunction

" (entry/content�E�B���h�E����)���O�̌���������𑼂̎����O���[�v�ōČ�������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {Number} defgroup ���݂̎����O���[�v�ԍ�
function! s:SearchOtherGroup(group, defgroup)
  let gr = s:ExpandDefaultGroup(a:group)
  if gr == a:defgroup
    return
  endif
  call s:Search(gr, s:lastkey)
endfunction

" Visual mode�őI������Ă��镶�������������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
function! s:SearchVisual(group)
  let save_reg = @@
  silent execute 'normal! `<' . visualmode() . '`>y'
  call s:Search(a:group, substitute(@@, '\n', '', 'g'))
  let @@ = save_reg
endfunction

" �w�肳�ꂽ�P��̌������s���B
" entry�o�b�t�@�Ɍ������ʂ̃��X�g��\�����A
" ���̂����擪��entry�̓��e��content�o�b�t�@�ɕ\������B
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {String} key ��������P��
function! s:Search(group, key)
  let s:lastkey = a:key
  let gr = s:ExpandDefaultGroup(a:group)
  let dictlist = s:GetDictList(gr)
  if len(dictlist) == 0
    echomsg 'eblook-vim: �����O���[�v(g:eblook_dictlist' . gr . ')�ɂ͎���������܂���'
    return -1
  endif
  let hasoldwin = bufwinnr(s:entrybufname . s:bufindex)
  if hasoldwin < 0
    let hasoldwin = bufwinnr(s:contentbufname . s:bufindex)
  endif
  if s:RedirSearchCommand(dictlist, a:key) < 0
    return -1
  endif
  if s:NewBuffers(gr) < 0
    return -1
  endif
  call s:ExecuteEblook()

  silent! :g/eblook.*> \(eblook.*> \)/s//\1/g
  " �K�v��gaiji map�t�@�C���̂ݓǂݍ���: <gaiji=�̂��鎫���ԍ������X�g�A�b�v
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
      " ������title���ݒ肳��Ă��Ȃ�������A�����ԍ���name��ݒ肷��
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

  " �e�s��reference���z��Ɋi�[���āA�o�b�t�@����͍폜
  " (conceal���Ă��J�E���g�����̂ŁA�s���r���Ő܂�Ԃ���Ă��܂����Ȃ̂�)
  let refs = getline(1, '$')
  call map(refs, 'matchstr(v:val, ''\%(\d\+\. \)\?\zs\x\+:\x\+\ze\t'')')
  let b:refs = refs
  silent! :g/\t.\{-}\t/s//\t/

  setlocal nomodifiable
  normal! 1G
  if s:GetContent() < 0
    if search('.', 'w') == 0
      bwipeout!
      silent! call s:History(-1)
      if hasoldwin < 0
	call s:Quit()
      endif
      "redraw | echomsg 'eblook-vim(' . gr . '): ����������܂���ł���: <' . a:key . '>'
      let str = input(':' . gr . 'EblookSearch(����������܂���ł���) ', a:key)
      if strlen(str) == 0 || str ==# a:key
	return
      endif
      call s:Search(gr, str)
    endif
  endif
endfunction

" eblook�v���O�����Ƀ��_�C���N�g���邽�߂̌����R�}���h�t�@�C�����쐬����
" @param dictlist �Ώۂ̎����O���[�v
" @param {String} key ��������P��
function! s:RedirSearchCommand(dictlist, key)
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
      \ . 'search "' . a:key . '"' . "\<CR>\<Esc>"
    let i = i + 1
  endwhile
  silent execute 'write! ++enc=' . g:eblookenc . ' ' . s:cmdfile
  close!
  return 0
endfunction

" �w�肳�ꂽ�����O���[�v�̎������X�g���擾����
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @return �������X�g
function! s:GetDictList(group)
  let gr = s:ExpandDefaultGroup(a:group)
  if exists("g:eblook_dictlist{gr}")
    let dictlist = g:eblook_dictlist{gr}
  else
    let dictlist = []
  endif
  return dictlist
endfunction

" eblook��book�Ɏw�肷�邽�߂̈����l�����
" @param {Dictionary} dict �������
" @return {String} book�Ɏw�肷�����
function! s:MakeBookArgument(dict)
  if exists('a:dict.appendix')
    return a:dict.book . ' ' . a:dict.appendix
  endif
  " ���O��book�p�Ɏw�肵��appendix�������p����Ȃ��悤��appendix�͕K���t����
  " (eblook 1.6.1+media�łł͑Ώ�����Ă���̂ŕs�v)
  if !exists('s:has_appendix_problem')
    let l:version = system(g:eblookprg . ' -version')
    if match(l:version, '^eblook 1\.6\.1+media-') >= 0
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

" eblook�v���O���������s����
function! s:ExecuteEblook()
  " ++enc���w�肵�Ȃ���EUC�ł̒Z���o�͂�CP932�ƌ�F�����邱�Ƃ�����
  silent execute 'read! ++enc=' . g:eblookenc . ' "' . g:eblookprg . '" ' . s:eblookopt . ' < "' . s:cmdfile . '"'
  if &encoding !=# g:eblookenc
    setlocal fileencoding=&encoding
  endif

  silent! :g/^Warning: you should specify a book directory first$/d _
endfunction

" �V�����������s�����߂ɁAentry�o�b�t�@��content�o�b�t�@�����B
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
function! s:NewBuffers(group)
  " entry�o�b�t�@��content�o�b�t�@�͈�΂ň����B
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
  let b:group = a:group
  if s:GoWindow(1) < 0
    call s:Quit()
    let s:bufindex = oldindex
    return -1
  endif
  let b:group = a:group
  execute g:eblook_entrywin_height . 'wincmd _'
  return 0
endfunction

" entry�o�b�t�@��content�o�b�t�@�̂����ꂩ�����
" @param bufname s:entrybufname��s:contentbufname�̂����ꂩ
" @param oldindex ���݂�entry,content�o�b�t�@�̃C���f�b�N�X�ԍ�
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

" entry�o�b�t�@�̃J�[�\���s�ɑΉ�������e��content�o�b�t�@�ɕ\������
" @return -1:content�\�����s, 0:�\������
function! s:GetContent()
  let str = getline('.')
  let title = matchstr(str, '^[^\t]\+')
  if strlen(title) == 0
    return -1
  endif
  let dnum = s:GetDictNumFromTitle(b:group, title)
  if dnum < 0
    return -1
  endif
  let refid = get(b:refs, line('.') - 1, '')
  if strlen(refid) == 0
    return -1
  endif

  if s:GoWindow(0) < 0
    return -1
  endif

  setlocal modifiable
  silent %d _
  let b:dictnum = dnum
  let dictlist = s:GetDictList(b:group)
  let dict = dictlist[b:dictnum]
  execute 'redir! >' . s:cmdfile
  if exists("dict.book")
    silent echo 'book ' . s:MakeBookArgument(dict)
  endif
  silent echo 'select ' . dict.name
  silent echo 'content ' . refid . "\n"
  redir END
  call s:ExecuteEblook()

  silent! :g/eblook> /s///g
  if search('<gaiji=', 'nw') != 0
    call s:ReplaceGaiji(dict)
  endif
  silent! :g/^$/d _
  call s:FormatCaption()
  if exists('dict.autoformat')
    if dict.autoformat
      call s:FormatContent()
    endif
  elseif g:eblook_autoformat_default
    call s:FormatContent()
  endif
  setlocal nomodifiable
  normal! 1G
  call s:GoWindow(1)
  return 0
endfunction

" <gaiji=xxxxx>��u��������B
function! s:ReplaceGaiji(dict)
  let gaijimap = s:GetGaijiMap(a:dict)
  silent! :g/<gaiji=\([^>]*\)>/s//\=s:GetGaiji(gaijimap, submatch(1))/g
endfunction

" �O���u���\���擾����
" @param dict ����
" @return �O���u���\
function! s:GetGaijiMap(dict)
  if !exists("a:dict.gaijimap")
    try
      let a:dict.gaijimap = s:LoadGaijiMapFile(a:dict)
    catch /load-error/
      " �E�B���h�E����ċ󂫂�����čēx���������������ɊO���擾�ł���悤��
      return {}
    endtry
  endif
  return a:dict.gaijimap
endfunction

" EBWin�`���̊O����`�t�@�C����ǂݍ���
" http://hishida.s271.xrea.com/manual/EBPocket/0_0_4_4.html
" @param dict ����
" @return �ǂݍ��񂾊O���u���\�B{'ha121':[unicode, ascii], ...}
function! s:LoadGaijiMapFile(dict)
  let name = a:dict.name
  let dir = matchstr(a:dict.book, '"\zs[^"]\+\ze"\|\S\+')
  " "{dir}/{NAME}_{encoding}.map"���������"{dir}/{NAME}.map"��cp932�œǂݍ���
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
  " ���݂̃E�B���h�E(entry/content)�̍���������Ȃ��ꍇ�A
  " OpenWindow()�ɂ��A�����ɗ]�T�̂���E�B���h�E���sview����\��������̂�
  " close������Ō��̃E�B���h�E�ɖ����I�ɐ؂�ւ���K�v����
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
    " ��: hA121	u00E0	a	# comment
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
  close!
  execute bufwinnr(curbuf) . 'wincmd w'
  return gaijimap
endfunction

" �O���u����������擾����B
" @param gaijimap �O���u���\
" @param key �O���L�[
" @return �u��������
function! s:GetGaiji(gaijimap, key)
  " XXX:GetGaiji()������GetGaijiMap()���Ăт������A
  " substitute()��\=���ċA�I�ɌĂ΂��`�ɂȂ��Ă��܂����ߓ��삹��
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

" content�o�b�t�@����<img>����caption�𐮌`����
function! s:FormatCaption()
  " caption����̏ꍇ�͕⊮:
  " eblook 1.6.1+media�Łw�����w���T��T�Łx��\�������ꍇ�A
  " ����������caption�����<inline>���o���B��\���ɂ����
  " ���͂��Ȃ���Ȃ��Ȃ�B(+media������eblook�̏ꍇ��<img>�ŏo��)
  silent! :g;\(<reference>\)\(</reference=[^>]*>\);s;;\1�Q��\2;g
  silent! :g;<img=[^>]*>\zs\_.\{-}\ze</img=[^>]*>;s;;\=s:MakeCaptionString(submatch(0), 'img');g
  silent! :g;<inline=[^>]*>\zs\_.\{-}\ze</inline=[^>]*>;s;;\=s:MakeCaptionString(submatch(0), 'inline');g
  silent! :g;<snd=[^>]*>\zs\_.\{-}\ze</snd>;s;;\=s:MakeCaptionString(submatch(0), 'snd');g
  silent! :g;<mov=[^>]*>\zs\_.\{-}\ze</mov>;s;;\=s:MakeCaptionString(submatch(0), 'mov');g
endfunction

" <img>����caption���q�r���ł�����B
" <img>���̃^�O��conceal�ɂ���̂ŉ摜�Ȃ̂�����/����Ȃ̂������ʂł���悤�ɁB
" (|:syn-cchar|�ł͖ڗ��������ċC�ɂȂ�)
" @param caption caption������B�󕶎���̉\������
" @param type caption�̎��:'inline','img','snd','mov'
" @return ���`��̕�����
function! s:MakeCaptionString(caption, type)
  let len = strlen(a:caption)
  if a:type ==# 'img' || a:type ==# 'inline'
    return '�q' . (len ? a:caption : '�摜') . '�r'
  elseif a:type ==# 'snd'
    return '�s' . (len ? a:caption : '����') . '�t'
  elseif a:type ==# 'mov'
    return '�s' . (len ? a:caption : '����') . '�t'
  else
    return a:caption
  endif
endfunction

" entry�o�b�t�@�ォ��content�o�b�t�@�𐮌`����
function! s:GetAndFormatContent()
  if s:GetContent() < 0
    return -1
  endif
  call s:GoWindow(0)
  call s:FormatContent()
  call s:GoWindow(1)
endfunction

" content�o�b�t�@�𐮌`����
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
  " �����s�𕪊�����
  normal! 1G$
  while 1
    if virtcol('.') > tw
      call s:FormatLine(tw, 0)
    endif
    if line('.') == line('$')
      break
    endif
    normal! j$
  endwhile
  setlocal nomodifiable
  normal! 1G
endfunction

" �����s�𕪊�����B
" @param width �����
" @param joined ���O�ɍs�������������ǂ���
function! s:FormatLine(width, joined)
  let first = line('.')
  normal! gqq
  let last = line('.')
  if last == first
    return
  endif
  call cursor(first, 1)
  " <reference>���s���܂������ꍇ�ɂ͖��Ή��̂��߁A1�s�Ɏ��߂�:
  " <reference>���O�ɉ��s�����Ď��̍s�ƌ���������A�ēx�����������B
  let openrefline = search('<reference>[^<]*$', 'cW', last)
  if openrefline > 0
    let c = virtcol('.')
    if c > 1
      execute "normal! i\<CR>\<Esc>"
    endif
    let n = last - openrefline + 1
    execute "normal! " . n . "J$"
    " �s������A�ċA�Ăяo������ĂāA<reference>���s��������ȏ�ċA���Ă�����
    if a:joined && c == 1
      return
    endif
    if virtcol('.') > a:width
      call s:FormatLine(a:width, 1)
    endif
  endif
endfunction

" content�o�b�t�@���̃J�[�\���ʒu�t�߂�<reference>�𒊏o���āA
" ���̓��e��\������B
function! s:SelectReference()
  let str = getline('.')
  let refid = matchstr(str, s:refpat)
  let m1 = matchend(str, s:refpat)
  if m1 < 0
    return
  endif
  " <reference>��1�s��2�ȏ゠��ꍇ�́A�J�[�\�����ʒu��������g��
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

" entry�o�b�t�@�ŃJ�[�\���s�̃G���g���Ɋ܂܂��<reference>�̃��X�g��\��
function! s:ListReferences()
  if s:GetContent() < 0
    return -1
  endif
  call s:FollowReference('')
endfunction

" <reference>�����X�g�A�b�v����entry�o�b�t�@�ɕ\�����A
" �w�肳�ꂽ<reference>�̓��e��content�o�b�t�@�ɕ\������B
" @param refid �\��������e������������B''�̏ꍇ�̓��X�g�̍ŏ��̂��̂�\��
function! s:FollowReference(refid)
  if s:GoWindow(0) < 0
    return
  endif
  let dnum = b:dictnum
  let save_line = line('.')
  let save_col = virtcol('.')
  " gg�Ńo�b�t�@�擪�Ɉړ����Ă���search()�Ō�������ƁA
  " �o�b�t�@�`���̌����Ώە�����Ƀq�b�g���Ȃ��̂ŁA��������wrap around���Č���
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

  if s:NewBuffers(b:group) < 0
    return -1
  endif
  let dictlist = s:GetDictList(b:group)
  let title = dictlist[dnum].title
  let j = 0
  while j < len(label)
    execute 'normal! o' . title . "\<C-V>\<Tab>" . label[j] . "\<Esc>"
    let j = j + 1
  endwhile
  let b:refs = entry
  silent! :g/^$/d _
  setlocal nomodifiable

  normal! gg
  if strlen(a:refid) > 0
    let idx = index(b:refs, a:refid)
    if idx >= 0
      execute 'normal! ' . (idx + 1) . 'G/\t' . "\<CR>"
    endif
  endif
  call s:GetContent()
endfunction

" �o�b�t�@�̃q�X�g�������ǂ�B
" @param dir -1:�Â�������, 1:�V����������
function! s:History(dir)
  if a:dir > 0
    let ni = s:NextBufIndex()
    if !bufexists(s:entrybufname . ni) || !bufexists(s:contentbufname . ni)
      echomsg 'eblook-vim: ���̃o�b�t�@�͂���܂���'
      return
    endif
  else
    let ni = s:PrevBufIndex()
    if !bufexists(s:entrybufname . ni) || !bufexists(s:contentbufname . ni)
      echomsg 'eblook-vim: �O�̃o�b�t�@�͂���܂���'
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

" ���̃o�b�t�@�̃C���f�b�N�X�ԍ���Ԃ�
" @return ���̃o�b�t�@�̃C���f�b�N�X�ԍ�
function! s:NextBufIndex()
  let i = s:bufindex + 1
  if i > g:eblook_history_max
    let i = 1
  endif
  return i
endfunction

" �O�̃o�b�t�@�̃C���f�b�N�X�ԍ���Ԃ�
" @return �O�̃o�b�t�@�̃C���f�b�N�X�ԍ�
function! s:PrevBufIndex()
  let i = s:bufindex - 1
  if i < 1
    let i = g:eblook_history_max
  endif
  return i
endfunction

" entry�E�B���h�E��content�E�B���h�E���B��
function! s:Quit()
  if s:SelectWindowByName(s:contentbufname . s:bufindex) >= 0
    hide
  endif
  if s:SelectWindowByName(s:entrybufname . s:bufindex) >= 0
    hide
  endif
endfunction

" entry�E�B���h�E����content�E�B���h�E���X�N���[������B
" @param down 1�̏ꍇ���ɁA0�̏ꍇ��ɁB
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

" entry�E�B���h�E/content�E�B���h�E�Ɉړ�����
" @param to_entry_buf 1:entry�E�B���h�E�Ɉړ�, 0:content�E�B���h�E�Ɉړ�
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

" title�����񂩂玫���ԍ���Ԃ�
" @param title ������title������
" @return �����ԍ�
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

" �����ꗗ��\������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
function! s:ListDict(group)
  let gr = s:ExpandDefaultGroup(a:group)
  let dictlist = s:GetDictList(gr)
  echo '�����O���[�v: ' . gr
  " EblookSkipDict���ł͎����ԍ����w�肷��̂ŁA�����ԍ��t���ŕ\������
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

" �������X�L�b�v���邩�ǂ������ꎞ�I�ɐݒ肷��B
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param is_skip �X�L�b�v���邩�ǂ����B1:�X�L�b�v����, 0:�X�L�b�v���Ȃ�
" @param ... �����ԍ��̃��X�g
function! s:SetDictSkip(group, is_skip, ...)
  let dictlist = s:GetDictList(a:group)
  for dnum in a:000
    let dictlist[dnum].skip = a:is_skip
  endfor
endfunction

" �����O���[�v�̈ꗗ��\������
" @param {Number} max �`�F�b�N���鎫���O���[�v�ԍ��̍ő�l
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

" count���w�肳��Ă��Ȃ����Ɍ����Ώۂɂ��鎫���O���[�v�ԍ���ݒ肷��
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
function! s:SetDefaultGroup(group)
  if a:group == 0
    echomsg 'eblook-vim: g:eblook_group=' . g:eblook_group
  else
    let g:eblook_group = a:group
  endif
endfunction

" group�ԍ���0(���w��)�ł���΁Ag:eblook_group�̒l��Ԃ��B
" (count���w�肹���ɑ��삵�����ɁA�ǂ̎����O���[�v���g��ꂽ�����A
" ���[�U�ɂ킩��悤�ɂ��邽��)
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

" �V�����E�B���h�E���J��
function! s:OpenWindow(cmd)
  if winheight(0) > 2
    silent execute a:cmd
    return winnr()
  else
    " 'noequalalways'�̏ꍇ�A���������肸��split��E36�G���[�ɂȂ�ꍇ����̂ŁA
    " ��ԍ����̂���window�ōēxsplit�����݂�
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
      echomsg 'eblook-vim: ��ʏ�̋󂫂�����Ȃ����ߐV�K�E�B���h�E���J���̂Ɏ��s���܂����B�E�B���h�E����ċ󂫂�����Ă�������(:' . a:cmd . ')'
      return -1
    endif
  endif
endfunction

" ��̃o�b�t�@�����
function! s:Empty_BufReadCmd()
endfunction

" eblook-vim-1.1.0����̎����w��`�����y�[�X�g����B
" eblook-vim-1.0.5����̌`���ϊ��p�B
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
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
