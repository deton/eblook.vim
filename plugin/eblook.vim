" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Last Change: 2012-02-09

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
"   :EblookSearch       �w�肵���P��̌������s��
"   :EblookListDict     �����̈ꗗ��\������
"   :EblookSkipDict     �w�肵�������ԍ��̎������ꎞ�I�Ɍ����Ώۂ���O��
"   :EblookNotSkipDict  �w�肵�������ԍ��̎������ꎞ�I�Ɍ����Ώۂɓ����
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
"   p                   content�E�B���h�E�Ɉړ�����
"   R                   reference�ꗗ��\������
"   <C-P>               �������𒆂̈�O�̃o�b�t�@��\������
"   <C-N>               �������𒆂̈���̃o�b�t�@��\������
"
" content�o�b�t�@��nmap
"   <CR>                �J�[�\���ʒu��reference��\������
"   <Space>             PageDown���s��
"   <BS>                PageUp���s��
"   <Tab>               ����reference�ɃJ�[�\�����ړ�����
"   q                   entry�E�B���h�E��content�E�B���h�E�����
"   s                   �V�����P�����͂��Č�������(<Leader><C-Y>�Ɠ���)
"   p                   entry�E�B���h�E�Ɉړ�����
"   R                   reference�ꗗ��\������
"   <C-P>               �������𒆂̈�O�̃o�b�t�@��\������
"   <C-N>               �������𒆂̈���̃o�b�t�@��\������
"
" �I�v�V����:
"    'eblook_dictlist'
"      EPWING������|List|�BList�̊e�v�f�͈ȉ���key������|Dictionary|�B
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
"         Appendix������ꍇ�́A
"         �����f�B���N�g���ɑ�����Appendix�f�B���N�g�����w��B
"
"      'name'
"         eblook�v���O������`select'�R�}���h�ɓn���p�����[�^�B
"         ���������w��Beblook�v���O������list�R�}���h�Œ��ׂ�B
"
"      'skip'
"         0�łȂ��l��ݒ肷��ƁA���̎����͌������Ȃ��B
"         ('skip'�L�[�����w��̏ꍇ��0�Ƃ݂Ȃ�)
"
"      ��:
"        let eblook_dictlist =
"        \[
"        \  {
"        \    'title': '�L������ܔ�',
"        \    'book': '/usr/local/epwing/tougou99',
"        \    'name': 'kojien',
"        \    'skip': 0
"        \  },
"        \  {
"        \    'title': '�W�[�j�A�X�p�a�厫�T',
"        \    'book': '/usr/local/epwing/GENIUS /usr/local/epwing/appendix/genius2-1.1',
"        \    'name': 'genius'
"        \  }
"        \]
"
"    'eblook_entrywin_height'
"       entry�E�B���h�E�̍s��(�ڈ�)�B�ȗ��l: 4
"
"    'eblook_history_max'
"       �ێ����Ă����ߋ��̌��������o�b�t�@���̏���B�ȗ��l: 10
"
"    'eblookprg'
"       ���̃X�N���v�g����Ăяo��eblook�v���O�����̖��O�B�ȗ��l: eblook
"
"    'eblookenc'
"       eblook�v���O�����̏o�͂�ǂݍ��ނƂ��̃G���R�[�f�B���O�B
"       �ݒ�\�Ȓl��|'encoding'|�Q�ƁB�ȗ��l: &encoding
"
"    'mapleader'
"       �L�[�}�b�s���O�̃v���t�B�b�N�X�B|mapleader|���Q�ƁB�ȗ��l: CTRL-K
"       CTRL-K���w�肷��ꍇ�̗�:
"         let mapleader = "\<C-K>"
"
"    'plugin_eblook_disable'
"       ���̃v���O�C����ǂݍ��݂����Ȃ��ꍇ�Ɏ��̂悤�ɐݒ肷��B
"         let plugin_eblook_disable = 1

if exists('plugin_eblook_disable')
  finish
endif

" entry�E�B���h�E�̍s��
if !exists('eblook_entrywin_height')
  let eblook_entrywin_height = 4
endif

" �ێ����Ă����ߋ��̌����o�b�t�@���̏��
if !exists('eblook_history_max')
  let eblook_history_max = 10
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

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)
command! EblookListDict call <SID>ListDict()
command! -nargs=* EblookSkipDict call <SID>SetDictSkip(1, <f-args>)
command! -nargs=* EblookNotSkipDict call <SID>SetDictSkip(0, <f-args>)

" </reference=>�Ŏw�肳���entry��pattern
let s:refpat = '[[:xdigit:]]\+:[[:xdigit:]]\+'
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

" �}�b�s���O
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
  " ������title���ݒ肳��Ă��Ȃ�������A�����ԍ���name��ݒ肵�Ă���
  if !exists('dict.title')
    let dict.title = s:i . dict.name
  endif
  " ���O��book�p�Ɏw�肵��appendix�������p����Ȃ��悤��appendix�͕K���t����
  " (XXX: eblook 1.6.1+media�łł͑Ώ�����Ă���̂ŕs�v)
  if dict.book !~ '^"[^"]\+"\s\+\S\+\|^[^"]\+\s\+\S\+'
    let dict.book = dict.book . ' ' . dict.book
  endif
  let s:i = s:i + 1
endwhile
unlet s:i

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
  nnoremap <buffer> <silent> p :call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :call <SID>ListReferences()<CR>
  nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>
  execute 'nnoremap <buffer> <silent> <Tab> /' . s:refpat . '<CR>'
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
  nnoremap <buffer> <silent> p :call <SID>GoWindow(1)<CR>
  nnoremap <buffer> <silent> q :call <SID>Quit()<CR>
  nnoremap <buffer> <silent> R :call <SID>FollowReference('')<CR>
  nnoremap <buffer> <silent> s :call <SID>SearchInput()<CR>
  nnoremap <buffer> <silent> <C-P> :call <SID>History(-1)<CR>:call <SID>GoWindow(0)<CR>
  nnoremap <buffer> <silent> <C-N> :call <SID>History(1)<CR>:call <SID>GoWindow(0)<CR>
endfunction

" �v�����v�g���o���āA���[�U������͂��ꂽ���������������
function! s:SearchInput()
  let str = input('eblook-vim: ')
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
endfunction

" Visual mode�őI������Ă��镶�������������
function! s:SearchVisual()
  let save_reg = @@
  silent execute 'normal! `<' . visualmode() . '`>y'
  call s:Search(substitute(@@, '\n', '', 'g'))
  let @@ = save_reg
endfunction

" �w�肳�ꂽ�P��̌������s���B
" entry�o�b�t�@�Ɍ������ʂ̃��X�g��\�����A
" ���̂����擪��entry�̓��e��content�o�b�t�@�ɕ\������B
" @param key ��������P��
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
      redraw | echomsg 'eblook-vim: ����������܂���ł���: <' . a:key . '>'
    endif
  endif
endfunction

" eblook�v���O�����Ƀ��_�C���N�g���邽�߂̌����R�}���h�t�@�C�����쐬����
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
function! s:NewBuffers()
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
    execute "silent normal! :edit " . newbufname . "\<CR>"
  endif
  if bufexists
    silent execute "normal! :%d _\<CR>"
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

" <gaiji=xxxxx>��u��������B
function! s:ReplaceGaiji(dnum)
  let gaijimap = s:GetGaijiMap(a:dnum)
  silent! :g/<gaiji=\([^>]*\)>/s//\=s:GetGaiji(gaijimap, submatch(1))/g
endfunction

" �O���u���\���擾����
" @param dnum �����ԍ�
" @return �O���u���\
function! s:GetGaijiMap(dnum)
  if !exists("g:eblook_dictlist[a:dnum].gaijimap")
    try
      let g:eblook_dictlist[a:dnum].gaijimap = s:LoadGaijiMapFile(a:dnum)
    catch /load-error/
      " �E�B���h�E����ċ󂫂�����čēx���������������ɊO���擾�ł���悤��
      return {}
    endtry
  endif
  return g:eblook_dictlist[a:dnum].gaijimap
endfunction

" EBWin�`���̊O����`�t�@�C����ǂݍ���
" http://hishida.s271.xrea.com/manual/EBPocket/0_0_4_4.html
" @param dnum �����ԍ�
" @return �ǂݍ��񂾊O���u���\�B{'ha121':[unicode, ascii], ...}
function! s:LoadGaijiMapFile(dnum)
  let name = g:eblook_dictlist[a:dnum].name
  let dir = matchstr(g:eblook_dictlist[a:dnum].book, '"\zs[^"]\+\ze"\|\S\+')
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
  setlocal nobuflisted
  for line in getline(1, '$')
    if line !~ '^[hzcg][[:xdigit:]]\{4}'
      continue
    endif
    " ��: hA121	u00E0	a	# comment
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
  call s:GetContent()
  call s:FollowReference('')
endfunction

" <reference>�����X�g�A�b�v����entry�o�b�t�@�ɕ\�����A
" �w�肳�ꂽ<reference>�̓��e��content�o�b�t�@�ɕ\������B
" @param refid �\��������e������������B''�̏ꍇ�̓��X�g�̍ŏ��̂��̂�\��
function! s:FollowReference(refid)
  if s:SelectWindowByName(s:contentbufname . s:bufindex) < 0
    if s:OpenWindow('split ' . s:contentbufname . s:bufindex) < 0
      return
    endif
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

" �����ꗗ��\������
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

" �������X�L�b�v���邩�ǂ������ꎞ�I�ɐݒ肷��B
" @param is_skip �X�L�b�v���邩�ǂ����B1:�X�L�b�v����, 0:�X�L�b�v���Ȃ�
" @param ... �����ԍ��̃��X�g
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

" �V�����E�B���h�E���J��
function! s:OpenWindow(cmd)
  if winheight(0) > 2
    execute "silent normal! :" . a:cmd . "\<CR>"
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
      execute "silent normal! :" . a:cmd . "\<CR>"
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
