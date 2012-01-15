" Vim syntax file
" Language:     eblook.vim用syntax
" Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2011/05/03

" このファイルをvimfiles/syntaxにコピーして、
" vimfiles/plugin/eblook.vimのs:Content_BufEnter()とs:Entry_BufEnter()に
" set filetype=eblookを追加してください。

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn match ebGaiji		"<gaiji=[^>]*>"
syn match ebGaiji		"<gaiji=[^>]*>" contained
syn match ebRefBeg		"<reference>" contained
syn match ebRefEnd		"</reference=[^>]*>"
syn region ebRefLink start="<reference>" end="</reference"me=e-11 contains=ebRefBeg,ebRefEnd,ebGaiji
syn match ebPrevBeg		"<prev>"
syn match ebPrevEnd		"</prev>"
syn match ebNextBeg		"<next>"
syn match ebNextEnd		"</next>"

command -nargs=+ HiLink hi def link <args>
HiLink ebRefLink	Underlined
HiLink ebRefBeg		NonText
HiLink ebRefEnd		NonText
HiLink ebGaiji		NonText
HiLink ebPrevBeg	NonText
HiLink ebPrevEnd	NonText
HiLink ebNextBeg	NonText
HiLink ebNextEnd	NonText
delcommand HiLink

let b:current_syntax = "eblook"

