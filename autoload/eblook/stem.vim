scriptencoding cp932

function! eblook#stem#Stem(word)
  if a:word =~ '[^ -~]'
    return s:StemUsingRules(a:word, g:eblook#stem_ja#rules)
    " XXX: ebview�Ɠ��l�ɁA���������݂̂�ǉ�����
  else
    return eblook#stem_en#Stem(a:word)
  endif
endfunction

" ����␳���[�����g��������␳���s��
function! s:StemUsingRules(word, rules)
  let stemmed = []
  for rule in a:rules
    if a:word =~ rule[0]
      call add(stemmed, substitute(a:word, rule[0], rule[1], ''))
    endif
  endfor
  return stemmed
endfunction
