" Vim syntax file
" Language:     eblook.vim
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2012-02-11

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


if has("conceal")
  syn match ebEntRef	"\(\d\+\. \)\?\x\+:\x\+\t" conceal
  syn region ebRefLink matchgroup=ebRefBeg start="<reference>" matchgroup=ebRefEnd end="</reference=[^>]*>" concealends
  syn region ebImg matchgroup=ebImgBeg start="<img=[^>]*>" matchgroup=ebImgEnd end="</img=[^>]*>" concealends
  syn region ebInline matchgroup=ebInlineBeg start="<inline=[^>]*>" matchgroup=ebInlineEnd end="</inline=[^>]*>" concealends
  syn region ebSnd matchgroup=ebSndBeg start="<snd=[^>]*>" matchgroup=ebSndEnd end="</snd>" concealends
  syn region ebMov matchgroup=ebMovBeg start="<mov=[^>]*>" matchgroup=ebMovEnd end="</mov>" concealends
  " cf. helpIgnore in syntax/help.vim
  syn match ebRefBeg	"." contained conceal
  syn match ebRefEnd	"." contained conceal
  syn match ebImgBeg	"." contained conceal
  syn match ebImgEnd	"." contained conceal
  syn match ebInlineBeg	"." contained conceal
  syn match ebInlineEnd	"." contained conceal
  syn match ebSndBeg	"." contained conceal
  syn match ebSndEnd	"." contained conceal
  syn match ebMovBeg	"." contained conceal
  syn match ebMovEnd	"." contained conceal
else
  syn match ebEntRef	"\(\d\+\. \)\?\x\+:\x\+\t"
  syn region ebRefLink matchgroup=ebRefBeg start="<reference>" matchgroup=ebRefEnd end="</reference=[^>]*>"
  syn region ebImg matchgroup=ebImgBeg start="<img=[^>]*>" matchgroup=ebImgEnd end="</img=[^>]*>"
  syn region ebInline matchgroup=ebInlineBeg start="<inline=[^>]*>" matchgroup=ebInlineEnd end="</inline=[^>]*>"
  syn region ebSnd matchgroup=ebSndBeg start="<snd=[^>]*>" matchgroup=ebSndEnd end="</snd>"
  syn region ebMov matchgroup=ebMovBeg start="<mov=[^>]*>" matchgroup=ebMovEnd end="</mov>"
  syn match ebRefBeg	"." contained
  syn match ebRefEnd	"." contained
  syn match ebImgBeg	"." contained
  syn match ebImgEnd	"." contained
  syn match ebInlineBeg	"." contained
  syn match ebInlineEnd	"." contained
  syn match ebSndBeg	"." contained
  syn match ebSndEnd	"." contained
  syn match ebMovBeg	"." contained
  syn match ebMovEnd	"." contained
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

hi def link ebRefLink	Underlined
if has("conceal")
  hi def link ebRefBeg	Conceal
  hi def link ebRefEnd	Conceal
  hi def link ebImgBeg	Conceal
  hi def link ebImgEnd	Conceal
  hi def link ebInlineBeg	Conceal
  hi def link ebInlineEnd	Conceal
  hi def link ebSndBeg	Conceal
  hi def link ebSndEnd	Conceal
  hi def link ebMovBeg	Conceal
  hi def link ebMovEnd	Conceal
  hi def link ebEntRef	Conceal
else
  hi def link ebRefBeg	Ignore
  hi def link ebRefEnd	Ignore
  hi def link ebImgBeg	Ignore
  hi def link ebImgEnd	Ignore
  hi def link ebInlineBeg	Ignore
  hi def link ebInlineEnd	Ignore
  hi def link ebSndBeg	Ignore
  hi def link ebSndEnd	Ignore
  hi def link ebMovBeg	Ignore
  hi def link ebMovEnd	Ignore
  hi def link ebEntRef	Ignore
endif
hi def link ebInline	Special
hi def link ebImg	Special
hi def link ebSnd	Special
hi def link ebMov	Special
hi def link ebPrevBeg	NonText
hi def link ebPrevEnd	NonText
hi def link ebNextBeg	NonText
hi def link ebNextEnd	NonText

let b:current_syntax = "eblook"
