scriptencoding cp932

function! eblook#stem#stem(word)
  if a:word =~ '[^ -~]'
    return eblook#stem#stem_using_rules(a:word, g:eblook#stem_ja#rules)
    " TODO: Š¿š•”•ª‚Ì‚İ‚É‚µ‚½‚à‚Ì‚ğ’Ç‰Á‚·‚é
  else
    return eblook#stem#stem_using_rules(a:word, g:eblook#stem_en#rules)
  endif
endfunction

" Œê”ö•â³ƒ‹[ƒ‹‚ğg‚Á‚½Œê”ö•â³‚ğs‚¤
function! eblook#stem#stem_using_rules(word, rules)
  let stemmed = []
  for rule in a:rules
    if a:word =~ rule[0]
      call add(stemmed, substitute(a:word, rule[0], rule[1], ''))
    endif
  endfor
  return stemmed
endfunction
