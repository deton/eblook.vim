eblook.vim - EPWING/電子ブック辞書検索プラグインスクリプト
							     Version: 1.0
							     Date: 2003-6-15

解説
  eblook.vimは、`eblook'プログラムを使って、
  EPWING/電子ブック辞書の検索を行うプラグインスクリプトです。

  VimでもEmacsのLookupのように辞書をひきたかったので作りました。
  複数の辞書を一度に検索できます。
  eblookプログラムのフロントエンドです。(NDTP等には対応していません。)

必要条件
  Vim 6.1以降。
  `eblook'プログラム<http://openlab.jp/edict/eblook/> 1.5.1。
  EPWING/電子ブック辞書<http://openlab.jp/edict/info.html>。

準備
  eblookプログラムをPATHの通った場所に置いて、
  実行できるようにしておいてください。

  アーカイブに含まれるファイルを次の場所に置いてください。

    ファイル            置く場所              ファイルの説明
  eblook.vim          'runtimepath'/plugin  プラグインスクリプト本体
  eblook.txt          'runtimepath'/doc     スクリプトの説明書

  'runtimepath'や$VIMで示されるディレクトリは、Vim上で
  :echo &runtimepath や :echo $VIM を実行することで確認できます。

使い方
  eblook.txtを参照してください。

-- 
木原 英人 / KIHARA, Hideto / deton@m1.interq.or.jp
http://www1.interq.or.jp/~deton/eblook-vim/
$Id: README_j.txt,v 1.2 2003/06/15 02:31:42 deton Exp $
