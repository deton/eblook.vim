" vi:set ts=8 sts=2 sw=2 tw=0:
"
" eblook.vim - lookup EPWING dictionary using `eblook' command.
"
" Maintainer: KIHARA Hideto <deton@m1.interq.or.jp>
" Revision: $Id: eblook.vim,v 1.23 2003/06/12 14:04:05 deton Exp $

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
"    'eblook_dict{n}_title'
"    'eblook_dict{n}_book'
"    'eblook_dict{n}_name'
"    'eblook_dict{n}_skip'
"       EPWING�����̐ݒ�B{n}��1, 2, 3, ...�B�g�������������w�肷��B
"       �����Ŏw�肵������(�����ԍ�)�̏��Ɍ������s���B
"       �����͘A�����Ă���K�v������B
"       eblook_dict{n}_skip�ȊO�͕K�{�B
"
"      'eblook_dict{n}_title'
"         �����̎��ʎq���w��Bentry�E�B���h�E���Ŏ��������ʂ��邽�߂Ɏg���B
"         (eblook.vim�����ł͎����ԍ���title�Ŏ��������ʂ���B)
"         ���������ʂ��邽�߂Ɏg�������Ȃ̂ŁA
"         ���̎����ƂԂ���Ȃ��������K���ɂ���B
"         ��:
"           let eblook_dict1_title = '�L������ܔ�'
"
"      'eblook_dict{n}_book'
"         eblook�v���O������`book'�R�}���h�ɓn���p�����[�^�B
"         �����̂���f�B���N�g��(catalogs�t�@�C���̂���f�B���N�g��)���w��B
"         Appendix������ꍇ�́A
"         �����f�B���N�g���ɑ�����Appendix�f�B���N�g�����w��B
"         ��:
"           let eblook_dict1_book = '/usr/local/epwing'
"
"      'eblook_dict{n}_name'
"         eblook�v���O������`select'�R�}���h�ɓn���p�����[�^�B
"         ���������w��Beblook�v���O������list�R�}���h�Œ��ׂ�B
"         ��:
"           let eblook_dict1_name = 'kojien'
"
"      'eblook_dict{n}_skip'
"         0�łȂ��l��ݒ肷��ƁA���̎����͌������Ȃ��B
"         ��:
"           let eblook_dict1_skip = 1
"
"
"    'eblook_history_max'
"       �ێ����Ă����ߋ��̌��������o�b�t�@���̏���B�ȗ��l: 10
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

" �ێ����Ă����ߋ��̌����o�b�t�@���̏��
if !exists('eblook_history_max')
  let eblook_history_max = 10
endif

command! -nargs=1 EblookSearch call <SID>Search(<q-args>)
command! EblookListDict call <SID>ListDict()
command! -nargs=* EblookSkipDict call <SID>SetDictSkip(1, <f-args>)
command! -nargs=* EblookNotSkipDict call <SID>SetDictSkip(0, <f-args>)

" entry�o�b�t�@���̃x�[�X
let s:entrybufname = '_eblook_entry_'
" content�o�b�t�@���̃x�[�X
let s:contentbufname = '_eblook_content_'
" </reference=>�Ŏw�肳���entry��pattern
let s:refpat = '[[:xdigit:]]\+:[[:xdigit:]]\+'
" eblook�Ƀ��_�C���N�g����R�}���h��ێ�����ꎞ�t�@�C����
let s:cmdfile = tempname()
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
if s:set_mapleader
  unlet g:mapleader
endif
unlet s:set_mapleader

augroup Eblook
autocmd!
execute "autocmd BufReadCmd " . s:entrybufname . "* call <SID>Empty_BufReadCmd()"
execute "autocmd BufReadCmd " . s:contentbufname . "* call <SID>Empty_BufReadCmd()"
augroup END

" ������title���ݒ肳��Ă��Ȃ�������A�����ԍ���name��ݒ肵�Ă���
let s:i = 1
while exists("g:eblook_dict{s:i}_name")
  if !exists("g:eblook_dict{s:i}_title")
    let g:eblook_dict{s:i}_title = s:i . g:eblook_dict{s:i}_name
  endif
  let s:i = s:i + 1
endwhile
unlet s:i

" �v�����v�g���o���āA���[�U������͂��ꂽ���������������
function! s:SearchInput()
  let str = input('eblook: ')
  if strlen(str) == 0
    return
  endif
  call s:Search(str)
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
  " &enc��euc-jp��&fencs��cp932�������Ă���ꍇ�A�������ʂ��Z���ƁAeblook��
  " euc-jp�Ō��ʂ�Ԃ��Ă���̂�cp932�Ƃ݂Ȃ���ĕ����������邱�Ƃ�����̂ŁA
  " �ꎞ�I��&fecns�ɂ�&enc���������eblook�v���O�����̌��ʂ�ǂݍ��ށB
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
      echomsg 'eblook-vim: ����������܂���ł���: <' . a:key . '>'
    endif
  endif
endfunction

" �V�����������s�����߂ɁAentry�o�b�t�@��content�o�b�t�@�����B
function! s:NewBuffers()
  " entry�o�b�t�@��content�o�b�t�@�͈�΂ň����B
  let oldindex = s:bufindex
  let s:bufindex = s:NextBufIndex()
  call s:CreateBuffer(s:entrybufname, oldindex)
  call s:CreateBuffer(s:contentbufname, oldindex)
  execute "normal! \<C-W>p4\<C-W>_"
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

" entry�o�b�t�@�̃J�[�\���s�ɑΉ�������e��content�o�b�t�@�ɕ\������
" @return -1:content�\�����s, 0:�\������
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
      let refid = matchstr(str, refpat, offset)
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
    execute "silent normal! :split " . s:contentbufname . s:bufindex . "\<CR>"
  endif
  let dnum = b:dictnum
  let save_line = line('.')
  let save_col = col('.')
  " gg�Ńo�b�t�@�擪�Ɉړ����Ă���search()�Ō�������ƁA
  " �o�b�t�@�`���̌����Ώە�����Ƀq�b�g���Ȃ��̂ŁA��������wrap around���Č���
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

" �o�b�t�@�̃q�X�g�������ǂ�B
" @param dir -1:�Â�������, 1:�V����������
function! s:History(dir)
  let prevcontentbufname = s:contentbufname . s:bufindex
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
  call s:GoWindow(0)
  if a:down
    execute "normal! \<PageDown>"
  else
    execute "normal! \<PageUp>"
  endif
  execute "normal! \<C-W>p"
endfunction

" entry�E�B���h�E/content�E�B���h�E�Ɉړ�����
" @param to_entry_buf 1:entry�E�B���h�E�Ɉړ�, 0:content�E�B���h�E�Ɉړ�
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

" title�����񂩂玫���ԍ���Ԃ�
" @param title ������title������
" @return �����ԍ�
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

" �����ꗗ��\������
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

" �������X�L�b�v���邩�ǂ������ꎞ�I�ɐݒ肷��B
" @param is_skip �X�L�b�v���邩�ǂ����B1:�X�L�b�v����, 0:�X�L�b�v���Ȃ�
" @param ... �����ԍ��̃��X�g
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

" entry�E�B���h�E���J��
" @param index �J���o�b�t�@�̃C���f�b�N�X�ԍ�
function! s:OpenEntryWindow(index)
  let bufname = s:entrybufname . a:index
  if s:SelectWindowByName(bufname) < 0
    let cmd = ''
    " entry�o�b�t�@��content�o�b�t�@�̈ʒu���㉺�t�ɂȂ����肵�Ȃ��悤�ɂ���
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

" ��̃o�b�t�@�����
function! s:Empty_BufReadCmd()
endfunction
