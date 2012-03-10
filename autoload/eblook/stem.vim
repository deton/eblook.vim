scriptencoding cp932

function! eblook#stem#stem(word)
  if a:word =~ '[^ -~]'
    return eblook#stem#stem_using_rules(a:word, g:eblook#stem_ja#rules)
    " TODO: ���������݂̂ɂ������̂�ǉ�����
  else
    return eblook#stem#stem_using_rules(a:word, g:eblook#stem_en#rules)
  endif
endfunction

" ����␳���[�����g��������␳���s��
function! eblook#stem#stem_using_rules(word, rules)
  let stemmed = []
  for rule in a:rules
    if a:word =~ rule[0]
      call add(stemmed, substitute(a:word, rule[0], rule[1], ''))
    endif
  endfor
  return stemmed
endfunction
