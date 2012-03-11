scriptencoding cp932

function! eblook#stem_en_porter#Stem(word)
  function! s:GetPorterStemFuncs()
    " porter-stem.vim<https://github.com/msbmsb/porter-stem.vim>ÇÃ<SNR>î‘çÜéÊìæ
    " :PorterStemÇÕ<SID>ÇégÇ¡ÇƒÇ»Ç¢ÇÃÇ≈:commandåãâ Ç©ÇÁÇÃéÊìæÇÕïsâ¬
    " http://d.hatena.ne.jp/thinca/20111228
    silent! redir => sliststr
    silent! scriptnames
    silent! redir END
    let slist = split(sliststr, "\n")
    call filter(slist, 'v:val =~ "porter-stem.vim"')
    let porterstem_sid = substitute(slist[0], '^\s*\(\d\+\):.*$', '\1', '')

    let s:Step1a = function('<SNR>' . porterstem_sid . '_Step1a')
    let s:Step1b = function('<SNR>' . porterstem_sid . '_Step1b')
    let s:Step1c = function('<SNR>' . porterstem_sid . '_Step1c')
    let s:Step2 = function('<SNR>' . porterstem_sid . '_Step2')
    let s:Step3 = function('<SNR>' . porterstem_sid . '_Step3')
    let s:Step4 = function('<SNR>' . porterstem_sid . '_Step4')
    let s:Step5a = function('<SNR>' . porterstem_sid . '_Step5a')
    let s:Step5b = function('<SNR>' . porterstem_sid . '_Step5b')

    function! s:Step1(word)
      let newword = s:Step1a(a:word)
      let newword = s:Step1b(newword)
      return s:Step1c(newword)
    endfunction

    function! s:Step5(word)
      let newword = s:Step5a(a:word)
      return s:Step5b(newword)
    endfunction
  endfunction

  if len(a:word) <= 2
    return []
  endif

  if !exists('s:Step1a')
    call s:GetPorterStemFuncs()
  endif

  " copy from GetWordStem()
  let newword = a:word

  " initial y fix
  let changedY = 0
  if newword[0] == 'y'
    let newword = 'Y'.newword[1:]
    let changedY = 1
  endif

  " Porter Stemming
  let newword1 = s:Step1(newword)
  let newword2 = s:Step2(newword1)
  let newword3 = s:Step3(newword2)
  let newword4 = s:Step4(newword3)
  let newword5 = s:Step5(newword4)

  let newwords = [newword1]
  call s:AddNew(newwords, newword2)
  call s:AddNew(newwords, newword3)
  call s:AddNew(newwords, newword4)
  call s:AddNew(newwords, newword5)

  if changedY
    call map(newwords, '"y" . v:val[1:]')
  endif

  return sort(newwords, 's:CompareLen')
endfunction

function! s:AddNew(lis, x)
  if index(a:lis, a:x) == -1
    return add(a:lis, a:x)
  endif
  return a:lis
endfunction

function! s:CompareLen(i1, i2)
  return len(a:i1) - len(a:i2)
endfunction
