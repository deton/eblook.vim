" Vim syntax file
" Language:     eblook.vim
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2012-03-17

scriptencoding cp932

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


if has("conceal")
  if g:eblook_show_refindex
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>"
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>"
    syn match ebRefBeg	"." contained
    syn match ebRefEnd	"." contained
  else
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" concealends
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" concealends
    syn match ebRefBeg	"." contained conceal
    syn match ebRefEnd	"." contained conceal
  endif
  syn region ebImg matchgroup=ebImgBeg start="<\zeq" matchgroup=ebImgEnd end="r\zs>" concealends
  syn region ebSnd matchgroup=ebSndBeg start="<\zes" matchgroup=ebSndEnd end="t\zs>" concealends
  " cf. helpIgnore in syntax/help.vim
  syn match ebImgBeg	"." contained conceal
  syn match ebImgEnd	"." contained conceal
  syn match ebSndBeg	"." contained conceal
  syn match ebSndEnd	"." contained conceal
else
  syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>"
  syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>"
  syn region ebImg matchgroup=ebImgBeg start="<\zeq" matchgroup=ebImgEnd end="r\zs>"
  syn region ebSnd matchgroup=ebSndBeg start="<\zes" matchgroup=ebSndEnd end="t\zs>"
  syn match ebRefBeg	"." contained
  syn match ebRefEnd	"." contained
  syn match ebImgBeg	"." contained
  syn match ebImgEnd	"." contained
  syn match ebSndBeg	"." contained
  syn match ebSndEnd	"." contained
endif
syn match ebPrevBeg	"<prev>"
if has("conceal")
  syn match ebPrevEnd	"</prev>" conceal
else
  syn match ebPrevEnd	"</prev>"
endif
syn match ebNextBeg	"<next>"
if has("conceal")
  syn match ebNextEnd	"</next>" conceal
else
  syn match ebNextEnd	"</next>"
endif

hi def link ebRefLink	Identifier
hi def link ebRefLinkVisited	Special
if has("conceal")
  if g:eblook_show_refindex
    hi def link ebRefBeg	Type
    hi def link ebRefEnd	Type
  else
    hi def link ebRefBeg	Conceal
    hi def link ebRefEnd	Conceal
  endif
  hi def link ebImgBeg	Conceal
  hi def link ebImgEnd	Conceal
  hi def link ebSndBeg	Conceal
  hi def link ebSndEnd	Conceal
else
  if g:eblook_show_refindex
    hi def link ebRefBeg	Type
    hi def link ebRefEnd	Type
  else
    hi def link ebRefBeg	Ignore
    hi def link ebRefEnd	Ignore
  endif
  hi def link ebImgBeg	Ignore
  hi def link ebImgEnd	Ignore
  hi def link ebSndBeg	Ignore
  hi def link ebSndEnd	Ignore
endif
hi def link ebImg	Constant
hi def link ebSnd	Constant
hi def link ebPrevBeg	NonText
hi def link ebPrevEnd	NonText
hi def link ebNextBeg	NonText
hi def link ebNextEnd	NonText

let b:current_syntax = "eblook"
