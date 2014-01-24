" Vim syntax file
" Language:     eblook.vim
" Maintainer:   KIHARA Hideto <deton@m1.interq.or.jp>
" Original Maintainer:   KATO Noriaki <katono123@gmail.com>
" Last Change:  2014-01-24

scriptencoding cp932

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


if has("conceal")
  if g:eblook_show_refindex
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebRefBold,ebRefItalic
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebRefVisitedBold,ebRefVisitedItalic
    syn match ebRefBeg	"." contained
    syn match ebRefEnd	"." contained
    syn region ebImg matchgroup=ebImgBeg start="<\d\+\zeq" matchgroup=ebImgEnd end="r\zs>"
    syn region ebSnd matchgroup=ebSndBeg start="<\d\+\zes" matchgroup=ebSndEnd end="t\zs>"
    syn match ebImgBeg	"." contained
    syn match ebImgEnd	"." contained
    syn match ebSndBeg	"." contained
    syn match ebSndEnd	"." contained
  else
    syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebRefBold,ebRefItalic concealends
    syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebRefVisitedBold,ebRefVisitedItalic concealends
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

  syn region ebSup matchgroup=ebSupBeg start="\ze\^{" matchgroup=ebSupEnd end="}\zs" concealends
  syn region ebSub matchgroup=ebSubBeg start="\ze_{" matchgroup=ebSubEnd end="}\zs" concealends
  syn match ebSupBeg	"." contained
  syn match ebSupEnd	"." contained
  syn match ebSubBeg	"." contained
  syn match ebSubEnd	"." contained

  " cf. syntax/html.vim
  " XXX: ‚Æ‚è‚ ‚¦‚¸RefLink’†‚Å‚Í1’iŠK‚Ìitalic‚Æbold‚Ì‚Ý‘Î‰ž
  syn region ebRefItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebRefVisitedItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebRefBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebRefBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" concealends
  syn region ebRefVisitedBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebRefVisitedBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" concealends
  syn region ebBold matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebBoldItalic concealends
  syn region ebBold matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebBoldItalic concealends
  syn region ebBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebItalic matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBold concealends
  syn region ebItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" concealends
  syn region ebItalicBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" concealends
  syn match ebItalicBeg "." contained conceal
  syn match ebBoldBeg "." contained conceal
  syn match ebFontEnd "." contained conceal
  syn match ebEmBeg "." contained conceal
  syn match ebEmEnd "." contained conceal

else
  syn region ebRefLink matchgroup=ebRefBeg start="<\d\+|" matchgroup=ebRefEnd end="|>" contains=ebRefBold,ebRefItalic
  syn region ebRefLinkVisited matchgroup=ebRefBeg start="<\d\+!" matchgroup=ebRefEnd end="|>" contains=ebRefBold,ebRefVisitedItalic
  syn region ebImg matchgroup=ebImgBeg start="<\d\+\zeq" matchgroup=ebImgEnd end="r\zs>"
  syn region ebSnd matchgroup=ebSndBeg start="<\d\+\zes" matchgroup=ebSndEnd end="t\zs>"
  syn region ebSup matchgroup=ebSupBeg start="\ze\^{" matchgroup=ebSupEnd end="}\zs"
  syn region ebSub matchgroup=ebSubBeg start="\ze_{" matchgroup=ebSubEnd end="}\zs"
  syn match ebRefBeg	"." contained
  syn match ebRefEnd	"." contained
  syn match ebImgBeg	"." contained
  syn match ebImgEnd	"." contained
  syn match ebSndBeg	"." contained
  syn match ebSndEnd	"." contained
  syn match ebSupBeg	"." contained
  syn match ebSupEnd	"." contained
  syn match ebSubBeg	"." contained
  syn match ebSubEnd	"." contained

  syn region ebRefItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>"
  syn region ebRefVisitedItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>"
  syn region ebRefBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>"
  syn region ebRefBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>"
  syn region ebRefVisitedBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>"
  syn region ebRefVisitedBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>"
  syn region ebBold matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>" contains=ebBoldItalic
  syn region ebBold matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>" contains=ebBoldItalic
  syn region ebBoldItalic contained matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>"
  syn region ebItalic matchgroup=ebItalicBeg start="<i>" matchgroup=ebFontEnd end="</f>" contains=ebItalicBold
  syn region ebItalicBold contained matchgroup=ebBoldBeg start="<b>" matchgroup=ebFontEnd end="</f>"
  syn region ebItalicBold contained matchgroup=ebEmBeg start="<em>" matchgroup=ebEmEnd end="</em>"
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
function! s:AddAttr(attr, base, name)
  let hidef = s:GetHi(a:base)
  let def = matchstr(hidef, 'xxx \zs.*')
  if match(hidef, ' term=') == -1
    let def .= ' term=' . a:attr
  else
    let def = substitute(def, 'term=\(\S*\)', 'term=\1,' . a:attr, '')
  endif
  if match(def, 'cterm=') == -1
    let def .= ' cterm=' . a:attr
  else
    let def = substitute(def, 'cterm=\(\S*\)', 'cterm=\1,' . a:attr, '')
  endif
  if match(def, 'gui=') == -1
    let def .= ' gui=' . a:attr
  else
    let def = substitute(def, 'gui=\(\S*\)', 'gui=\1,' . a:attr, '')
  endif
  execute 'hi def ' . a:name . ' ' . def
endfunction
function! s:GetHi(name)
  silent! redir => hidef
  silent! execute 'hi ' . a:name
  silent! redir END
  let link = matchstr(hidef, ' links to \zs.*')
  if link == ''
    return hidef
  endif
  return s:GetHi(link)
endfunction
call s:AddAttr('italic', 'ebRefLink', 'ebRefItalic')
call s:AddAttr('italic', 'ebRefLinkVisited', 'ebRefVisitedItalic')
call s:AddAttr('bold', 'ebRefLink', 'ebRefBold')
call s:AddAttr('bold', 'ebRefLinkVisited', 'ebRefVisitedBold')
delfunc s:GetHi
delfunc s:AddAttr
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
hi def link ebSup	Comment
hi def link ebSub	Statement
hi def link ebSupBeg	Ignore
hi def link ebSupEnd	Ignore
hi def link ebSubBeg	Ignore
hi def link ebSubEnd	Ignore
hi def link ebPrevBeg	NonText
hi def link ebPrevEnd	NonText
hi def link ebNextBeg	NonText
hi def link ebNextEnd	NonText

hi def ebBold term=bold cterm=bold gui=bold
hi def ebBoldItalic term=bold,italic cterm=bold,italic gui=bold,italic
hi def ebItalic term=italic cterm=italic gui=italic
hi def link ebItalicBold ebBoldItalic
hi def link ebItalicBeg Ignore
hi def link ebBoldBeg Ignore
hi def link ebFontEnd Ignore
hi def link ebEmBeg Ignore
hi def link ebEmEnd Ignore

let b:current_syntax = "eblook"
