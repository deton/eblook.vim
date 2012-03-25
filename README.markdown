eblook.vim - EPWING/電子ブック辞書検索プラグインスクリプト
==========================================================

概要
====
  eblook.vimは、`eblook'プログラムを使って、
  EPWING/電子ブック辞書の検索を行うプラグインスクリプトです。

  VimでもEmacsのLookupのように辞書をひきたかったので作りました。

* Vim上でカーソル位置の単語を辞書引きできます。
* 複数の辞書を一度に検索できます。
* eblookプログラムのフロントエンドです。

![表示例](http://www1.interq.or.jp/~deton/eblook-vim/eblook-vim.png)

必要なもの
==========
*  Vim7以降
*  `eblook'プログラム
     http://ikazuhiro.s206.xrea.com/staticpages/index.php/eblook
*  EPWING/電子ブック辞書
     http://hp.vector.co.jp/authors/VA000022/unixdic/unix-dic1.html#c1s4

準備
====
  eblookプログラムをPATHの通った場所に置いて、
  実行できるようにしておいてください。

  アーカイブに含まれるファイルを次の場所に置いてください。

*   ファイル            置く場所              ファイルの説明
* plugin/eblook.vim     'runtimepath'/plugin  プラグインスクリプト本体
* autoload/eblook/stem_en.vim  'runtimepath'/autoload/eblook  英語stemming用
* autoload/eblook/stem_ja.vim  'runtimepath'/autoload/eblook  日本語語尾補正用
* syntax/eblook.vim     'runtimepath'/syntax  eblook.vim用syntaxファイル
* doc/eblook.txt        'runtimepath'/doc     スクリプトの説明書

  'runtimepath'で示されるディレクトリは、Vim上で
  :echo &runtimepath を実行することで確認できます。

使い方
======
  doc/eblook.txt を参照してください。

更新履歴
========
* 1.1.0 (2012-03-XXX)
  * 新機能(表示関係)
        * 発音記号などの外字をUnicode文字列へ置換する機能を追加
          ([EBWin用の外字定義ファイル](http://www31.ocn.ne.jp/~h_ishida/EBPocket.html#download_gaiji)を使用)
        * `<img>`,`<inline>`,`<snd>`,`<mov>`を外部ビューアで
          表示・再生する機能を追加(画像等へのリンク上でxキー)。
	  (音声`<snd>`と動画`<mov>`の再生は
	  [eblook 1.6.1+media](http://ikazuhiro.s206.xrea.com/staticpages/index.php/eblook)が必要)
        * contentウィンドウ内の長い行を|gq|で整形する機能を追加(Oキー)。
          (行が長く、ウィンドウの高さが狭い場合でも、問題なく表示できるように)
  * 新機能(動作関係)
        * stemming/語尾補正機能を追加。
          何も見つからなかった時に、
          活用語尾などを取り除いて検索し直す機能を追加。
          [porter-stem.vim](https://github.com/msbmsb/porter-stem.vim)
          がインストール済であれば、porter-stem.vimも使用。
          また、日本語用は[EBView](http://ebview.sourceforge.net)と同様の
          語尾補正。
        * 辞書をグループ化して登録、検索する機能を追加。
          検索時に[count]で辞書グループ番号を指定。
        * contentウィンドウをoキーで最大化する機能を追加
  * 変更点(表示関係)
        * 置換定義の見つからない外字を_(下線)に置換するように変更
        * `<reference>...<reference=xxxx:xxx>`を`<n|...|>`に置換するように変更
          (nは、各contentウィンドウ内で1から始まるreference番号。
           xxxx:xxxとの対応を取るための番号)。
          (conceal syntaxで非表示にしても整形時にはカウントされているため、
          行の折り返しがかなり早めにされているように見えるので、なるべく短縮。)
          また、表示済の場合は`<n!...|>`に置換。
        * statuslineに検索語やキャプション文字列を表示するようにした
  * 変更点(動作関係)
        * Vim6対応を終了。要Vim7
        * Rキーやcontentウィンドウ内での`<CR>`キーにおいて、
          [count]で対象reference番号を指定可能にした。
        * 何も見つからなかった時に、検索語を編集して再検索するための
          プロンプトを出すように変更。再検索したくない場合は、
          編集せずにそのままリターンキー。
  * 変更点(設定関係)
        * ~/.vimrcでの辞書の設定をVim7のDictionaryとListで行う形式に変更
          (辞書の追加・削除・検索順の変更時の手間を減らすため)。
          (従来形式の設定にも対応。新形式への変換は:EblookPasteDictListで可能)
        * entryウィンドウの高さを指定する'eblook_entrywin_height'オプションを
          追加
        * 検索開始キーを`<Plug>EblookSearch`と`<Plug>EblookInput`で
          設定可能にした
  * バグ修正
        * 'noequalalways'オプションが設定されている時に、狭いウィンドウ上で
          辞書を引こうとすると、見出し一覧や内容表示ウィンドウが開けずに
          エラー(E36: Not enough room)になる問題を修正
        * appendix付きで指定した辞書の後にappendix指定無しの辞書を設定した場合、
          eblook側でappendixが引き継がれて、
          意図しない外字置換が発生する問題に対処
          (eblook 1.6.1+mediaでは修正されているので問題は発生しない)

* 1.0.5 (2012-01-19)
  * katonoさん作成のsyntaxファイルを取り込み
  * `<reference></reference=xxxx:xxx>`の非表示化
    (Vim 7.3で追加されたconceal syntaxを使用)

* 1.0.4 (2011-04-25)
  * Visual modeで選択された文字列を検索するためのmapを追加
    (katonoさんのmapをもとに作成)
  * Vimのregisterを汚さないように修整

* 1.0.3 (2009-04-07)
  * vim7で、単語が見つからない辞書がある場合に、entryバッファでのtitleの
    挿入が二重になってしまい、内容が正しく表示されない問題を修正
  * set expandtabしている場合に、`<reference>`先の内容表示ができない問題を修正

* 1.0.2 (2004-06-26)
  * 'eblook_dict{n}_name'が同じ辞書が複数ある場合に、内容が正しく表示されないバグを修正
  * オプションを2つ追加。
        * 'eblookprg': eblookプログラムの名前
        * 'eblookenc': eblookプログラムの出力を読み込むときのエンコーディング

* 1.0.1 (2003-12-06)
  * スペースを含む単語(de facto等)の検索ができなかったバグを修正。

* 1.0 (2003-06-15)
    最初のリリース。
