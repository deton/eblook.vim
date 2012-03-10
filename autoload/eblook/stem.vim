function! eblook#stem#stem(word)
  if a:word =~ '[^ -~]'
    return eblook#stem#stem_ja(a:word)
  else
    return eblook#stem#stem_en(a:word)
  endif
endfunction

function! eblook#stem#stem_ja(word)
  return []
endfunction

" ���������롼��ꥹ�� (ebview�򻲹ͤ˺���)
let g:eblook#stem#stem_en_rules = [
  \['ies$', 'y'],
  \['ied$', 'y'],
  \['es$', ''],
  \['ting$', 'te'],
  \['ing$', ''],
  \['ing$', 'e'],
  \['ed$', 'e'],
  \['ed$', ''],
  \['id$', 'y'],
  \['ices$', 'ex'],
  \['ves$', 'fe'],
  \['s$', ''],
\]

" ��ñ����Ф���촴��(stemming)��Ԥ���
function! eblook#stem#stem_en(word)
  let stemmed = []
  for rule in g:eblook#stem#stem_en_rules
    if a:word =~ rule[0]
      call add(stemmed, substitute(a:word, rule[0], rule[1], ''))
    endif
  endfor
  return stemmed
endfunction
