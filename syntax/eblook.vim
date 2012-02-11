" Vim syntax file
" Language:     eblook.vim用syntax
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2012-02-11

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


if has("conceal")
  syn region ebRefLink matchgroup=ebRefBeg start="<reference>" matchgroup=ebRefEnd end="</reference=[^>]*>" concealends
  syn region ebImg matchgroup=ebImgBeg start="<img=[^>]*>" matchgroup=ebImgEnd end="</img=[^>]*>" concealends
  syn region ebInline matchgroup=ebInlineBeg start="<inline=[^>]*>" matchgroup=ebInlineEnd end="</inline=[^>]*>" concealends
  syn region ebSnd matchgroup=ebSndBeg start="<snd=[^>]*>" matchgroup=ebSndEnd end="</snd>" concealends
  syn region ebMov matchgroup=ebMovBeg start="<mov=[^>]*>" matchgroup=ebMovEnd end="</mov>" concealends
  syn match ebEntRef		"\(\d\+\. \)\?\x\+:\x\+\t" conceal
else
  syn region ebRefLink matchgroup=ebRefBeg start="<reference>" matchGroup=ebRefEnd end="</reference=[^>]*>"
  syn region ebImg matchgroup=ebImgBeg start="<img=[^>]*>" matchgroup=ebImgEnd end="</img=[^>]*>"
  syn region ebInline matchgroup=ebInlineBeg start="<inline=[^>]*>" matchgroup=ebInlineEnd end="</inline=[^>]*>"
  syn region ebSnd matchgroup=ebSndBeg start="<snd=[^>]*>" matchgroup=ebSndEnd end="</snd>"
  syn region ebMov matchgroup=ebMovBeg start="<mov=[^>]*>" matchgroup=ebMovEnd end="</mov>"
  syn match ebEntRef		"\(\d\+\. \)\?\x\+:\x\+\t"
endif
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
if has("conceal")
  HiLink ebRefBeg	Conceal
  HiLink ebRefEnd	Conceal
  HiLink ebImgBeg	Conceal
  HiLink ebImgEnd	Conceal
  HiLink ebInlineBeg	Conceal
  HiLink ebInlineEnd	Conceal
  HiLink ebSndBeg	Conceal
  HiLink ebSndEnd	Conceal
  HiLink ebMovBeg	Conceal
  HiLink ebMovEnd	Conceal
  HiLink ebEntRef	Conceal
else
  HiLink ebRefBeg	Ignore
  HiLink ebRefEnd	Ignore
  HiLink ebImgBeg	Ignore
  HiLink ebImgEnd	Ignore
  HiLink ebInlineBeg	Ignore
  HiLink ebInlineEnd	Ignore
  HiLink ebSndBeg	Ignore
  HiLink ebSndEnd	Ignore
  HiLink ebMovBeg	Ignore
  HiLink ebMovEnd	Ignore
  HiLink ebEntRef	Ignore
endif
HiLink ebInline		Special
HiLink ebImg		Special
HiLink ebSnd		Special
HiLink ebMov		Special
HiLink ebPrevBeg	NonText
HiLink ebPrevEnd	NonText
HiLink ebNextBeg	NonText
HiLink ebNextEnd	NonText
delcommand HiLink

let b:current_syntax = "eblook"
