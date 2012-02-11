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


"syn match ebGaiji		"<gaiji=[^>]*>"
"syn match ebGaiji		"<gaiji=[^>]*>" contained
if has("conceal")
  syn match ebRefBeg		"<reference>" contained conceal
  syn match ebRefEnd		"</reference=[^>]*>" conceal
  syn match ebImgBeg		"<img=[^>]*>" contained conceal
  syn match ebImgEnd		"</img=[^>]*>" contained conceal
  syn match ebInlineBeg		"<inline=[^>]*>" contained conceal
  syn match ebInlineEnd		"</inline=[^>]*>" contained conceal
  syn match ebSndBeg		"<snd=[^>]*>" contained conceal
  syn match ebSndEnd		"</snd>" contained conceal
  syn match ebMovBeg		"<mov=[^>]*>" contained conceal
  syn match ebMovEnd		"</mov>" contained conceal
  syn match ebEntRef		"\(\d\+\. \)\?\x\+:\x\+\t" conceal
else
  syn match ebRefBeg		"<reference>" contained
  syn match ebRefEnd		"</reference=[^>]*>"
  syn match ebImgBeg		"<img=[^>]*>" contained
  syn match ebImgEnd		"</img=[^>]*>" contained
  syn match ebInlineBeg		"<inline=[^>]*>" contained
  syn match ebInlineEnd		"</inline=[^>]*>" contained
  syn match ebSndBeg		"<snd=[^>]*>" contained
  syn match ebSndEnd		"</snd>" contained
  syn match ebMovBeg		"<mov=[^>]*>" contained
  syn match ebMovEnd		"</mov>" contained
  syn match ebEntRef		"\(\d\+\. \)\?\x\+:\x\+\t"
endif
syn region ebRefLink start="<reference>" end="</reference"me=e-11 contains=ebRefBeg,ebRefEnd,ebGaiji
syn region ebImg start="<img=[^>]*>" end="</img=[^>]*>" contains=ebImgBeg,ebImgEnd keepend
syn region ebInline start="<inline=[^>]*>" end="</inline=[^>]*>" contains=ebInlineBeg,ebInlineEnd keepend
syn region ebSnd		start="<snd=" end="</snd>" contains=ebSndBeg,ebSndEnd keepend
syn region ebMov		start="<mov=" end="</mov>" contains=ebMovBeg,ebMovEnd keepend
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
HiLink ebImgBeg		Ignore
HiLink ebImgEnd		Ignore
HiLink ebInlineBeg	Ignore
HiLink ebInlineEnd	Ignore
HiLink ebSndBeg		Ignore
HiLink ebSndEnd		Ignore
HiLink ebMovBeg		Ignore
HiLink ebMovEnd		Ignore
HiLink ebInline		Special
HiLink ebImg		Special
HiLink ebSnd		Special
HiLink ebMov		Special
HiLink ebEntRef		Ignore
"HiLink ebGaiji		NonText
HiLink ebPrevBeg	NonText
HiLink ebPrevEnd	NonText
HiLink ebNextBeg	NonText
HiLink ebNextEnd	NonText
delcommand HiLink

let b:current_syntax = "eblook"
