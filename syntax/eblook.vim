" Vim syntax file
" Language:     eblook.vim
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2012-09-09

scriptencoding cp932

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


if has("conceal")
  if g:eblook_show_refindex
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm
    syn match ebRefBeg	"." contained
    syn match ebRefEnd	"." contained
    syn region ebImg matchgroup=ebImgBeg start="<\d\+\zeq" matchgroup=ebImgEnd end="r\zs>"
    syn region ebSnd matchgroup=ebSndBeg start="<\d\+\zes" matchgroup=ebSndEnd end="t\zs>"
    syn match ebImgBeg	"." contained
    syn match ebImgEnd	"." contained
    syn match ebSndBeg	"." contained
    syn match ebSndEnd	"." contained
  else
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm concealends
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm concealends
    syn match ebRefBeg	"." contained conceal
    syn match ebRefEnd	"." contained conceal
    syn region ebImg matchgroup=ebImgBeg start="<\d\+\zeq" matchgroup=ebImgEnd end="r\zs>" concealends
    syn region ebSnd matchgroup=ebSndBeg start="<\d\+\zes" matchgroup=ebSndEnd end="t\zs>" concealends
    syn match ebImgBeg	"." contained conceal
    syn match ebImgEnd	"." contained conceal
    syn match ebSndBeg	"." contained conceal
    syn match ebSndEnd	"." contained conceal
  endif
  " cf. helpIgnore in syntax/help.vim

  " cf. syntax/html.vim
  syn region ebBold matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebBoldItalic,ebBoldEm concealends
  syn region ebBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebBoldItalicEm concealends
  syn region ebBoldEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebBoldEmItalic concealends
  syn region ebBoldItalicEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" concealends
  syn region ebBoldEmItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebItalic matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBold,ebItalicEm concealends
  syn region ebItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBoldEm concealends
  syn region ebItalicEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebItalicEmBold concealends
  syn region ebItalicBoldEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" concealends
  syn region ebItalicEmBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebEm matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebEmBold,ebEmItalic concealends
  syn region ebEmBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebEmBoldItalic concealends
  syn region ebEmItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebEmItalicBold concealends
  syn region ebEmBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebEmItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" concealends
  syn match ebItalicBeg "." contained conceal
  syn match ebBoldBeg "." contained conceal
  syn match ebFontEnd "." contained conceal
  syn match ebEmBeg "." contained conceal
  syn match ebEmEnd "." contained conceal

else
  syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm
  syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebBold,ebItalic,ebEm
  syn region ebImg matchgroup=ebImgBeg start="<\d\+\zeq" matchgroup=ebImgEnd end="r\zs>"
  syn region ebSnd matchgroup=ebSndBeg start="<\d\+\zes" matchgroup=ebSndEnd end="t\zs>"
  syn match ebRefBeg	"." contained
  syn match ebRefEnd	"." contained
  syn match ebImgBeg	"." contained
  syn match ebImgEnd	"." contained
  syn match ebSndBeg	"." contained
  syn match ebSndEnd	"." contained

  syn region ebBold matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebItalic,ebEm
  syn region ebBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebBoldItalicEm
  syn region ebBoldEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebBoldEmItalic
  syn region ebBoldItalicEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>"
  syn region ebBoldEmItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>"
  syn region ebItalic matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBold,ebItalicEm
  syn region ebItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBoldEm
  syn region ebItalicEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebItalicEmBold
  syn region ebItalicBoldEm contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>"
  syn region ebItalicEmBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>"
  syn region ebEm matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebEmBold,ebEmItalic
  syn region ebEmBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebEmBoldItalic
  syn region ebEmItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebEmItalicBold
  syn region ebEmBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>"
  syn region ebEmItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>"
  syn match ebItalicBeg "." contained
  syn match ebBoldBeg "." contained
  syn match ebFontEnd "." contained
  syn match ebEmBeg "." contained
  syn match ebEmEnd "." contained
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
if g:eblook_show_refindex
  hi def link ebRefBeg	Type
  hi def link ebRefEnd	Type
  hi def link ebImgBeg	Constant
  hi def link ebImgEnd	Constant
  hi def link ebSndBeg	Constant
  hi def link ebSndEnd	Constant
else
  hi def link ebRefBeg	Ignore
  hi def link ebRefEnd	Ignore
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

hi def ebBold term=bold cterm=bold gui=bold
hi def ebBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic
hi def ebBoldEm term=bold,underline cterm=bold,underline gui=bold,underline
hi def ebBoldItalicEm term=bold,italic,underline cterm=bold,italic,underline gui=bold,italic,underline
hi def link ebBoldEmItalic ebBoldItalicEm
hi def ebItalic term=italic cterm=italic gui=italic
hi def link ebItalicBold ebBoldItalic
hi def ebItalicEm term=italic,underline cterm=italic,underline gui=italic,underline
hi def link ebItalicBoldEm ebBoldItalicEm
hi def link ebItalicEmBold ebBoldItalicEm
hi def ebEm term=underline cterm=underline gui=underline
hi def link ebEmBold ebBoldEm
hi def link ebEmItalic ebItalicEm
hi def link ebEmBoldItalic ebBoldItalicEm
hi def link ebEmItalicBold ebBoldItalicEm
hi def link ebItalicBeg Ignore
hi def link ebBoldBeg Ignore
hi def link ebFontEnd Ignore
hi def link ebEmBeg Ignore
hi def link ebEmEnd Ignore

let b:current_syntax = "eblook"
