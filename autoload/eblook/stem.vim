scriptencoding cp932

function! eblook#stem#Stem(word)
  if a:word =~ '[^ -~]'
    return s:StemUsingRules(a:word, g:eblook#stem_ja#rules)
    " TODO: ���������݂̂ɂ������̂�ǉ�����
  else
    if g:eblook_stemming == 2 && exists('g:loaded_porterstem')
      return eblook#stem_en_porter#Stem(a:word)
    else
      return s:StemUsingRules(a:word, g:eblook#stem_en#rules)
    endif
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
