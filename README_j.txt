eblook.vim - EPWING/電子ブック辞書検索プラグインスクリプト
							     Version: 1.0.2
							     Date: 2004-06-26

概要
  eblook.vimは、`eblook'プログラムを使って、
  EPWING/電子ブック辞書の検索を行うプラグインスクリプトです。

  VimでもEmacsのLookupのように辞書をひきたかったので作りました。
  複数の辞書を一度に検索できます。
  eblookプログラムのフロントエンドです。(NDTP等には対応していません。)

必要条件
  Vim 6.1以降。
  `eblook'プログラム<http://openlab.jp/edict/eblook/>。
  EPWING/電子ブック辞書<http://openlab.jp/edict/info.html>。

準備
  eblookプログラムをPATHの通った場所に置いて、
  実行できるようにしておいてください。

  アーカイブに含まれるファイルを次の場所に置いてください。

    ファイル            置く場所              ファイルの説明
  eblook.vim          'runtimepath'/plugin  プラグインスクリプト本体
  eblook.txt          'runtimepath'/doc     スクリプトの説明書

  'runtimepath'で示されるディレクトリは、Vim上で
  :echo &runtimepath を実行することで確認できます。

使い方
  eblook.txtを参照してください。

更新履歴
  - 1.0.2 (2004-06-26)
   - 'eblook_dict{n}_name'が同じ辞書が複数ある場合に、
     内容が正しく表示されないバグを修正
   - オプションを2つ追加。
     'eblookprg': eblookプログラムの名前
     'eblookenc': eblookプログラムの出力を読み込むときのエンコーディング

  - 1.0.1 (2003-12-06)
   - スペースを含む単語(de facto等)の検索ができなかったバグを修正。

  - 1.0 (2003-06-15)
    最初のリリース。

-- 
木原 英人 / KIHARA, Hideto / deton@m1.interq.or.jp
http://www1.interq.or.jp/~deton/eblook-vim/
$Id: README_j.txt,v 1.4 2004/06/26 09:50:48 deton Exp $
