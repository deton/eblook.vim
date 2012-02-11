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
  syn match ebRefBeg	"<reference>" contained conceal
  syn match ebRefEnd	"</reference=[^>]*>" contained conceal
  syn match ebImgBeg	"<img=[^>]*>" contained conceal cchar=<
  syn match ebImgEnd	"</img=[^>]*>" contained conceal cchar=>
  syn match ebInlineBeg	"<inline=[^>]*>" contained conceal cchar=<
  syn match ebInlineEnd	"</inline=[^>]*>" contained conceal cchar=>
  syn match ebSndBeg	"<snd=[^>]*>" contained conceal cchar=[
  syn match ebSndEnd	"</snd>" contained conceal cchar=]
  syn match ebMovBeg	"<mov=[^>]*>" contained conceal cchar=[
  syn match ebMovEnd	"</mov>" contained conceal cchar=]
  syn region ebRefLink	start="<reference>" end="</reference=[^>]*>" contains=ebRefBeg,ebRefEnd keepend concealends
  syn region ebImg	start="<img=[^>]*>" end="</img=[^>]*>" contains=ebImgBeg,ebImgEnd keepend concealends
  syn region ebInline	start="<inline=[^>]*>" end="</inline=[^>]*>" contains=ebInlineBeg,ebInlineEnd keepend concealends
  syn region ebSnd	start="<snd=[^>]*>" end="</snd>" contains=ebSndBeg,ebSndEnd keepend concealends
  syn region ebMov	start="<mov=[^>]*>" end="</mov>" contains=ebMovBeg,ebMovEnd keepend concealends
else
  syn match ebEntRef	"\(\d\+\. \)\?\x\+:\x\+\t"
  syn match ebRefBeg	"<reference>" contained
  syn match ebRefEnd	"</reference=[^>]*>" contained
  syn match ebImgBeg	"<img=[^>]*>" contained
  syn match ebImgEnd	"</img=[^>]*>" contained
  syn match ebInlineBeg	"<inline=[^>]*>" contained
  syn match ebInlineEnd	"</inline=[^>]*>" contained
  syn match ebSndBeg	"<snd=[^>]*>" contained
  syn match ebSndEnd	"</snd>" contained
  syn match ebMovBeg	"<mov=[^>]*>" contained
  syn match ebMovEnd	"</mov>" contained
  syn region ebRefLink	start="<reference>" end="</reference=[^>]*>" contains=ebRefBeg,ebRefEnd keepend
  syn region ebImg	start="<img=[^>]*>" end="</img=[^>]*>" contains=ebImgBeg,ebImgEnd keepend
  syn region ebInline	start="<inline=[^>]*>" end="</inline=[^>]*>" contains=ebInlineBeg,ebInlineEnd keepend
  syn region ebSnd	start="<snd=[^>]*>" end="</snd>" contains=ebSndBeg,ebSndEnd keepend
  syn region ebMov	start="<mov=[^>]*>" end="</mov>" contains=ebMovBeg,ebMovEnd keepend
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
