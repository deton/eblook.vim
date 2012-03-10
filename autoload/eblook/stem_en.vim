scriptencoding cp932

" 語尾補正ルールリスト (ebviewを参考に作成)
let g:eblook#stem_en#rules = [
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
