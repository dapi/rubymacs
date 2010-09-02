=begin
= irbsh 〜IRB.extend ShellUtilities〜
 $Id: irbsh.ja.rd.r 1133 2006-01-17 00:46:30Z rubikitch $

: author
    rubikitch<rubikitch@ruby-lang.org>
: irbsh official site
    ((<URL:http://www.rubyist.net/~rubikitch/computer/irbsh/>))
: screenshot
    * ((<スクリーンショット|URL:irbsh.jpg>))
    * ((<ヒストリメニューのスクリーンショット|URL:irbsh-history.jpg>))
    * ((<評価リストのスクリーンショット|URL:eval-list.jpg>))
    * ((<バックグラウンドシェルのスクリーンショット|URL:bg.jpg>))

##### [abstract]
== irbshとは
irbshとはirb(対話型Ruby)とinf-ruby-mode(irbのEmacsインターフェース)を大幅に拡張したものである。
シェルコマンドとの親和性を重点に置いている。
irbshは((<評価リスト>))機能があるため、Emacs上のちょっとした((*Ruby開発環境*))としての顔も持ち合わせるようになった。

非常に多機能であるが、使い方は簡単である。

##### [/abstract]


=== こんな人は使ってみて!!
以下のような人達に向いている。

* 頭の中がRubyだらけで、Rubyでしかモノを考えられない人。
* irbにすっかり魅了されてしまった人。
* シェルスクリプトなんてほとんど書か(け)ない人。
  * シェルスクリプトの代わりにRubyを使っている人も含む。
* EmacsとRubyの連携をうまく取りたいと考えている人。
* シェルコマンドにRubyな変数展開を施したいと思っている人。
* shell-modeが嫌いな人。
* zshを使っている人。
  * コマンドラインスタックあり。
  * その場でワイルドカード展開できたらなあと思っている人。
* リージョンやEmacsのバッファの内容をRubyやシェルで簡単に処理したい人。
* irbで長い出力がうざいと思っている人。
* 出力を他のバッファに保存したいと思ってる人。
* Emacsの強力補完機能でなんとかしたなあと思っている人。
* irbで複数行のコードをスムーズに入れたいなと思っている人。
* スクリプトをテキパキと開発したいなぁと思っている人。

=== irbshが用意している機能
以下の点を拡張してある。

* スペースから始まるコマンドラインはシェルコマンドとして実行。
  * Rubyの#{〜}による変数展開が使える。
  * どんなシェルコマンドを実行しているのかを表示できる。
  * 終了ステータスを表示。
* カレントディレクトリを切り替えると、irbshバッファのカレントディレクトリも切り替わる。(ディレクトリトラッキング)
  * shell-modeではそうなっている。
* (デフォルトで)2ストロークで system 関数を書ける。
  * Rubyの文の中にシェルコマンドを実行するのが容易。
* シェルコマンド/Rubyのコンテキストをキー一発で切り替え可能。
* コマンドラインの最後が
  * 「;」ならば出力を消す。MATLABの案。
  * 「|」なら他のバッファに出力を保存する。((<Oneliner|URL:http://oneliner-elisp.sourceforge.net/>))の案。
  * 「&」ならば別バッファでバックグラウンドでirbshと同時実行。当然対話的動作もできる。
* コンテキストに応じた((*賢い*))補完が可能。
  * バッファ名、シェルコマンド、ファイル/ディレクトリ名、メソッド/変数名。
* zshライクな機能。
  * コマンドラインスタックが利用可能。
  * ワイルドカード展開。
* ファイル名補完つきで任意のスクリプトをロード可能。
  * `ruby-load-file' と同じ機能だが、ちゃんと load "〜" と出る！
* 今編集しているバッファからirbshを呼出すことが可能。
* リージョン/バッファをFileオブジェクトとして扱うことが可能。
* 端末上のシェルライクなキーバインド。
* 間違ったコマンドラインを実行したとき、その結果を消すことができる。
* 式の途中で改行したら自動的に複数行入力を行う((<マルチラインバッファ>))へ移行する。
* ((<評価リスト>))機能で一連の式を一括実行。スクリプト開発支援。
* スクリプト落書きバッファ((<*ruby scratch*バッファ>))。
* ((<ワンライナー>))でいつでもどこでもRubyの式を実行できる。
* ((<YAML経由でオブジェクトを編集>))できる。
* 任意のEmacsLisp式を実行できる。
* ((<お手軽メソッド定義>))で簡単メソッド定義。

##### [install]
== ダウンロード
((<RAA:irbsh>))よりダウンロードすること。

== インストール
0.9.3にてインストーラがつきました。
(0) 当然のことながら、rubyとinf-ruby-modeをインストール。このとき((<irbについての注意>))についても参照。
(1) 次のコマンドを実行する。
      $ ruby setup.rb config
      $ ruby setup.rb setup
      # ruby setup.rb install

(3) .irbrcの最後に
      load "irbsh-lib.rb" if IRB.conf[:PROMPT_MODE] == :INF_RUBY

    と書く。
(4) .emacsに
      (load "irbsh")
      (load "irbsh-toggle")

    なり、
      (when (locate-library "irbsh")
        (autoload 'irbsh "irbsh" "irbsh - IRB.extend ShellUtilities" t)
        (autoload 'irbsh-oneliner-with-completion "irbsh" "irbsh oneliner" t))
      (when (locate-library "irbsh-toggle")
        (autoload 'irbsh-toggle "irbsh-toggle" 
          "Toggles between the *irbsh*1 buffer and whatever buffer you are editing."
        t)
        (autoload 'irbsh-toggle-cd "irbsh-toggle" 
          "Pops up a irbsh-buffer and insert a "cd <file-dir>" command." t))

    などと書く。
    もし、
      (file-error "Cannot open load file" "irbsh")
    などと怒られるようであれば、
      (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/")
    を加える。（厳密にはruby setup install時で*.elがインストールされるディレクトリ）
##### [/install]

=== irbについての注意
==== Windowsでは
Ruby付属のinf-ruby.elのデフォルトの設定ではWindowsでは動いてくれないこともある。
そのために以下の設定を.emacsに加えよう。((-ZnZさん、ありがとう-))

  (setq ruby-program-name "ruby -S irb --inf-ruby-mode")

== 起動方法
  M-x irbsh
とする。
いつものようにirbが起動するだろう。
カレントディレクトリが出ていることと、irbがirbshになっているという違いはあるものの、基本的には一緒。


== 使い方
まあ特に説明するまでもないけれど、使ってみればわかるものばかりだ。

=== 普通にinf-ruby-modeとして使う
何も言わないので、このまま使おう（笑）。
使い方は今までと一緒なので。
ってこれじゃあダウンロードした意味がないっしょ。

=== カレントディレクトリ表示・ディレクトリトラッキング
プロンプトの直前の行にカレントディレクトリを表示している。
これはあくまで現在有効なプロンプトの直前の行だけ表示していて、前のプロンプトのものは消えるようになっている。
このおかげで*irbsh*バッファのカレントディレクトリもそれに追随できる。

  irbsh(main):007:0> cd "/tmp"
  "/tmp"
  [pwd:/tmp]

cdコマンド(irbshの内部コマンド。Dir::chdirでもよいが、頻繁に使うので短縮形を用意。)でカレントディレクトリを /tmp にしてから、C-xC-fを押してみよう。
ちゃんと /tmp から始まるようになっている。


=== コマンドラインスタック
zshを使っている人にはおなじみ、コマンドラインスタック。
zshを使っている人はここは飛ばしても構わないが一応説明しておこう。

いきなりだが例をあげてみることにする。
たとえば、ファイルをコピーしたくなって、ここまで打ったとする。(1)

  #(1)
  [pwd:~]
  irbsh(main):001:0> File::cp File::expand_path("~/.emacs"), "/tmp"

おっと、 require 'ftools' 忘れてたって思う。
そのとき、M-qを押してみよう。
このようにコマンドラインが消える。(2)

  #(2)
  [pwd:~]
  irbsh(main):001:0> 

そしたら落ち着いて require 'ftools' と入れる。(3)

  #(3)
  [pwd:~]
  irbsh(main):001:0> require 'ftools'

なんと、前入力したコマンドが戻ってるじゃないか！(4)

  #(4)
  irbsh(main):001:0> require 'ftools'
  true
  [pwd:~]
  irbsh(main):002:0> File::cp File::expand_path("~/.emacs"), "/tmp"

めでたく、安心してEnterをブチっと押すとファイルのコピーが実行される。(5)

  #(5)
  irbsh(main):001:0> require 'ftools'
  true
  irbsh(main):002:0> File::cp File::expand_path("~/.emacs"), "/tmp"
  true
  [pwd:~]
  irbsh(main):003:0> 

なお、コマンドラインスタック機能はirbshと分離しているため、shell-modeやielm-modeなどでも使用可能。

=== スクリプトをロード
C-cC-f を押すとエコーエリアに
  Load file: ~/
と出てくるのでファイル名を入力する。
たとえば、 ~/.irbrc としたとき、
  irbsh(main):010:0> load '/home/rubikitch/.irbrc'
のような文が挿入される。

inf-ruby.elで ruby-load-file も同等の働きをするが、これを使うとちゃんと load 文が明示されるので、ロードされたことがわかる。

=== 多重化(複数の窓を開く)
C-cC-sで別プロセスのirbshを起動する。
バッファ名は*irbsh*のあとに1から順に数字が振られていく。
他のカレントディレクトリで作業する場合などに役立つだろう。

また、C-c 1〜C-c 9でその番号の*irbsh*バッファへ飛んでくれる。
GNU screenみたいなイメージである。

=== 編集しているバッファからirbshを呼ぶ
  M-x goto-irbsh
で任意のバッファよりirbshを呼ぶことができる。

現在ある*irbsh*バッファ群がどれも使用中のときは、新しいirbshが起動される。
使用中とは、*irbsh*バッファのカーソルがコマンドラインを指していないときのことをいう。

また、任意のバッファで
  M-x irbsh-toggle
を実行するとirbshバッファがポップアップする。
irbshバッファで実行するとirbshバッファを呼び出す前のウィンドウ構成に戻る。

=== 再起動
  M-x irbsh-restart
でirbshを再起動する。
すなわち、今のirbshプロセスを殺してもう一度立ち上げる。
この際、以前のバッファの内容はなくなるので注意。

=== 拡張されたコマンドたち
変数 irbsh-use-sigle-key-extension-flag を t にすると、C-w, C-u, C-kなどの動作が拡張される。
デフォルトでは t になっている。
「コマンドラインに文字列を入力する」という状況で、役に立たないコマンドのキーバインドに割り当てているので、通常の動作とかぶることはほとんどないだろう。

それぞれ、コマンドライン上での挙動が変わり、そうでないときは普通の動作である。

C-uを上書するのはさすがにやりすぎなのでVer 0.5.2よりC-uはもとの動作に戻した。
そのかわりC-c C-uを使おう。

: C-w
    1単語削除。

: C-u C-w
    kill-region。
: C-d
    コマンドラインの最後尾にいるときに '', を挿入。

    日本語キーボードを使っていて、CtrlとCapsを入れ替えている人にとっては楽に入力できるだろう。

: C-k
    コマンドラインの最後尾にいるときに先頭のスペースをトグルする。
    それによって入力したコマンドラインのコンテキストを切り替える。
    Rubyの文として解釈するか、シェルコマンドとして解釈するかが変わる。

    コマンドを入力してから、「あっ、これはシェルコマンドだった」って思ったときには迷わずこれを押そう！

: C-o
    C-p C-wと同じ効果。他の引数で同じコマンド/メソッドを実行したいときに便利。
: C-p
    直前のコマンドラインの内容を取り出す。M-pと同じ。
: C-n
    次のコマンドラインの内容を取り出す。M-nと同じ。
: C-v
    ((<ヒストリメニュー>))を開く。


=== 末尾の「,」を削除
C-d を使っていると末尾の「,」が残ってしまうことになる。
irbsh-strip-last-comma-flag を t にすると Enter を押したときに末尾の「,」が削除されるようになる。
デフォルトは t になっている。
だからわざわざ手で削除する必要はない。

  puts  C-d abc
  irbsh(main):083:0> puts 'abc',
  ↓ Enterを押す
  irbsh(main):083:0> puts 'abc'
  abc
  nil
  [pwd:~]

=== 出力結果をkill-ringへ
C-cC-k を押すと、直前のirbshの出力がkill-ringに入れられる。
文章を書いているときに M-x goto-irbsh でirbshを呼出し、何らかの計算をして、その結果を貼り付けるといった場合に有効である。



=== 出力を消す
C-c C-qで直前のプロンプトもろとも出力を消すことができる。
これは間違ったコマンドラインを実行してしまったときや、結果が思ったものと違う場合に使ってみよう。

  
  irbsh(*SHELL*):061:0>  ls ~/.eamcs
  ~ $ ls ~/.eamcs
  ls: /home/rubikitch/.eamcs: No such file or directory
  [pwd:~] (status = 256)
  irbsh(main):062:0> 

おっと、間違えた。
こういうときは落ち着いてC-c C-qを押そう！

  irbsh(main):062:0> 

そして、正しいコマンドを入力。

  irbsh(*SHELL*):062:0>  ls ~/.emacs
  ~ $ ls ~/.emacs
  /home/rubikitch/.emacs
  [pwd:~] (status = 0)
  irbsh(main):063:0> 

なお、C-c C-o は標準で用意されている機能で、出力のみを消すコマンドである。
  
  irbsh(*SHELL*):062:0>  ls ~/.emacs
  *** output flushed ***
  irbsh(main):063:0> 

=== 魔法のC-a
C-aにはちょっとした細工を仕掛けている。
一回押したらプロンプトの先頭へ飛ぶようになっている((-Emacs20までだと一気に行頭まで飛んでしまい、シェルとして使いにくいが、Emacs21からは行頭へ飛んでくれる-))。
そこでたて続けにC-aを押すと今度は行頭へ飛んでくれる。

  irbsh(main):004:0> 567
                        ^←カーソル位置
  ↓C-aを押すと
  irbsh(main):004:0> 567
                     ^
  ↓もう一回C-a
  irbsh(main):004:0> 567
  ^
=== 前/次のプロンプトへ飛ぶ
C-c C-p, C-c C-nでそれぞれ前/次のプロンプトへ飛んくれる。
これはshell-modeなどでもそうである。
そこで((<魔法のC-a>))などで行頭にカーソルを動かしたとき、それらのコマンドを実行したらそのプロンプトのある行の先頭へ飛んでくれるようになる。

これは出力結果をコピーするのに有用だ。

=== 対応する括弧の挿入
「(」、「{」、「[」、「'」、「"」において、対応する括弧を自動的に挿入することができる。
やりかたは簡単で、それらの文字を入力する前にC-cを押す。
対応する括弧が挿入され、括弧の真ん中にカーソルが移る。


  ↓C-c " を押すと
  irbsh[11@00:44](main):007:0> ""
                                ^←カーソル位置

=== お手軽メソッド定義

irbshでは次の特殊構文で手軽にメソッド定義ができるようにしている。
  メソッド名 (引数) メソッドの中身
ただし、コマンドラインのある行でしか使えない。  

内部でModule#define_methodを使っているので定義時のローカル変数もメソッドに含めることが可能。

  irbsh[17@09:10](main):015:0> one () 1
  #<Proc:0xb7984740@(irbsh):15>
  irbsh[17@09:10](main):016:0> two = 2
  2
  irbsh[17@09:10](main):017:0> three_times (x) x*(one+two)
  #<Proc:0xb7978b84@(irbsh):17>
  irbsh[17@09:10](main):018:0> three_times 10
  30

ローカル変数を含む複数行のメソッドが定義できるようにdefun特殊構文もある。

  irbsh[17@09:12](main):022:0> defun four()
                                 two+two
                               end
  #<Proc:0xb795abd4@(irbsh):22>
  irbsh[17@09:13](main):025:0> four
  4

== 制御符号
コマンドラインの末尾に特定の記号をつけることで細かい制御が可能。

=== 「;」出力を抑制
たとえば、結果が巨大な配列だったり長い文字列だったりしたとき、出力を抑制したくもなるだろう。
こういった場合には、文の最後に「;」を置けばよい。

  irbsh(main):008:0> Array.new 1000
  [nil, nil, nil...]
  irbsh(main):009:0> Array.new 1000;
  [pwd:/tmp] (Output is disabled.)
  irbsh(main):010:0> 

このように、出力が打ち消される。
MATLABを使っているのならば、それと同じと考えればよかろう。

=== 「|」出力を別バッファに保存(リダイレクト)
このコマンドの出力結果はあとで取っておきたいとか思ったら、コマンドラインの末尾に「|」をつけよう。
こうすることで irbsh-redirect-output-buffer で指定したバッファ(デフォルト "*irbsh output*")に出力結果が保存される。

  irbsh(main):009:0> Array.new(3)|
  output is at #<buffer *irbsh output*>
  irbsh(*SHELL*):010:0>  ls ~/.emacs|
  output is at #<buffer *irbsh output*>

なお、 irbsh-display-redirect-output-buffer-flagをtにすれば出力バッファがポップアップされる。
デフォルトはnilにしている。

=== 「&」バックグラウンドシェル
通常のシェルと同様に「&」をコマンドラインの末尾につけたらバックグラウンドでコマンドを実行するようになる。
ただし、これはシェルのコンテキストでのみ有効である。
Rubyのコンテキストだと、継続行になるので注意。
「|」に似ているが、バックグラウンドシェルを起動したらすぐにirbshのプロンプトに戻る点が違う。 


  irbsh[29@07:58](main):061:0> 
  #### MULTI-LINE BEGIN ####
  "1&
  2"
  #### MULTI-LINE END ####
  "1&\n2"
  irbsh[29@07:58](*SHELL*):062:0>  ls &
  background process at #<buffer *ls*>

このとき、*ls*というバッファに「ls」の出力結果が保存される。
major-mode は shell-mode を継承した irbsh-background-shell-mode となる。
基本的には shell-mode なので、ユーザ入力が伴う対話的なプログラムでも問題なく実行できる。
通常の shell-mode と違うのは、
* シェルのプロンプトが出ない
* プロセスが終了したら
  * 「q」でバッファを消せる
  * 「C-m(Enter)」で同じコマンドを実行できる
という点だ。
GNU Screenのzombie機能みたいな感じだと思えばよい。
当然、「q」も「C-m」もプロセス実行中は「そのまま」のキーとして役割を果たす。

なお、この機能はruby的には特に何もしていない。
コマンドラインをemacsが解釈してemacsがバックグラウンドプロセスを立ち上げているのである。

また、irbsh-use-screenをtにするとバックグラウンドシェルのかわりにGNU Screenを利用する。

== シェルとしての機能
irbshはシェルコマンドを実行しやすくするために作られたので、シェルとしての機能には力を入れている。

=== シェルコマンドの実行
コマンドラインにて、((*最初に空白をあける*))ことでこの行をシェルコマンドとみなす。
このとき irbsh-display-context-at-prompt-flag が t ならば、プロンプトにこの行をシェルコマンドとみなすのか、Rubyスクリプトとみなすのか(以後、これを「コンテキスト」と言おう)を示してくれる。


Emacs内部で
  irbsh_system %Q[空白を取り除いたコマンドラインの内容]
と展開されるので、変数展開もしてくれる。
なお、statusとはシェルコマンドのリターンコードである。

  irbsh(*SHELL*):048:0>  pwd
  ~ $ pwd
  /home/rubikitch
  irbsh(main):049:0> a = 1
  1
  irbsh(*SHELL*):050:0>  echo #{a}
  ~ $ echo 1
  1
  [pwd:~] (status = 0)

=== ワンタッチsystemコマンド
ただ、上記の機能だけではRubyの制御構造を使ったりすることはできない。
そのためには irbsh_system を明示的に指定する必要がある。

ただ、これをそのまま入力するのは面倒なのでワンタッチで入力できるようにしている。
C-cC-m を押すと irbsh_system %Q[] が挿入され、[]の真ん中にカーソルがゆく。
irbsh_system は system 関数を irbsh 用にしたものでシェルコマンドを実行する。

  irbsh(main):039:0> irbsh_system %Q[pwd]
  ~/src/irbsh $ pwd
  /home/rubikitch/src/irbsh
  [pwd:~/src/irbsh] (status = 0)

  irbsh(main):004:0> (1..5).each {|i| irbsh_system %Q[echo #{i}]}
  ~ $ echo 1
  1
  ~ $ echo 2
  2
  ~ $ echo 3
  3
  ~ $ echo 4
  4
  ~ $ echo 5
  5
  [pwd:~] (status = 0)


=== cdについて
いろんな事情があって、cdコマンドは特別扱いをしている。

==== シェルコマンドとしてcdを実行すると
irbshがシェルコマンドを実行するときは、子プロセスを生成するという方法をとっている。
そのため、そのままcdコマンドをシェルコマンドとして実行しても実行後には元のディレクトリに戻ってしまう。
こういう落とし穴にはまらないためにも、シェルコマンドとしてcdを実行しようとしたら、irbsh_cdメソッドを呼ぶことにしている。
よって安心してcdできる。

  irbsh(*SHELL*):006:0>  cd
  "~"
  irbsh(*SHELL*):007:0>  cd /tmp
  "/tmp"
  [pwd:/tmp]

==== Rubyの文としてcdするときはquote不要
cdはかなり頻繁に行われるので、いちいちコマンドの前にスペースを入れたり、quoteしたりするのが面倒だという人もいるだろう。

変数 irbsh-use-cd-without-quote-flag を t にすると、cdメソッドの引数でquoteされていなくても、あたかもquoteされたように扱う。
ただし、変数を引数としたときにはまる可能性があるのでちょっと注意が必要である。
そのためデフォルトではnilにしている。
nilにしていてもC-dでquoteできるのでさほど混乱はしないだろう。

  irbsh(main):010:0> cd /tmp
  "/tmp"
  [pwd:/tmp]
  irbsh(main):011:0> cd '~/emacs/'
  "~/emacs"
  [pwd:~/emacs]


=== コマンド実行履歴
irbsh-history-fileに指定されたファイルにコマンド実行履歴が記録される。初期値は~/.irbsh_history。nilに設定すると記録されない。



== 高度な機能
irbshには独特の機能をいくつか用意している。

=== 試運転機能
複雑な制御構造の中でシェルコマンドを実行するとき、どうしても試運転したくなることがあるだろう。
そんなときのために試運転機能を用意している。

使い方はいたって簡単で、最後に「$」をつけるだけ。

  irbsh(main):019:0> 3.times { irbsh_system %Q[echo 123] }$
  ~/emacs(dryrun) $ echo 123
  ~/emacs(dryrun) $ echo 123
  ~/emacs(dryrun) $ echo 123
  3
  [pwd:~/emacs]

  irbsh(main):020:0> 3.times { irbsh_system %Q[echo 123] }
  ~/emacs $ echo 123
  123
  ~/emacs $ echo 123
  123
  ~/emacs $ echo 123
  123
  [pwd:~/emacs] (status = 0)


=== quoteなしでRubyの式を実行
irbshでは特定の名前で定義されたRubyのメソッドをquoteなしで実行することができる。
あたかもシェルコマンドを実行しているような感覚である。
これは、最後の引数を変えて同じメソッドを実行するのに役立つ。

さて、どのように引数が渡るのか説明しよう。
あなたは Method#arity というメソッドを知っているかな？
リファレンスマニュアルを見ればわかるのだが、これはメソッドの引数の数を返す。
Rubyの引数は可変長引数もサポートしているので、arityが負の値を返すこともある。
該当部分を引用してみよう。

: arity
    メソッドオブジェクトの引数の数を返します．
    selfが引数の数を可変長で受け取れる場合
      -(最低限必要な数+1)
    を返します．

シェルコマンドと同じ感覚なのでコマンドラインはsplitされる。
splitされたもののうち、最初のもの( f としよう)が名前を表す。
このとき「nq_f」というメソッドが定義されているのなら、それが実行される。
そうでなければシェルコマンドとしてコマンドラインが実行される。

splitされたもので先頭のもの以外は nq_f の引数になる。
その数を n としよう
arityの値によって以下のように渡される。

: arity == n
    それぞれの引数に文字列として渡される。
: arity < n
    先頭から順に詰めていき、最後に引数はあまったものを空白でくっつけたもの。
    すなわち cmdline.split( /\s+/, arity ) である。
: arity > n
    エラー。
: arity < 0
    先頭から順に詰めていき、最後はあまったものの配列が渡る。

例をあげてみよう。
なお、ppというのは((<pの強力版|URL:http://www.rubyist.net/~rubikitch/computer/ppp/>))である。
    
  irbsh(main):121:0> require 'ppp'
  true
  irbsh(main):130:0> def nq_f1(x); ppp :x; end
  nil
  irbsh(main):132:0> def nq_f2(x,y); ppp :x, :y; end
  nil
  irbsh(main):134:0> def nq_f3(x,*y); ppp :x,:y; end
  nil
  irbsh(main):135:0> def nq_f4(x,y,*z);ppp :x,:y,:z; end
  nil
  irbsh(main):148:0> method(:nq_f1).arity
  1
  irbsh(main):149:0> method(:nq_f2).arity
  2
  irbsh(main):150:0> method(:nq_f3).arity
  -2
  irbsh(main):151:0> method(:nq_f4).arity
  -3
  irbsh(main):139:0>  f1 1 2 3 4 5
  x = "1 2 3 4 5"
  [:x]
  irbsh(main):140:0>  f2 1 2 3 4 5
  x = "1"
  y = "2 3 4 5"
  [:x, :y]
  irbsh(main):141:0>  f3 1 2 3 4 5
  x = "1"
  y = ["2", "3", "4", "5"]
  [:x, :y]
  irbsh(main):144:0>  f4 1 2 3 4 5
  x = "1"
  y = "2"
  z = ["3", "4", "5"]
  [:x, :y, :z]

=== ヒストリメニュー
過去に実行したコマンドラインをコピーすることができる。
これによって、過去に行った動作を自動化することも簡単になる。

コマンドライン上でC-vを押してみよう。
もし、C-vが嫌ならばコマンド irbsh-history-menu を適当なキーに割り当てよう。
画面が分割されて*irbsh history*というバッファに過去に実行したコマンドがずら〜っとでてくる。

ここで
  Select history:
とでてくる。
最初の1文字、すなわちコロンの前にある文字をタイプすればそのコマンドが今のコマンドラインにコピーされる。
また次のコマンドをコピーしたいのならば、またC-vを押して選ぼう。

なお、この*irbsh history*バッファは、そのコマンドラインを実行したときに消えるのでそんなに邪魔にはならないだろう。
どうしても邪魔ならばSelect history: と出たときに 0 あるいは C-v とタイプすれば*irbsh history*バッファは画面から消える。

また、*irbsh history*表示中に C-s を押し検索文字列を入力するとマッチしたもののみ選択できる。

=== メタ変数

irbshとEmacsの間でデータをやりとりするため、次のメタ変数が使える。

==== EmacsバッファをFileオブジェクトとして扱う
irbshではEmacsのバッファを扱うことができる。
ただし、今のところ読み込み専用となっている。
書き込みが必要な場合はirbshではなくてEmacs Lispで書くなり、((<出力結果をkill-ringへ>))を使うなりしてみよう。

バッファの内容を扱うには

「---バッファ名---」

というメタ変数もどきを書いてやればいい。
このとき、そのバッファの内容は一時ファイルに保存され、そのFileオブジェクトを得ることができる。
あとは、通常のFileオブジェクトと同様に扱うことができる。

「---バッファ名---」を実行した時点でのバッファの内容が保存されるので、その後にバッファを変更してもそのFileオブジェクトには反映((*されない*))ので注意しよう。
その時点での内容を反映させたかったら再び「---バッファ名---」を評価すること。

たとえば、*scratch*バッファの内容が以下のものであるとする。
  ;; This buffer is for notes you don't want to save, and for Lisp evaluation.
  ;; If you want to create a file, visit that file with C-x C-f,
  ;; then enter the text in that file's own buffer.

そして、irbshで試しに実行してみると、

  irbsh(main):063:0> scratch = ---*scratch*---
  #<File:0x401938a0>
  irbsh(main):064:0> scratch.class
  File
  irbsh(main):065:0> scratch.path
  "/tmp/irbshtmp4964wnC"
  irbsh(main):066:0> s = scratch.read
  ";; This buffer is for notes you don't want to save, and for Lisp evaluation.\n;; If you want to create a file, visit that file with C-x C-f,\n;; then enter the text in that file's own buffer.\n"
  irbsh(main):067:0> ni
  ;; This buffer is for notes you don't want to save, and for Lisp evaluation.
  ;; If you want to create a file, visit that file with C-x C-f,
  ;; then enter the text in that file's own buffer.
  irbsh(main):068:0> s.grep(/save/)
  [";; This buffer is for notes you don't want to save, and for Lisp evaluation.\n"]
  


==== リージョンをFileオブジェクトとして扱う
((<EmacsバッファをFileオブジェクトとして扱う>))の変種としてリージョンもFileオブジェクトとして扱うことができる。
これも例によって読み込み専用である。

(1) まず、適当なリージョンを作り、M-wやC-wでkill-ringに入れる。
(2) そしてirbshで「__region__」とする

そうするとリージョンの内容が一時ファイルに保存され __region__ がそのFileオブジェクトになる。

「foo bar baz」がリージョンの内容だとする。
このときの実行結果はこんな感じ。
  irbsh(main):019:0> fbb = __region__
  #<File:0x402f62a4>
  irbsh(main):020:0> fbb.gets
  "foo bar baz"
  irbsh(main):021:0> fbb.rewind; fbb.read
  "foo bar baz"


=== EmacsLisp式を評価する
irbsh内でEmacsLisp式を評価することができる。
シェルのコンテキストでは
  el
を、Rubyのコンテキストでは
  EmacsLisp.el
を使う。

  irbsh[13@18:30](*SHELL*):010:0>  el (setq a 2)
  2
  nil
  irbsh[13@18:30](main):011:0> EmacsLisp.el %((setq a (* 2 a))) 
  4
  nil

なお、これは((<YAML経由でオブジェクトを編集>))機能のための簡単な実装なのでRubyで本格的にEmacsをコントロールしたいならば((<el4r|URL:http://www.rubyist.net/~rubikitch/computer/el4r/>))を使おう。

=== YAML経由でオブジェクトを編集
irbshではオブジェクトを編集することができる。
ただし、YAMLに落とせるオブジェクトに限定される。
オブジェクトをじっくり眺めたり修正したり。

  irbsh[13@18:30](main):012:0> s = "abcd"
  "abcd"
  irbsh[13@18:38](main):013:0> s.edit
  "editing object..."
  "ABCD"


s.editを実行するとYAMLでの表現がバッファに出てくる。
  　--- abcd
これをたとえば次のように修正し、 C-c C-c で抜ける。すると
  　--- ABCD
irbshにも反映される。

YAMLは自然な表現なので少しの修正ならば直感で大丈夫だと思う。

== 強力補完機能
irbshの特徴として強力な補完機能がある。
irbshのコンテキストにあわせて補完のされ方がかわっていく。
文脈を見て判断してくれるので、かなり賢い。

=== シェルコマンド入力時の補完
コマンドラインをスペースから始めた場合やirbsh_systemメソッドの引数においてはシェルコマンド入力時の補完機能が働く。
shell-modeや通常のシェルでおなじみのように最初の引数はコマンドが補完され、その補完の引数ではファイル名が補完される。

ここで注目すべきことは、シェルコマンド入力時はファイル名の最後にスペースも追加されて補完されることである。

==== コマンド名補完
dpkg-buildpackageコマンドがあるとする。
このときに、「dpkg-bu」まで入力して TAB を押すと、 dpkg-buildpackage と補完される。
  irbsh(*SHELL*):076:0>  dpkg-bu
  ↓ TAB を押す
  irbsh(*SHELL*):076:0>  dpkg-buildpackage 

また、zshライクなコマンド名補完もサポートしている。

  irbsh(*SHELL*):026:0>  ls =modpro
  ↓ TAB を押す
  irbsh(*SHELL*):026:0>  ls =modprobe 

==== ファイル名補完
.zprofileというファイルと compile/hoge というファイルがあるとする。

  irbsh(*SHELL*):077:0>  cat .zpro
  ↓ TAB を押すと末尾にスペースつきで補完される。
  irbsh(*SHELL*):077:0>  cat .zprofile
  ↓
  irbsh(*SHELL*):077:0>  cat .zprofile compi
  ↓ TAB を押すとディレクトリの / まで補完される。
  irbsh(*SHELL*):077:0>  cat .zprofile compile/
  ↓ 
  irbsh(*SHELL*):077:0>  cat .zprofile compile/hog
  ↓
  irbsh(*SHELL*):077:0>  cat .zprofile compile/hoge 

=== Rubyの文においてファイル名の補完
一方で、Rubyの文のコンテキストでは。
上記と同じように .zprofile と compile/hoge の例を示してみよう。
puts を '.zprofile' と 'compile/hoge' を引数に実行する場合を想定すると。

  ↓puts C-d .zproと入力
  irbsh(main):022:0> puts '.zpro',
  ↓ TAB を押すと補完される。カーソルは e の後ろ。
  irbsh(main):022:0> puts '.zprofile',
  ↓ C-e で行末へ。カーソルは , の後ろ。
  irbsh(main):022:0> puts '.zprofile',
  ↓ C-d を押す。カーソルは '' の間
  irbsh(main):022:0> puts '.zprofile','',
  ↓ compi と入力
  irbsh(main):022:0> puts '.zprofile','compi',
  ↓ TAB
  irbsh(main):022:0> puts '.zprofile','compile/',
  ↓ hogeと入力
  irbsh(main):022:0> puts '.zprofile','compile/hoge',
  ↓ Enter を押すと , が削除されてから実行。めでたしめでたし。
  irbsh(main):022:0> puts '.zprofile','compile/hoge'


=== 前と同一のディレクトリ名を補完
zshには同じディレクトリ内のファイルをまとめて指定することができる。
compile/foo と compile/bar があることを想定する。。
zshユーザは compile/{foo,bar} と指定するところだろう。

Dir['compile/{foo,bar}']をとやるとちゃんと ["compile/foo", "compile/bar"] と展開してくれるが、zshと違って((-zshでは compile/{foo,bar} と入力したあとで TAB を押すと展開してくれる。-))コマンドラインでは展開してくれないので、この機能の存在価値がないとはいえない。

  irbsh(main):090:0> Dir['compile/{foo,bar}']
  ["compile/foo", "compile/bar"]

==== シェルコマンドのコンテキストでは
シェルコマンドのコンテキストでこの様子を見てみよう。

  echo compi まで入力
  irbsh(*SHELL*):091:0>  echo compi
  ↓ TAB
  irbsh(*SHELL*):091:0>  echo compile/
  ↓ fo TAB。スペースも追加される。
  irbsh(*SHELL*):091:0>  echo compile/foo 
  ↓ ここがミソ。もう一度 TAB。ディレクトリが補完される！！
  irbsh(*SHELL*):091:0>  echo compile/foo compile/
  ↓ ba TAB。
  irbsh(*SHELL*):091:0>  echo compile/foo compile/bar 

==== Rubyのコンテキストでは
同じくRubyのコンテキストでは、
  puts C-d compi まで入力
  irbsh(main):091:0> puts 'compi',
  ↓ TAB。カーソルは / の後ろ。
  irbsh(main):091:0> puts 'compile/',
  ↓ fo TAB
  irbsh(main):091:0> puts 'compile/foo',
  ↓ C-e。カーソルは最後尾に
  irbsh(main):091:0> puts 'compile/foo',
  ↓ TABを押す。ディレクトリが補完される！！
  irbsh(main):091:0> puts 'compile/foo','compile/',
  ↓ ba TAB
  irbsh(main):091:0> puts 'compile/foo','compile/bar',
  ↓ Enter
  irbsh(main):091:0> puts 'compile/foo','compile/bar'

=== ディレクトリの補完
mkdirやcdなどディレクトリに適用するコマンド/メソッドについてはディレクトリ名で補完が行われる。
これはシェルコマンド/Rubyのどちらのコンテキストでも行われる。

ディレクトリの補完を適用するコマンド/メソッドは変数 irbsh-directory-completion-command-regexp で正規表現で指定する。

=== ワイルドカード展開
これは厳密には補完ではないが、zshライクなワイルドカード展開もやってくれる。
zshでは補完と同じくTabで行うのでここに入れておこう。
この機能は今のところシェルコマンドのコンテキストでのみ有効である。

ただ、ワイルドカード展開はRubyのDir.globメソッドを使うので、これらのみ有効となっている。
zshの拡張ワイルドカードは使えないので注意。
以下、Ruby1.6リファレンスマニュアルより抜粋。

    * (({*}))

      空文字列を含む任意の文字列と一致します．
    * (({?}))

      任意の一文字と一致します．
    * (({[ ]}))

      鈎括弧内のいずれかの文字と一致します．(({-}))でつな
      がれた文字は範囲を表します．鈎括弧の中の最初の文字が
      (({^}))である時には含まれない文字と一致します．
    * (({{ }}))

      コンマで区切られた文字列の組合せに展開します．例えば，
      (({foo{a,b,c}}))は(({fooa})), (({foob})),
      (({fooc}))に展開されます．他のワイルドカードと異な
      り，展開結果のファイルが存在している必要はありません．
    * (({**/}))

      ワイルドカード (({*/})) の0回以上の繰り返しを意味し，
      ディレクトリを再帰的にたどってマッチを行います．
      例えば,
      (({foo/**/bar})) は (({foo/bar})), (({foo/*/bar})),
      (({foo/*/*/bar})) ... (以下無限に続く)に対して一致する
      文字すべてと一致します．

例を示そう。

  irbsh(*SHELL*):032:0>  ls
  ~/src/irbsh $ ls
  GPL                  comint-redirect.el   irbsh.el                     irbsh.ja.html
  Makefile          comint-util.el       irbsh.elc             irbsh.ja.rd
  RCS                  irbsh-completion.rb  irbsh.ja.hindex.html
  cmdline-stack.el  irbsh-lib.rb               irbsh.ja.hindex.rd
  [pwd:~/src/irbsh] (status = 0)
  irbsh(*SHELL*):033:0>  ls *.el

このときにTabを押すと。

  irbsh(*SHELL*):033:0>  ls cmdline-stack.el irbsh.el comint-redirect.el comint-util.el 

このように展開される。同じくこれも

  irbsh(*SHELL*):033:0>  ls {GPL,RCS}
  ↓
  irbsh(*SHELL*):033:0>  ls GPL RCS 

のようになる。

=== ホームディレクトリ展開
これも補完ではないが、「~(チルダ)」をホームディレクトリに展開する機能も持っている。
これは、Rubyの文字列でファイル名を指定するときに役立つ。
チルダかその後に続く「/(スラッシュ)」のときにTABを押そう。

  irbsh[12:47](main):027:0> open '~',
  ↓この状態でTABを押すとこのように展開。
  irbsh[12:47](main):027:0> open '/home/rubikitch',


  irbsh[12:47](main):027:0> open '~/',
  ↓この状態ならば / もついてくる。
  irbsh[12:47](main):027:0> open '/home/rubikitch/',


=== バッファ名の補完
((<EmacsバッファをFileオブジェクトとして扱う>))では「---」にバッファ名をはさむ形で指定するが、そのときにバッファ名の補完が使える。

  ↓scratch = ---*まで入力
  irbsh(main):089:0> scratch = ---*
  ↓*Completions*バッファに補完候補がぞろぞろと現れるのでscrまで入力。
  irbsh(main):089:0> scratch = ---*scr
  ↓TABを押す。ちゃんと---も補完されている。
  irbsh(main):089:0> scratch = ---*scratch*---

=== メソッド名/変数名補完
ついにメソッド名/変数名補完機能までつけてしまった。
端末上でirbを起動すると、readlineライブラリがロードされて、補完機能も使えるようになるが、これもEmacs上でできるのだ。
操作方法はTABで行うから端末上とまったく一緒なので詳しくはRubyソースコードパッケージについているdoc/irb/irb-tools.rd.jaを見てみよう。
これでいちいちメソッド名などを調べる手間は省ける。

これなしでは生きていけなくなるだろう。

== マルチラインバッファ

=== 複数行のコードを入力するには
Ver 0.6.0からの新機能としてマルチラインバッファが加わった。
複数行のRubyコードを簡単にirbsh上で実行できる。

起動方法は「C-c SPACE」である。
comint-modeにおいて複数行を一気にプロセスに送るのにこのキーバインドが選ばれているため、このキーに割り当てている。
コマンドラインを入力途中でC-c SPACEとすると、マルチラインバッファに入力途中のコマンドラインがペーストされる。

また、1.0.0からはマルチラインバッファに移行せずそのまま複数行入力できる。

一旦マルチラインバッファに入ると、通常のruby-modeでRubyコードが書ける。

=== マルチラインバッファのヒストリ
マルチラインバッファには専用のヒストリがついている。
マルチラインバッファの過去の入力を呼びもどすことができる。
M-p で過去側、M-nで未来側のヒストリを呼ぶ。

=== マルチラインバッファでのキー操作

マルチラインバッファの特殊機能がいくつかある。
: C-c C-c
    マルチラインバッファから抜け、その内容をirbshで実行する。

: C-c C-x
    マルチラインバッファの内容をirbshで実行するが、マルチラインバッファから抜けない。
    試行錯誤するのに向いている。

: C-c C-q
    直前のコマンドと出力を消す。irbsh上で実行するのと同じ。

: C-c C-e
    バッファの内容を消す。

: M-p
    ヒストリ呼び出し(過去側)

: M-n
    ヒストリ呼び出し(未来側)

== 内部コマンド
どれもオーバーロードされる可能性も考えて、短い名前と長い名前を用意している。

: pwd, irbsh_pwd
    カレントディレクトリを表示。

: cd( dir ), pushd, irbsh_cd
    カレントディレクトリの切り替え。
    cdでも自動的にディレクトリがスタックされる。

: popd, irbsh_popd
    いわゆるpopd。
    ディレクトリスタックをポップする。

: dirs
    ディレクトリスタックを表示する。

: ls( *argv ), irbsh_ls
    ファイルのリストを表示し、その結果を配列で返す。

: ll( *argv ), irbsh_ll
    ls -l を実行し、ファイルのリストを配列で返す。

: ni, irbsh_no_inspect
    普段はinspectで結果表示がなされるがこのコマンドを使うとto_sで結果を表示する。
    使い方は3通り。
    * a_object.ni

      レシーバに指定されたオブジェクトに適用。
    * ni expression

      expressionの評価結果に適用する。
    * ni { block }

      blockの実行結果に適用する。
    
: irbsh_system( cmd )
    irbshにてシェルコマンドを実行する。

: irbsh_alias( alias, definition )
    irbshでの((<シェルエイリアス機能>))を実現する。
    


== 評価リスト
Ver0.8.0からの新機能として「評価リスト」が加わった。
評価リストとは、評価したい式をあらかじめ登録しておき、ワンタッチで実行できるようにするためのものである。
何度も評価したい場合でも同じ式を何度も入力する必要がなくなる。

この機能がもっとも威力を発揮するとき、それはメソッドの動作を試行錯誤するときだ。
というわけで、評価リストはスクリプトと連動するように作られている。

評価リストの立ち上げ方は「C-c M-e」、実行は「C-c C-z」だ。

　評価リストバッファでM-C-vとするとirbshバッファがスクロールする。
M-C-yが逆スクロールである。

評価リスト機能はEmacsLispデバッガedebugの同等の機能をヒントにして作られた。

=== *ruby scratch*バッファ
irbshバッファにて「C-c M-e」を押すと画面が3分割される。
上に*ruby scratch*バッファ、下にirbshバッファと評価リストバッファとなる。
評価リストバッファのウィンドウが選択されるようになる。

　*ruby scratch*バッファはruby-modeで任意のRubyスクリプトを書くことができる。
また、評価リストバッファには評価したい式を続けて書くようになっている。
評価リストバッファの内容はirbで1文1文解釈されるので、複数個書いても全然平気だ。

評価リストに式を書いたあとは「C-c C-z」を押す！
この「C-c C-z」はirbshバッファでも評価リストバッファでも*ruby scratch*バッファでも、どのバッファにいてても有効だ。
　*ruby scratch*バッファの内容がloadされ、その直後に評価リストが評価されるようになる。

例を示そう。*ruby scratch*バッファに

  def f(x)
    x ** 2
  end

と書き、評価リストに
  f(0)
  f(1)
  f(2)
  f(3)
  s=---*ruby scratch*---;
  s.read.length
  
と書いたとき、irbshには次のように出力される。

なお、((<EmacsバッファをFileオブジェクトとして扱う>))機能や((<リージョンをFileオブジェクトとして扱う>))機能を評価リストで使ったとき、一時ファイルのファイル名がそのまま出てきてしまうのは仕様である。
((<出力を抑制|「;」出力を抑制>))する機能とあわせて0.9.0以降から使える。

  irbsh[27@16:03](main):085:0> 
  EvalList(main):086:0> f(0)
  0
  EvalList(main):087:0> f(1)
  1
  EvalList(main):088:0> f(2)
  4
  EvalList(main):089:0> f(3)
  9
  EvalList(main):090:0> s=open( '/tmp/irbshtmp256619ew' )
  (Output is disabled.)
  EvalList(main):091:0> s.read.length
  22
  EvalList(main):092:0> nil

最後のnilはゴミなので気にしなくてよい。
ここでも((<EmacsバッファをFileオブジェクトとして扱う>))などのirbsh独自の((<メタ変数>))が使えるし、「;」で出力を抑制することもできる。


スクリプトを変更したときでも一発で評価リストの内容を評価してくれる。
ここでf(x)の内容を次のように変更しよう。
  def f(x)
    x ** 3
  end
そして、「C-c C-z」を押す！
  irbsh[27@16:36](main):090:0> 
  EvalList(main):091:0> f(0)
  0
  EvalList(main):092:0> f(1)
  1
  EvalList(main):093:0> f(2)
  8
  EvalList(main):094:0> f(3)
  27
  EvalList(main):095:0> nil
たったこれだけで変更後のスクリプトを試すことができる！
わざわざセーブしたりするような手間が省けるのでとても便利だ、是非とも活用しよう。

　*ruby scratch*バッファでM-C-vとするとirbshバッファがスクロールする。
M-C-yが逆スクロールである。
評価リストが立ち上がっている状態でirbshバッファにてM-C-v, M-C-yを押すと、*ruby scratch*バッファがスクロールする。

=== 任意のruby-modeのバッファでもok
さきほど *ruby scratch* バッファでの例を示したが、実は任意のruby-modeのバッファでも可能だ。
ruby-modeのバッファ上で「C-c M-e」を押してみよう。
画面が3分割されてirbshバッファ、評価リストバッファが現れる。

以後、*ruby scratch*バッファも含め、ruby-modeなバッファを「スクリプトバッファ」と呼ぶことにする。

たとえば、以下のスクリプトtest.rbがあったとする。
  #!/usr/bin/env ruby
  def f(x)
    x ** 2
  end
  
  if __FILE__ == $0
    p f(10)
  end
そこで前の例と同じように評価リストに
  f(0)
  f(1)
  f(2)
  f(3)
と書いて「C-c C-z」を押すと、同じ結果がでてくる。

ここでポイントとなるのが
  if __FILE__ == $0
  end
でかこまれた部分だ。
その部分はスクリプトをコマンドとして実行するときのみ実行されるコードとなる。
よって、irbshでloadされるときには実行されないことに注意したい。

スクリプト開発でメソッドの動作を試行錯誤したいとき、メソッドを着実に作成したいときに評価リストを活用しよう！！
特に使い棄てスクリプトをさっさと作成するときに、
『このメソッドは確実に動いてほしいんだけど、かといってRubyUnit使うのは大袈裟だな』
という場合においては非常に威力を発揮する。

=== エラージャンプ機能
評価リストの大事な機能として、評価リスト実行中にエラーが発生したとき、スクリプトバッファのエラー箇所へジャンプする機能だ。
たとえば、スクリプトバッファの内容が以下のようになっているものとしよう。
わざとエラーを発生させていることに注意。
説明のために行番号をつけている。

  1: def f(x)
  2:   x ** 
  3: end
  4: 
  5: def g(x)
  6:   f(x)
  7: end

そして、評価リストを
  g 1
としよう。そこで「C-c C-z」すると当然のことながらエラーメッセージがでる。
  irbsh[29@18:09](main):014:0> 
  SyntaxError: /home/rubikitch/.irbsh_eval_tmp:3: parse error
  /home/rubikitch/.irbsh_eval_tmp:5: nested method definition
  def g(x)
        ^
  /home/rubikitch/.irbsh_eval_tmp:7: parse error
          from /home/rubikitch/src/irbsh/irbsh-lib.rb:418:in `load'
          from /home/rubikitch/src/irbsh/irbsh-lib.rb:418:in `irbsh_load_script_and_eval_eval_list'
          from (irbsh):14

/home/rubikitch/.irbsh_eval_tmpはスクリプトバッファを一時的に保存したファイルである。
デフォルトでは ~/.irbsh_eval_tmp に保存される。

そこで、「C-c `」を押すとスクリプトバッファの3行目に移る。
もう一度押すと5行目、もう一度押すと7行目に移る。
さらにもう一度押したら何も起きない。
スクリプトバッファすなわち .irbsh_eval_tmp でのエラー行へジャンプするようになっている。

なお、「C-u 数 C-c `」を押すとその数だけジャンプするようになる。
負の数を指定すると前のエラーメッセージへ戻る。

=== スクリプトバッファのみ実行

場合によっては、評価リストを実行するのではなくてスクリプトバッファのみを実行したいこともあろう。
ちょっとしたコード片の実験をするのに便利。
評価リストコマンドに数引数をつければ、スクリプトバッファのloadのみする。
すなわち「C-u C-c C-z」。

=== $IRBSH変数
irbsh実行中はグローバル変数の
  $IRBSH
がtrueになる。典型的な使い方は、
  if $IRBSH
    # irbsh内でのみ実行されるコード
  end
とスクリプトに書くことである。
irbsh実行時以外は当然nilになるのでスクリプトをコマンドで実行したりするときはその部分は無視される。

これは評価リストとともに使うと便利だ。
スクリプトバッファに
  if $IRBSH
    # 評価リストを使うための前処理・初期設定
  end
のように書いておけば評価リストが簡潔になって嬉しい。



== ワンライナー
emacsにおいて、M-!でシェルコマンド、M-:でLisp式を実行できるのは周知の通りである。
同じようにRubyの式を実行したいと思うだろう。
それを実現するのがここで述べるワンライナー機能である。

デフォルトでは「M-"」に割り当てられている。
実行すると
  Irbsh command [/home/rubikitch/src/irbsh]:
のようなプロンプトがでてくる。
その後に任意のRubyの式を入力することができる。
そのとき、[]内に表示されているカレントディレクトリへ移動してから実行するようになっている。

また、C-uを押して実行するとM-!やM-:と同様に実行結果がカレントバッファに挿入される。

ここでもirbsh拡張は生きている。
* スペースをあけるとシェルコマンド
* __region__や---buffername---といったメタ変数が使える
* 補完機能

ただ、ここで入力したRubyの式は改行が押された時点で評価されるようになっている。
そのため、複数行にわたる式は実行できない。((-いらないよね。あくまでワンライナーなんだし。面倒なので実装したくない。-))


== .irbshrc
irbshにおけるRuby側の設定は.irbrcに書いてもいいが、.irbshrcに書いてもよい。
設定ファイル上でirb側とirbsh側を分けたいという人は.irbshrcに書こう。
.irbshrcには.irbrcと同じく任意のRubyの文が書ける。

.irbshrcに書くべきものとしては以下のシェルエイリアスなんかがある。

=== シェルエイリアス機能
シェルの代表的な機能として、エイリアス機能がある。
エイリアス定義には irbsh_alias メソッドを使う。
書式は次の通り。

  irbsh_alias エイリアス, 定義

エイリアス、定義ともにシンボルか文字列である。

たとえば、「ls -F」を「lf」とエイリアスしたいとする。
このとき、以下のどちらかでエイリアスできる。
  * irbsh_alias :ls, 'ls -F'
  * irbsh_alias 'ls', 'ls -F'



=== プロンプトのカスタマイズ
バージョン0.4.4以降、プロンプトに現在時刻を表示するようにしている。
それを変えるにはプロンプトのフォーマット文字列(Irbsh.prompt)をカスタマイズすればよい。

# (view-rubyfile "doc/irb/irb.rd" "In the prompt specification, some special strings are available. ")

irb標準で用意されているのは以下のフォーマットが用意されている。
  %N        起動しているコマンド名が出力される.
  %m        mainオブジェクト(self)がto_sで出力される.
  %M        mainオブジェクト(self)がinspectされて出力される.
  %l        文字列中のタイプを表す(", ', /, ], `]'は%wの中の時)
  %NNi      インデントのレベルを表す. NNは数字が入りprintfの%NNdと同じ. 省略可能
  %NNn      行番号を表します.
  %%    %
irbshではそれらに加えて
  %D    年/月/日
  %d    月/日
  %T    時:分:秒
  %t    時:分
も使える。

たとえば、以前のバージョンの表示にするには(時刻表示を消す)、
  Irbsh.prompt = "%N(%m):%03n:%i> "
と.irbshrcへ加える。
=== pushdignoredups
バージョン0.4.4以降、ディレクトリスタックで同じディレクトリを含まないようにしている。
zshでいうpushdignoredupsである。
これを無効にするには、
  Irbsh.disable_pushdignoredups
と.irbshrcへ加える。
有効にするには
  Irbsh.enable_pushdignordups
とする。

=== systemecho
irbshは本来、シェルコマンドを実行するときに実行するコマンドラインを表示している。
冗長と思う人はそれを無効にできる。

  Irbsh.disable_systemecho

と.irbshrcへ加える。
有効にするには
  Irbsh.enable_systemecho
とする。  
== 応用

=== シェルのaliasをirbshのエイリアスにするには
たとえば、zshに次のようなエイリアスが定義されているとする。

  alias g="gnuclient.rb"
  alias edit="gnuclient.rb"

これをいちいち手で変換するのは面倒だ。
こういう場合は、.irbshrcに次のように書けばいいだろう。

  zsh_aliases = <<END
  alias g="gnuclient.rb"
  alias edit="gnuclient.rb"
  END

  zsh_aliases.each do |z|
    if /^alias +(.+)=['"](.+)['"]$/.match z 
      irbsh_alias $1, $2
    end
  end
    
=== windows.elとの共存
((<広瀬さんのwindows.el|URL:http://www.gentei.org/~yuuji/software/windows.el>))とirbshを併用するとき、デフォルトの設定ではn番目のirbshバッファへの切り替え(C-c 1 .. C-c 0)とかぶってしまう。
そのために、この機能を無効にしたり、別なキーバインドに設定できるようにしている。

==== どっちも使いたい！
その場合はwindows.el側が譲ることになる。
このコードを .emacs に挿入することでirbshのバッファ切り替えとwindows.elのwindow切り替えが共存できる。
この場合、window切り替えは M-1 .. M-9 としている。

  ;\M-1 .. \M-9 で window[1] .. window[9] の一発切り替え
  (progn
    (setq win:switch-prefix [esc])
    (define-key global-map win:switch-prefix nil)
    (define-key esc-map "1" 'win-switch-to-window)
    (define-key esc-map "2" 'win-switch-to-window)
    (define-key esc-map "3" 'win-switch-to-window)
    (define-key esc-map "4" 'win-switch-to-window)
    (define-key esc-map "5" 'win-switch-to-window)
    (define-key esc-map "6" 'win-switch-to-window)
    (define-key esc-map "7" 'win-switch-to-window)
    (define-key esc-map "8" 'win-switch-to-window)
    (define-key esc-map "9" 'win-switch-to-window)
    (define-key esc-map "0" 'win-toggle-window)
    (define-key esc-map "-" 'win-switch-menu)
    )

==== やっぱり無効でいいや
irbshのバッファ切り替えを無効にしたいときは、
  (setq irbsh-nth-buffer-key-function nil)
と.emacsに書く。
C-c 1 .. C-c 9 は従来通り windows.el のものとなる。

==== キーバインドを変える
irbshのバッファ切り替えのキーバインドを変える方法もある。
デフォルトの設定では、
  (setq irbsh-nth-buffer-key-function
    (lambda (i) (concat "\C-c" (int-to-string i))))
となっているが、たとえば C-c c 1 .. C-c c 9 に変えたい場合は、
  (setq irbsh-nth-buffer-key-function
    (lambda (i) (concat "\C-cc" (int-to-string i))))
のようにすればよい。


== 技術メモ
以下技術的なメモを。

=== メソッド名/変数名補完について
irb/completion.rbを使っている。
ただし、このライブラリでは強制的にreadlineがロードされるので、こんなことを書いてRubyを騙している（笑）。
ちょっとエグいかも。

  $" << "readline.so"
  module Readline; def self.complete_proc=(x); end; end
  require 'irb/completion'

=== comint-redirect.el
これはEmacs21ではcomint.elに統合されているのだが、それ以前のEmacsではこれを使わないといけない。
((-実はemacs21からimportしたもの。-))
プロセスの出力を他のバッファに「リダイレクト」することができて便利。

=== comint-util.el, cmdline-stack.el
これらはshell-modeなど他のcomintに流用できるので使いたい人はどうぞ。
キーバインドはirbshで割り当てられているものを書いているので、自分でdefine-keyしよう。

: comint-util.el
    (require 'comint-util)で使用可能。
    * comint-ctrl-p (C-p)
    * comint-ctrl-n (C-n)
    * comint-delete (C-c C-q)
    * comint-bol-2 (C-a)
    * comint-next-prompt-2 (C-c C-n)
    * comint-previous-prompt-2 (C-c C-p)

: cmdline-stack.el
    (require 'cmdline-stack)で使用可能。
    * cmdline-stack-push (M-q)
    * cmdline-stack-pop (これは C-m に割り当てればいいだろう)

=== シェルエイリアスの実装
シェルエイリアスは((<nq_*を定義する|quoteなしでRubyの文を実行>))ことで実現している。

  irbsh_alias :ls, 'ls -F'

を実行したら、

  def nq_ls( arg = '' )
    cmd = "ls -F #{arg}"
    irbsh_system cmd
  end
  
と定義するようになっている。

=== ワイルドカード展開の実装
((<ワイルドカード展開>))には、RubyのDir.globメソッドを使っている。
コマンドラインに文字列を書いてまだEnterしてない時点では、irbにはその文字列は送られない。
そのために、任意の文を割り込んで実行できる。
それでDir.globを実行し、テンポラリバッファにリダイレクトしてその結果を保存し、その内容を貼り付けているのである。

((<"メソッド名/変数名補完">))にも同じ技術が使われている。

=== プロンプト拡張
単にIRB::Irb#promptをコピー&ペーストで再定義・・・汚ねえ。

=== 制限・欠点
* ((<"メソッド名/変数名補完">))でTABを連打すると固まってしまうことがある。
  そのときはC-gを押して M-x irbsh-restart しよう。

=== TODO
* hookではなくてderived-modeでの実装
* ドキュメントのさらなる充実
* ((<マルチラインバッファ>))をより使いやすくしたい
* 「!機構」ヒストリ。
* カスタマイズ性の向上(^^;
* ログの保存。

##### [whats new]
== 更新履歴

: [2010/04/08] Ver 1.0.1
    * irbsh.elの表示上の不具合を修正
    * Ruby 1.9対応

: [2006/01/13] Ver 1.0.0   
    * EmacsLisp実行機能
    * オブジェクト編集機能
    * 英語のドキュメント
    * irbsh-toggle.el添付
    * さまざまなbugfix
    * お手軽メソッド定義

: [2003/12/21] Ver 0.9.3
    * インストーラを付属。
##### [/whats new]

: [2003/08/20] Ver 0.9.2
    * ドキュメント更新。
    * irbsh-history-file(~/.irbsh_history)ファイルに実行したコマンドの履歴を記録。nilに設定すると記録しない。

: [2003/08/12] Ver 0.9.1
    * bugfix。


: [2003/01/29] Ver 0.9.0
    * ((<出力をバッファに保存する|"「|」出力を別バッファに保存(リダイレクト)">))機能をbugfix。
    * ((<バックグラウンド実行>))機能の導入！
    * Emacs21において((<評価リスト>))実行後にC-rが正常に動作しないバグを修正。
    * 評価リストでniがうまく動作しないバグを修正。
    * 評価リストでメタ変数が使えるようにした。
    * 評価リストで;((<「;」出力を抑制>))が使えるようになった。
    * C-u C-c C-zで評価リストを実行せずに((<スクリプトバッファのみ実行>))(load)するようにした。
    * ((<ワンライナー>))を使うときにirbshが立ち上がっていない場合は自動でirbshを立ち上げるようにした。
    * ((<$IRBSH変数>))を導入。
    * option systemechoを導入。
    * Windows環境での不具合を修正。
    
      

: [2002/09/06] Ver 0.8.1
    * ((<ワンライナー>))を導入！
    * ((<出力をバッファに保存する|"「|」出力を別バッファに保存(リダイレクト)">))機能をbugfix。
    * スクリプトバッファ、評価リストバッファでM-C-vするとirbshバッファをスクロールするようにした。
    * irbshバッファでM-C-vするとスクリプトバッファをスクロールするようにした。
    * M-C-yでM-C-vの逆方向スクロール。
    

: [2002/08/29] Ver 0.8.0
    * ((<評価リスト>))の導入！
    * ((<マルチラインバッファ>))にも補完がきくようになった。

: [2002/04/12] Ver 0.6.1
    * 式の途中で改行を入れたとき、((<マルチラインバッファ>))へ自動的に移行するようになった！
      これで大幅に使い勝手が向上するはずだ。

: [2002/04/10] Ver 0.6.0
    * ((<マルチラインバッファ>))で複数行の式を容易に実行可能に。
    * コマンドラインにてC-wを1語削除、C-u C-wをkill-regionに。
    * goto-irbsh: cdしないようにした
    * ((<ヒストリメニュー>))関係。
      * 呼び出し後、呼び出し前のwindow-configurationを復帰させるようにした。
      * 高速化！
    * shellのコンテキストにて、スペースの入ったファイル名が扱えるようになった。
    * shellのコンテキストにて#{}内で__region__や---bufname---が使えるように。
    * rehashを廃止し、起動を高速化。
    * 雑多な高速化。
　  * ((<対応する括弧の挿入>))機能。

: [2002/01/11] Ver 0.5.3
    * emacs20で((<ヒストリメニュー>))の動作がおかしいのを修正。
    * ((<windows.elとの共存>))するために、*irbsh*1 .. *irbsh*9 へジャンプする機能を on/off できるようにした。

: [2002/01/06] Ver 0.5.2
    * emacs20で((<コマンド名補完>))ができなかったバグを修正。
    * C-uを元の動作に戻した。

: [2001/12/12] Ver 0.5.1
    * ((<ヒストリメニュー>))で、同一のコマンドヒストリをだぶって表示しないように(uniq)した。
    * ((<メソッド名/変数名補完>))で「a = forma(t)」などが補完されないバグを修正。

: [2001/12/10]
    * ((<irbについての注意>))を更新。

: [2001/12/09] Ver 0.5.0
    * ((<ヒストリメニュー>))機能を追加。
    * ((<ワイルドカード展開>))のバグを修正。
    * ((<コマンド名補完>))の機能を強化。zshの=commandも解釈するように。
    * ((<ホームディレクトリ展開>))機能を追加。
    * irb-0.8以降専用となる。
: [2001/12/06] Ver 0.4.4
    * プロンプトに現在時刻を表示できるようにした。
    * dirsコマンド追加。
    * ((<pushdignoredups>))も有効に。

: [2001/11/29] Ver 0.4.3
    * 雑多なbug fix。主にemacs20での動作のため。
    * C-c 1 .. C-c 9 に *irbsh*1 .. *irbsh*9 へのジャンプする機能を。
    * 新しくirbshを起動するときはプロセスが終了した *irbsh* バッファも使うようにした。
    * カレントディレクトリに「%」が含まれているときに誤動作するバグを修正。
    

: [2001/11/26] Ver 0.4.2
    * ((<irbsh-result-to-kill-ring|出力結果をkill-ringへ>))において、出力が完了するまで待つことに。
      これにより、キーボードマクロを使って出力を取り込むことも可能に。
    * shellのコンテキストなのに((<"メソッド名/変数名補完">))をしにいくことがあるバグを修正。
    * irbsh-util.rbを添付。irbshを使うのに便利なメソッドを集めたものである。

: [2001/11/23] Ver 0.4.1
    * make-temp-fileがないemacsenがあるので、互換性のために定義を追加。
    * post-command-hookをbuffer-localに。
    * ドキュメントに((<irbについての注意>))を追加。
    * .irbshに追加する設定をちょっと変更。
    * スクリーンショット追加。
: [2001/11/22] Ver 0.4.0
    * ((<ワイルドカード展開>))ができるようになった。
: [2001/11/21] 
    * ドキュメントの((<更新履歴>))を新しいもの順に。
    * プロンプトにコンテキストを明示するようになった。
    * ((<シェルエイリアスもどき|シェルエイリアス機能>))。
    * ((<魔法のC-a>))、((<"前/次のプロンプトへ飛ぶ">))を追加。
: [2001/11/20] Ver 0.3.0
    * ((<"シェルコマンド/Rubyのコンテキストを瞬時に切り替えする"|拡張されたコマンドたち>))機能追加。
    * ((<出力をバッファに保存する|"「|」出力を別バッファに保存(リダイレクト)">))機能を追加。
    * ((<補完|強力補完機能>))を大幅に強化。バッファ名、ディレクトリ名、メソッド/変数名での補完も可能に。
    * ((<リージョンをFileオブジェクトとして扱う>))機能を追加。
    * ((<端末上のシェルライクなキーバインド|拡張されたコマンドたち>))を可能に。
    * ((<出力結果をプロンプトもろともに消す機能|出力を消す>))を追加。
    * ((<quoteなしでRubyの文を実行>))する機能を追加。
    * ((<技術メモ>))を書いた。
: [2001/11/15] Ver 0.1.1
    * XEmacs対応のため、comint-bol-or-process-mark を入れる。
: [2001/11/15] Ver 0.1
    * とりあえず初公開バージョン。
    * RAAにもアップ。
: [2001/11/12]
    * 作りはじめる。

    
== ライセンス
著作権はるびきちにあり、GPLとします。
    
=end
