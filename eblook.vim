let g:eblook_dict1 = 'kojien'
let s:entrybufname = 'eblook.entry'
let s:contentbufname = 'eblook.content'
let s:buflisted = 1
augroup Eblook
autocmd!
execute "autocmd BufReadCmd " . s:entrybufname . " call <SID>Empty_BufReadCmd()"
execute "autocmd BufReadCmd " . s:contentbufname . " call <SID>Empty_BufReadCmd()"
augroup END

command! EblookList call <SID>List()
command! -nargs=1 EblookSearch call <SID>Search(<args>)

" file name to store commands for eblook
let s:cmdfile = tempname()

" 空のバッファを作る
function! s:Empty_BufReadCmd()
endfunction

" execute eblook's list command
function! s:List()
  call s:OpenBuffer(s:entrybufname)
  execute 'redir! >' . s:cmdfile
  "silent echo 'set prompt ""'
  silent echo "list\n"
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs
  silent :%s/eblook> //g
  silent :g/^$/d
  normal 1G
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
  silent execute ':1/eblook-' . dname . '/;/^eblook/-1s/^/' . dname . '  '
  silent :%s/eblook.*> //g
  silent :g/^$/d
  normal 1G
endfunction

function! s:GetContent()
  let str = getline('.')
  let dname = matchstr(str, '^[^ ]\+')
  if strlen(dname) == 0
    return
  endif
  let pos = matchstr(str, '[0-9a-f]\+:[0-9a-f]\+')
  if strlen(pos) == 0
    return
  endif
  call s:OpenBuffer(s:contentbufname)
  execute 'redir! >' . s:cmdfile
  "silent echo 'set prompt ""'
  silent echo 'select ' . dname
  silent echo 'content ' . pos . "\n"
  redir END
  let save_fencs = &fencs
  let &fencs = &enc
  silent execute 'read! eblook < ' . s:cmdfile
  let &fencs = save_fencs
  silent :%s/eblook> //g
  silent :g/^$/d
  normal 1G
endfunction

function! s:OpenBuffer(bufname)
  if s:SelectWindowByName(a:bufname) < 0
    execute "silent normal! :split " . a:bufname . "\<CR>"
    set buftype=nofile
    set bufhidden=hide
    set noswapfile
    if !s:buflisted
      set nobuflisted
    endif
    nmap <buffer> <CR> :call <SID>GetContent()<CR>
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
