" Vim syntax file
" Language:     eblook.vim用syntax
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2012-01-15

" このファイルをvimfiles/syntaxにコピーしてください。

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


"syn match ebGaiji		"<gaiji=[^>]*>"
"syn match ebGaiji		"<gaiji=[^>]*>" contained
if has("conceal")
  syn match ebSnd		"<snd=[^>]*>.*</snd>" conceal
  syn match ebRefBeg		"<reference>" contained conceal
  syn match ebRefEnd		"</reference=[^>]*>" conceal
  syn match ebEntRef		"\([[:digit:]]\+\. \)\?[[:xdigit:]]\+:[[:xdigit:]]\+\t" conceal
else
  syn match ebSnd		"<snd=[^>]*>.*</snd>"
  syn match ebRefBeg		"<reference>" contained
  syn match ebRefEnd		"</reference=[^>]*>"
endif
syn region ebRefLink start="<reference>" end="</reference"me=e-11 contains=ebRefBeg,ebRefEnd,ebGaiji
syn match ebPrevBeg		"<prev>"
if has("conceal")
  syn match ebPrevEnd		"</prev>" conceal
else
  syn match ebPrevEnd		"</prev>"
endif
syn match ebNextBeg		"<next>"
if has("conceal")
  syn match ebNextEnd		"</next>" conceal
else
  syn match ebNextEnd		"</next>"
endif

command -nargs=+ HiLink hi def link <args>
HiLink ebRefLink	Underlined
HiLink ebRefBeg		Ignore
HiLink ebRefEnd		Ignore
HiLink ebEntRef		Ignore
HiLink ebSnd		Ignore
"HiLink ebGaiji		NonText
HiLink ebPrevBeg	NonText
HiLink ebPrevEnd	NonText
HiLink ebNextBeg	NonText
HiLink ebNextEnd	NonText
delcommand HiLink

let b:current_syntax = "eblook"

