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
"   o                   content�E�B���h�E���ő剻����
"
" content�o�b�t�@��nmap
"   <CR>                �J�[�\���ʒu��reference��\������
"   <Space>             PageDown���s��
"   <BS>                PageUp���s��
"   <Tab>               ����reference�ɃJ�[�\�����ړ�����
"   <S-Tab>             �O��reference�ɃJ�[�\�����ړ�����
"   q                   entry�E�B���h�E��content�E�B���h�E�����
"   s                   �V�����P�����͂��Č�������(<Leader><C-Y>�Ɠ���)
"   S                   ���O�̌������[count]�Ŏw�肷�鎫���O���[�v�ōČ�������
"   p                   entry�E�B���h�E�Ɉړ�����
"   R                   reference�ꗗ��\������
"   <C-P>               �������𒆂̈�O�̃o�b�t�@��\������
"   <C-N>               �������𒆂̈���̃o�b�t�@��\������
"   O                   content�E�B���h�E���̒����s��|gq|�Ő��`����
"   o                   content�E�B���h�E���ő剻����
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
"    'eblook_stemming'
"       �w�蕶����ŉ���������Ȃ��������ɁA���p����Ȃǂ���菜����
"       ��������g���Č������������ǂ����B�ȗ��l: 0
"
"    'eblook_decorate'
"       eblook 1.6.1+media��decorate-mode��L���ɂ���Əo�͂����A
"       content���̃C���f���g�w��Ɋ�Â��āA�C���f���g���s�����ǂ����B
"       �ȗ��l: 1(eblook 1.6.1+media�̏ꍇ), 0(����ȊO�̏ꍇ)
"
"    'eblook_decorate_indmin'
"       ���̒l���z�����C���f���g�ʂ�content���Ŏw�肳�ꂽ�ꍇ�ɁA
"       �z�������������̃C���f���g���s���B�ȗ��l: 1
"
"    'eblook_entrywin_height'
"       entry�E�B���h�E�̍s��(�ڈ�)�B�ȗ��l: 4
"
"    'eblook_history_max'
"       �ێ����Ă����ߋ��̌��������o�b�t�@���̏���B�ȗ��l: 10
"
"    'eblook_visited_max'
"       �\���ύX�p�ɕێ����Ă����K��σ����N���̏���B�ȗ��l: 100
"
"    'eblook_autoformat_default'
"       content�E�B���h�E���̒����s��|gq|�Ő��`���邩�ǂ����̃f�t�H���g�l�B
"       �S��������ɐ��`�������ꍇ����(�S�����ɂ���'autoformat'�v���p�e�B
"       ���w�肷��͖̂ʓ|�Ȃ̂�)�B�ȗ��l: 0
"
"    'eblook_show_refindex'
"       content�E�B���h�E����reference�ԍ���conceal syntax���g���Ĕ�\����
"       ���邩�ǂ����B�ȗ��l: 0
"
"    'eblook_statusline_entry'
"       entry�E�B���h�E�p��statusline�B
"       �ȗ��l: %{b:group}Eblook entry {%{b:word}}%< [%L]
"
"    'eblook_statusline_content'
"       content�E�B���h�E�p��statusline�B
"       �ȗ��l: %{b:group}Eblook content {%{b:caption}} %{b:dtitle}%<
"
"    'eblook_viewers'
"       �摜�≹���Đ��p�̊O���r���[�A�R�}���h�B
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

" �\���ύX�p�ɕێ����Ă����K��σ����N���̏��
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

" eblook�v���O�����̖��O
if !exists('eblookprg')
  let eblookprg = 'eblook'
endif

if !exists('eblook_viewers')
  if has('win32') || has('win64')
    " ��1������""���w�肵�Ȃ��ƃR�}���h�v�����v�g���J������
    let eblook_viewers = {
      \'jpeg': ' start ""',
      \'bmp': ' start ""',
      \'pbm': ' start ""',
      \'wav': ' start ""',
      \'mpg': ' start ""',
    \}
  else
    " XXX: mailcap��ǂݍ���Őݒ肷��?
    let eblook_viewers = {
      \'jpeg': 'xdg-open %s &',
      \'bmp': 'xdg-open %s &',
      \'pbm': 'xdg-open %s &',
      \'wav': 'xdg-open %s &',
      \'mpg': 'xdg-open %s &',
    \}
  endif
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
let s:lastword = ''
" �\����reference�A�h���X���X�g(�K��σ����N�̕\���ύX�p)
let s:visited = []
" stemming��̌���������B�ŏ��̗v�f��stemming�O�̕�����
let s:stemmedwords = []
" stemmedwords���̌�����index
let s:stemindex = -1

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

" content�o�b�t�@�ɓ��������Ɏ��s�Bset nobuflisted����B
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

" �v�����v�g���o���āA���[�U������͂��ꂽ���������������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {Number} defgroup �Ώۂ̎����O���[�v�ԍ�(�f�t�H���g)
" @param {Boolean} uselastword ���O�̌�����������f�t�H���g������Ƃ��ē���邩
"   (<Leader>y�Ŏ擾�E����������������ꕔ�ύX���čČ����ł���悤�ɁB
"   input()�̃v�����v�g��|c_CTRL-R_=|�̌�s:lastword�Ɠ��͂��邱�ƂŎ����\)
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

" (entry/content�E�B���h�E����)���O�̌���������𑼂̎����O���[�v�ōČ�������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {Number} defgroup ���݂̎����O���[�v�ԍ�
function! s:SearchOtherGroup(group, defgroup)
  let gr = s:ExpandDefaultGroup(a:group)
  if gr == a:defgroup
    return
  endif
  call s:Search(gr, s:lastword, 0)
endfunction

" Visual mode�őI������Ă��镶�������������
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
function! s:SearchVisual(group)
  let save_reg = @@
  silent execute 'normal! `<' . visualmode() . '`>y'
  call s:Search(a:group, substitute(@@, '\n', '', 'g'), 0)
  let @@ = save_reg
endfunction

" �w�肳�ꂽ�P��̌������s���B
" entry�o�b�t�@�Ɍ������ʂ̃��X�g��\�����A
" ���̂����擪��entry�̓��e��content�o�b�t�@�ɕ\������B
" @param {Number} group �Ώۂ̎����O���[�v�ԍ�
" @param {String} word ��������P��
" @param {Boolean} isstem stemming�����P��̌��������ǂ���
function! s:Search(group, word, isstem)
  if strlen(a:word) == 0
    echomsg 'eblook-vim: �����ꂪ�󕶎���Ȃ̂ŁA�����𒆎~���܂�'
    return -1
  endif
  let s:lastword = a:word
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
  if s:RedirSearchCommand(dictlist, a:word) < 0
    return -1
  endif
  if s:NewBuffers(gr) < 0
    return -1
  endif
  let b:word = a:word
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
	  call insert(s:stemmedwords, a:word) " ���̒P���擪�ɓ���Ă���
	  let s:stemindex = 1
	  call s:Search(gr, s:stemmedwords[s:stemindex], 1)
	  return
	endif
      endif
      "redraw | echomsg 'eblook-vim(' . gr . '): ����������܂���ł���: <' . word . '>'
      let str = input(':' . gr . 'EblookSearch(����������܂���ł���) ', word)
      if strlen(str) == 0 || str ==# word
	return
      endif
      call s:Search(gr, str, 0)
    endif
  endif
endfunction

" stemming/����␳������╶�����List���擾����
" @param {String} word �Ώە�����
" @return ��╶�����List
function! s:Stem(word)
  if a:word =~ '[^ -~]'
    return eblook#stem_ja#Stem(a:word)
    " XXX: ebview�Ɠ��l�ɁA���������݂̂�ǉ�����
  else
    return eblook#stem_en#Stem(a:word)
  endif
endfunction

" eblook�v���O�����Ƀ��_�C���N�g���邽�߂̌����R�}���h�t�@�C�����쐬����
" @param dictlist �Ώۂ̎����O���[�v
" @param {String} word ��������P��
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

" eblook 1.6.1+media�ł��ǂ����𒲂ׂ�
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
  let b:group = a:group
  let b:word = ''
  if s:CreateBuffer(s:contentbufname, oldindex) < 0
    call s:Quit()
    let s:bufindex = oldindex
    return -1
  endif
  let b:group = a:group
  " eblook���ŃG���[���������āA���ʂ�������Ԃ�statusline��\�����悤�Ƃ���
  " Undefined variable: b:caption�G���[����������̂����
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

" entry�o�b�t�@�̎w��s�ɑΉ�������e��content�o�b�t�@�ɕ\������
" @param count �Ώۂ̍s�ԍ��B0�̏ꍇ�͌��ݍs
" @return -1:content�\�����s, 0:�\������
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

" content���擾����content�o�b�t�@�ɕ\������
" @param doformat ���`���邩�ǂ���
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
  "return 0 " DEBUG: ���`�O�̓��e���m�F����

  silent! :g/eblook> /s///g
  if search('<gaiji=', 'nw') != 0
    call s:ReplaceGaiji(dict)
  endif
  if g:eblook_decorate
    " ���Ή��̃^�O�͍폜
    silent! :g/<\/\?no-newline>/s///g
    call s:ReplaceTag() " <sup>,<sub>
    " TODO: <em>,<font=bold>,<font=italic>��syntax�Ή�
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

" ��t������(<sup>�P</sup>)�A���t������<sub>��u��������
function! s:ReplaceTag()
  silent! :g/<sup>\([^<]*\)<\/sup>/s//\=s:GetReplaceTagStr('sup', submatch(1))/g
  silent! :g/<sub>\([^<]*\)<\/sub>/s//\=s:GetReplaceTagStr('sub', submatch(1))/g
endfunction

" �^�O�̒u����������擾����B
" @param tag �^�O�B'sup'��'sub'
" @param str ���̕�����
" @return �u��������
function! s:GetReplaceTagStr(tag, str)
  if &encoding != 'utf-8'
    return a:str
  else
    return get(g:eblook#supsubmap_utf8#{a:tag}map, a:str, a:str)
  endif
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
  bwipeout!
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

" content�o�b�t�@����<reference>����Z�k�`���ɒu������
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
  " /��history��<reference>\(.\{-}\)</reference=\(\x\+:\x\+\)>���o�Ȃ��悤��
  call histdel('/', -1)
endfunction

" <img>����caption���q�r���ł�����B
" <img>���̃^�O��conceal�ɂ���̂ŉ摜�Ȃ̂�����/����Ȃ̂������ʂł���悤�ɁB
" @param caption caption������B�󕶎���̉\������
" @param tag caption�̎��:'inline','img','snd','mov'
" @return ���`��̕�����
function! s:MakeCaptionString(caption, tag, ftype, addr)
  let len = strlen(a:caption)
  " caption����̏ꍇ�͕⊮:
  " eblook 1.6.1+media�Łw�����w���T��T�Łx��\�������ꍇ�A
  " ����������caption�����<inline>���o���B��\���ɂ����
  " ���͂��Ȃ���Ȃ��Ȃ�B(+media������eblook�̏ꍇ��<img>�ŏo��)
  if a:tag ==# 'img' || a:tag ==# 'inline'
    let markbeg = '�q'
    let capstr = (len ? a:caption : '�摜')
    let markend = '�r'
  elseif a:tag ==# 'snd'
    let markbeg = '�s'
    let capstr = (len ? a:caption : '����')
    let markend = '�t'
  elseif a:tag ==# 'mov'
    let markbeg = '�s'
    let capstr = (len ? a:caption : '����')
    let markend = '�t'
  else
    return a:cation
  endif
  call add(b:contentrefsm, [a:ftype, a:addr, capstr])
  return '<' . len(b:contentrefsm) . markbeg . capstr . markend . '>'
endfunction

" '<reference>caption</reference=xxxx:xxxx>'��
" '<1|caption|>'�����ɂ����������Ԃ��B
" conceal���Ă��\������Ȃ������ŁA���`���ɂ̓J�E���g����Ă���̂ŁA
" <reference></reference=xxxx:xxxx>���ƒ������āA
" �s�̐܂�Ԃ������Ȃ葁�߂ɂ���Ă���悤�Ɍ�����̂ŁB
" @param caption caption������B�󕶎���̉\������
" @param addr reference��A�h���X������
" @return �ϊ���̕�����
function! s:MakeReferenceString(caption, addr)
  let len = strlen(a:caption)
  let capstr = len ? a:caption : '�Q��'
  call add(b:contentrefs, [a:addr, capstr])
  return '<' . len(b:contentrefs) . s:Visited(b:dtitle, a:addr) . capstr . '|>'
endfunction

" �K��σ����N���ǂ������ׂāA'!'��'|'��Ԃ�
function! s:Visited(title, addr)
  if match(s:visited, a:title . "\t" . a:addr) >= 0
    return '!'
  else
    return '|'
  endif
endfunction

" entry�o�b�t�@�̎Q�Ɛ敶����̒u���p�֐�
function! s:MakeEntryReferenceString(title, addr, caption)
  call add(b:refs, [a:addr, a:caption])
  return a:title . "\t<" . len(b:refs) . s:Visited(a:title, a:addr) . a:caption . '|>'
endfunction

" entry�o�b�t�@�ォ��content�o�b�t�@�𐮌`����
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

" <ind=[1-9]>�Ŏw�肳���indent�ʂ��g�p���Č��ݍs��indnet
" @param indcur ���݂�indent��
function! s:FormatHeadIndent(indcur)
  let ind = a:indcur
  let indnew = matchstr(getline('.'), '^<ind=\zs[0-9]\ze>')
  " �s����<ind=>������ꍇ�́Aindent�ʂ��X�V
  while indnew != ''
    let ind = indnew
    s/^<ind=[0-9]>//
    " ^<ind=1><ind=3>�̂悤�ȏꍇ������̂Ń��[�v���ă`�F�b�N
    let indnew = matchstr(getline('.'), '^<ind=\zs[0-9]\ze>')
  endwhile
  if ind > g:eblook_decorate_indmin
    s/^/\=printf('%*s', ind - g:eblook_decorate_indmin, '')/
  endif
  return ind
endfunction

" content�o�b�t�@����<ind=[1-9]>�𐮌`����
function! s:FormatIndent()
  silent! :g/^<\%(next\|prev\)>/s/^/<ind=0>/
  let ind = 0
  let lnum = 1
  let lastline = line('$')
  while lnum <= lastline
    call cursor(lnum, 1)
    let ind = s:FormatHeadIndent(ind)

    " �s�̓r����<ind=>������ꍇ�́A���s�ȍ~��indent�ʂ��X�V
    let indnew = matchstr(getline('.'), '<ind=\zs[0-9]\ze>')
    while indnew != ''
      s/<ind=[0-9]>//
      let ind = indnew
      let indnew = matchstr(getline('.'), '<ind=\zs[0-9]\ze>')
    endwhile
    let lnum = lnum + 1
  endwhile
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
  if g:eblook_decorate
    silent! :g/^<\%(next\|prev\)>/s/^/<ind=0>/
  endif
  let ind = 0
  normal! 1G$
  while 1
    if g:eblook_decorate
      let ind = s:FormatHeadIndent(ind)

      " �s�̓r���ɂ���<ind=>���l�����Ē����s�𕪊�����
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
	  " <ind=[0-9]>���������A�Đ��`�̂��ߍs����
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

" �����s�𕪊�����B
" @param width �����
" @param joined ���O�ɍs�������������ǂ���
" @param ind �C���f���g��
" @return ������̕����s�̂����̍ŏI�s�̍s�ԍ�(line('.')�Ɠ���)
function! s:FormatLine(width, joined, ind)
  let first = line('.')
  let indprev = matchstr(getline('.'), '^ *')
  normal! gqq
  let last = line('.')
  if last == first
    return last
  endif
  " gqq���t����indent�͍폜�B<ind=[1-9]>�����Ƃ�indent��t����̂ŁA�]���B
  if g:eblook_decorate && indprev != ""
    silent! execute (first + 1) . ',' . last . 's/^' . indprev . '//'
  endif
  call cursor(first, 1)
  " <reference>�u�����<1|...|>���s���܂������ꍇ�ɂ͖��Ή��̂��߁A1�s�Ɏ��߂�:
  " <1|���O�ɉ��s�����Ď��̍s�ƌ���������A�ēx�����������B
  let openrefline = search('<\d\+[|!][^>]*$', 'cW', last)
  if openrefline > 0
    let c = virtcol('.')
    if c > 1
      execute "normal! i\<CR>\<Esc>"
    endif
    let n = last - openrefline + 1
    execute "normal! " . n . "J$"
    " �s������A�ċA�Ăяo������ĂāA<1|���s��������ȏ�ċA���Ă�����
    if a:joined && c == 1
      return line('.')
    endif
    if virtcol('.') > a:width
      call s:FormatLine(a:width, 1, a:ind)
    endif
  endif
endfunction

" content�o�b�t�@���̃J�[�\���ʒu�t�߂�reference�𒊏o���āA
" ���̓��e��\������B
" @param count [count]�Ŏw�肳�ꂽ�A�\���Ώۂ�reference��index�ԍ�
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

" content�o�b�t�@���̃J�[�\���ʒu�t�߂�refpat�𒊏o���āA
" refpat�Ɋ܂܂��index�ԍ���Ԃ��B
function! s:GetIndexHere(refpat, lnum)
  let str = getline(a:lnum)
  let index = matchstr(str, a:refpat)
  let m1 = matchend(str, a:refpat)
  if m1 < 0
    return ''
  endif
  " reference��1�s��2�ȏ゠��ꍇ�́A�J�[�\�����ʒu��������g��
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

" entry�o�b�t�@�ŃJ�[�\���s�̃G���g���Ɋ܂܂��reference�̃��X�g��\��
" @param count [count]�Ŏw�肳�ꂽ�A�\���Ώۂ�reference��index�ԍ�
function! s:ListReferences(count)
  if s:GetContent(0) < 0
    return -1
  endif
  call s:FollowReference(a:count)
endfunction

" reference�����X�g�A�b�v����entry�o�b�t�@�ɕ\�����A
" �w�肳�ꂽreference�̓��e��content�o�b�t�@�ɕ\������B
" @param count [count]�Ŏw�肳�ꂽ�A�\���Ώۂ�reference��index�ԍ�
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

" content�o�b�t�@���̃J�[�\���ʒu�t�߂�img���𒊏o���āA
" ���̓��e���O���v���O�����ŕ\������B
" @param count [count]�Ŏw�肳�ꂽ�A�\���Ώۂ�index�ԍ�
function! s:ShowMedia(count)
  if a:count > 0
    let index = a:count
    if a:count > len(b:contentrefsm)
      let index = len(b:contentrefsm)
    endif
  else
    let index = s:GetIndexHere('<\zs\d\+\ze[�q�s]', '.')
    if strlen(index) == 0
      " �摜�⓮��̏ꍇ�Acaption�������s�ɂ킽��ꍇ������A
      " 2�s�ڈȍ~�ő��삵���ꍇ�ł��\���ł���悤�ɂ���
      let lnum = search('<\d\+[�q�s]', 'bnW')
      if lnum == 0
	return
      endif
      let index = s:GetIndexHere('<\zs\d\+\ze[�q�s]', lnum)
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
  " mspaint�̓p�X��؂肪\�łȂ��Ƒʖ�
  let tmpfshell = tempname() . '.' . tmpext
  " eblook���ł̓p�X��؂��\�ł͑ʖ�
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
    echomsg tmpext . '�t�@�C�����o���s: ' . (v:shell_error ? res : ngmsg)
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
    echomsg tmpext . '�p�r���[�A��g:eblook_viewers�ɐݒ肳��Ă��܂���'
    return
  endif
  if match(viewer, '%s') >= 0
    let cmdline = substitute(viewer, '%s', shellescape(tmpfshell), '')
  else
    let cmdline = viewer . ' ' . shellescape(tmpfshell)
  endif
  " hit-enter prompt���o��Ɩʓ|�Ȃ̂�silent
  execute 'silent !' . cmdline
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

" entry�E�B���h�E�ォ��Acontent�E�B���h�E�̍������ő剻����
function! s:MaximizeContentHeight()
  if s:GoWindow(0) < 0
    return
  endif
  wincmd _
  call s:GoWindow(1)
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
