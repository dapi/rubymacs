=begin
= irbsh - IRB.extend ShellUtilities
$Id: irbsh.en.rd.r 1349 2006-08-22 07:40:53Z rubikitch $

: author
    rubikitch<rubikitch@ruby-lang.org>
: irbsh official site
    ((<URL:http://www.ruby-lang.org/~rubikitch/computer/irbsh/>))
: screenshot
    * ((<ScreenShot|URL:irbsh.jpg>))
    * ((<History Menu|URL:irbsh-history.jpg>))
    * ((<Eval List|URL:eval-list.jpg>))
    * ((<Background Shell|URL:bg.jpg>))


##### [abstract]
== About irbsh
Irbsh is an extension of irb/inf-ruby.el.
You can easily execute shell commands and Ruby codes by using irbsh.

Eval list feature makes irbsh be an development environment of Ruby.

While irbsh has many features, you can use easily.

== How is irbsh better than inferior-ruby
* Irbsh interprets command-line beginning from ' ' as shell command.
  * You can use Ruby's #{...} expansion.
  * It displays what command is executing.
  * It displays return status.
* Like shell-mode irbsh follows current-directory.
* You can insert 'system' method by two strokes.
* You can change the context (shell-command/Ruby-statement) by one stroke.
* If (command-line =~ /;$/) then irbsh disables output.
* If (command-line =~ /\|$/) then irbsh redirects output to another buffer.
* If (command-line =~ /&$/) then irbsh uses background shell or GNU screen.
* Intelligent completion.
  * buffer-name, shell-commands, file/directory-names, method/variable-names.
* Zsh-like command-line stack.
* Zsh-like wildcard expansion.
* You can load any Ruby scripts.
* You can call irbsh from any buffers.
* You can handle Emacs-region and Emacs-buffer as File object.
* Keybind is like shell at terminal.
* You can ((<Erase Output>)) and prompt when you execute wrong command-line.
* ((<Multi-line buffer>)) enables you to write multi-line input.
* ((<Eval List>)) executes pre-registered expressions.
* ((<*ruby scratch* buffer>)) is a scratch buffer for Ruby.
* ((<Oneliner>)) enables you to execute a Ruby expression any time.
* You can ((<edit objects with YAML|Editing objects with YAML>)).
* You can eval any EmacsLisp expressions.
* ((<Easy Method Definition>))

##### [/abstract]

##### [whats new]
== What's new

: [2010/04/08] Ver 1.0.1
    * Fix a display bug in irbsh.el
    * Ruby 1.9 compliant

: [2006/01/16] Ver 1.0.0
    * EmacsLisp sexp evaluation
    * Edit objects
    * English document
    * irbsh-toggle.el
    * many bugfixes
    * Easy Method Definition

: [2001/11/15] Ver 0.1
    Initial release

##### [/whats new]



##### [install]
== Download
You can download irbsh from ((<RAA:irbsh>)).

== Install
(0) Install Ruby and inf-ruby.el.
(1) Install by setup.rb.
      $ ruby setup.rb config
      $ ruby setup.rb setup
      # ruby setup.rb install

(2) Append the following to .irbrc
      load "irbsh-lib.rb" if IRB.conf[:PROMPT_MODE] == :INF_RUBY

(3) Append the following to .emacs
      (load "irbsh")
      (load "irbsh-toggle")

  or
      (when (locate-library "irbsh")
        (autoload 'irbsh "irbsh" "irbsh - IRB.extend ShellUtilities" t)
        (autoload 'irbsh-oneliner-with-completion "irbsh" "irbsh oneliner" t))
      (when (locate-library "irbsh-toggle")
        (autoload 'irbsh-toggle "irbsh-toggle" 
          "Toggles between the *irbsh*1 buffer and whatever buffer you are editing."
        t)
        (autoload 'irbsh-toggle-cd "irbsh-toggle" 
          "Pops up a irbsh-buffer and insert a "cd <file-dir>" command." t))

    If you see
      (file-error "Cannot open load file" "irbsh")
    error message, you append       
      (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/")
##### [/install]

=== Irb on Windows
Use this setting on Windows.
  (setq ruby-program-name "ruby -S irb --inf-ruby-mode")

== Invoke irbsh
  M-x irbsh

You can see irb prompt.

== How to use

=== Command-line stack
Irbsh has zsh-like command-line stack.
Those who are using zsh will explain here once, although you may fly.

For example:

You want to copy file, so you typed the following.(1)
  #(1)
  [pwd:~]
  irbsh(main):001:0> File::cp File::expand_path("~/.emacs"), "/tmp"

OOPS! You forgot to type require statement.
Be quiet, irbsh resques you.
Type `M-q', and the command-line is disappearred.(2)
  #(2)
  [pwd:~]
  irbsh(main):001:0> 

You cool it, and type require statement.(3)
  #(3)
  [pwd:~]
  irbsh(main):001:0> require 'ftools'

OH! The command-line typed past is returned.(4)
  #(4)
  irbsh(main):001:0> require 'ftools'
  true
  [pwd:~]
  irbsh(main):002:0> File::cp File::expand_path("~/.emacs"), "/tmp"

You come to a happy end.
Push Enter and irbsh executes file copy.(5)
  #(5)
  irbsh(main):001:0> require 'ftools'
  true
  irbsh(main):002:0> File::cp File::expand_path("~/.emacs"), "/tmp"
  true
  [pwd:~]
  irbsh(main):003:0> 

In addition, since the command line stack function is separated with `irbsh', `shell-mode' and `ielm-mode' can also be used.

=== Load Ruby script
If C-cC-f is pushed, the following is displayed in Emacs echo-area.
  Load file: ~/
Type the filename of Ruby script.

For example, the filename is ~/.irbrc, the following statement is inserted.
  irbsh(main):010:0> load '/home/rubikitch/.irbrc'

inf-ruby.el although `ruby-load-file' also carries out equivalent work.
Since a load sentence is specified, it turns out that it was loaded.

=== Multiple irbsh
Irbsh of another process is started by `C-cC-s'.
As for the buffer name, the number is added sequentially from 1 after *irbsh*.
It will be useful when working with other current directories.

Typing C-c 1 .. C-c 9 switches to the corresponding *irbsh* buffer.

=== Call irbsh from the buffer currently edited
Irbsh can be called from arbitrary buffers by typing `M-x goto-irbsh'. 
New irbsh is started while each *irbsh* buffers which exist now are using it.
When the cursor of a *irbsh* buffer does not point the command line, that *irbsh* buffer is USED.

Typing
  M-x irbsh-toggle
pops up *irbsh*1 buffer.
In *irbsh*1 buffer, irbsh-toggle restores the window configuration before calling up *irbsh*1 buffer.

=== Reboot irbsh
Irbsh is rebooted by typing `M-x irbsh-restart'.
i.e., the present irb process is killed, and rebooted.
Since the contents of current buffer are lost , it is careful.

=== Extended commands
When variable `irbsh-use-sigle-key-extension-flag' is t, operation of C-w, C-u, C-d, C-k, etc. will be extended. With a default It is t.

Respectively, the action on a command line changes, and it is ordinary operation when that is not on a command line.

: C-w
    1 word deletion.
: C-u
    All deletion about the line of a command line.
: C-d
    When it is in the tail end of a command line `'',' is inserted.
: C-k
    When it is in the tail end of a command line, toggles the top space.
    The context of the command line is changed.
    Whether it interprets as a sentence of Ruby or it interprets as a shell command change.
    After inputting a command, when it thinks, "This is a shell command", it will not waver but I will push this!
: C-o
    The same effect as `C-p C-w'.
    Convenient to perform the same command/method by other arguments.
: C-p
    The contents of the last command line are taken out.
    It is the same as M-p.
: C-n
    The contents of the following command line are taken out.
    It is the same as M-n.
: C-v
    Opening ((<History Menu>)).

=== Delete `,' at the end of line
Using C-d will remain `,' at the end of line.
If `irbsh-strip-last-comma-flag' is t,  typing Enter deletes `,' at the EOL.
Default value is t.
 Therefore, it is not necessary to delete by hand purposely.

  puts  C-d abc
  irbsh(main):083:0> puts 'abc',
  Typing Enter...
  irbsh(main):083:0> puts 'abc'
  abc
  nil

=== Output to kill-ring
Typing C-c C-k stores previous output to kill-ring.

=== Erase Output
Typing C-c C-q erases previous prompt and output.
It is useful if you execute wrong command line.

C-c C-o, standard comint command, erases previous output only.

  irbsh(*SHELL*):061:0>  ls ~/.eamcs
  ~ $ ls ~/.eamcs
  ls: /home/rubikitch/.eamcs: No such file or directory
  [pwd:~] (status = 256)
  irbsh(main):062:0> 
  Typing C-c C-q
  irbsh(main):062:0> 
  Re-entering right input
  irbsh(*SHELL*):062:0>  ls ~/.emacs
  ~ $ ls ~/.emacs
  /home/rubikitch/.emacs
  [pwd:~] (status = 0)
  irbsh(main):063:0> 
  Typing C-c C-o
  irbsh(*SHELL*):062:0>  ls ~/.emacs
  *** output flushed ***
  irbsh(main):063:0> 

=== Jump to previous/next prompt
C-c C-p / C-c C-n jump previous/next prompt.

=== Auto Quotation
C-c (, C-c {, C-c [, C-c ', C-c " prepare parenthesis.

=== Easy Method Definition

Irbsh provides special syntax of method definition.
  method_name (arguments) definition
This syntax is only accepted in the command line.

This syntax internally uses Module#define_method, so you can define a method containing local variables of current binding.

  irbsh[17@09:10](main):015:0> one () 1
  #<Proc:0xb7984740@(irbsh):15>
  irbsh[17@09:10](main):016:0> two = 2
  2
  irbsh[17@09:10](main):017:0> three_times (x) x*(one+two)
  #<Proc:0xb7978b84@(irbsh):17>
  irbsh[17@09:10](main):018:0> three_times 10
  30

Special syntax `defun' defines multi-line definition of method.

  irbsh[17@09:12](main):022:0> defun four()
                                 two+two
                               end
  #<Proc:0xb795abd4@(irbsh):22>
  irbsh[17@09:13](main):025:0> four
  4


== Terminator

=== `:' Disable output
If the command line is terminated by `:', irbsh does not display output.

  irbsh(main):008:0> Array.new 1000
  [nil, nil, nil...]
  irbsh(main):009:0> Array.new 1000;
  [pwd:/tmp] (Output is disabled.)
  irbsh(main):010:0> 

It is almost the same functionality as that of MATLAB.

=== `|' Redirect output
If the command line is terminated by `|', the output is saved into *irbsh output* buffer, specified by `irbsh-redirect-output-buffer'.

  irbsh(main):009:0> Array.new(3)|
  output is at #<buffer *irbsh output*>
  irbsh(*SHELL*):010:0>  ls ~/.emacs|
  output is at #<buffer *irbsh output*>

If `irbsh-display-redirect-output-buffer-flag' is t, default is nil, the output buffer is popped up.

=== `&' Background Shell
Just the same as Unix shells, if the command line is terminated by `&', the command is executed in the background.
This terminator is valid in the shell context.

  irbsh[29@07:58](*SHELL*):062:0>  ls &
  background process at #<buffer *ls*>

In this example, the output is saved into *ls* buffer, whose major-mode is irbsh-background-shell-mode derived by shell-mode.
The main differences are
* No shell prompts.
* When the process is terminated (like GNU Screen's zombie feature)
  * typing `q' kills buffer.
  * typing Enter redoes the command.

If `irbsh-use-screen' is t, irbsh uses GNU Screen instead of background shell.  

== As a command shell

=== Executing shell commands

In irbsh command line, an input matching /^ / is treated as shell command.
Irbsh displays the CONTEXT at the prompt.

  irbsh(*SHELL*):048:0>  pwd
  ~ $ pwd
  /home/rubikitch
  irbsh(main):049:0> a = 1
  1
  irbsh(*SHELL*):050:0>  echo #{a}
  ~ $ echo 1
  1
  [pwd:~] (status = 0)
 
=== irbsh_system

To execute shell commands with Ruby control structures, use `irbsh_system' method.
For convenience irbsh prepares shortcut.
Typing C-c C-m inserts `irbsh_system' method in the command line.

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

=== Changing current directory

When irbsh execute shell commands, it makes child process.
Executing `cd' in child process does not change current directory of parent process.
So when executing `cd'  in the shell context, changing current directory of irbsh.

  irbsh(*SHELL*):006:0>  cd
  "~"
  irbsh(*SHELL*):007:0>  cd /tmp
  "/tmp"
  [pwd:/tmp]

=== Command History
Irbsh implements command history.
Irbsh records inputs into `~/.irbsh_history', which is specified by `irbsh-history-file'.
If `irbsh-history-file' is nil, irbsh does not record history.

== Special Features

=== Dry run

For executing shell commands with complicated control structures, irbsh provides `dry-run feature'.
The command line is terminated by `$', shell commands are not executed.

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

=== Execute Ruby methods without quotations
Irbsh can execute Ruby methods without quotations by defining methods whose name match /^nq_/.
When passing arguments to nq_xxx method, the command line is splitted by spaces.
The example below shows how to pass arguments.
Note that ((<`ppp'|URL:http://www.rubyist.net/~rubikitch/computer/ppp/>)) is a small library to print local variables and so on.
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


=== History Menu
Irbsh provides history menu feature to paste previously input command line.
Typing C-v on the command line pops up *irbsh history* buffer containing previously input command lines.
Then select the history by typing a character before `:'.
To close the history menu, type C-v or `0'.

When the history menu is displaying, typing C-s and search query shows history which match the query. (history menu grep)

=== Meta Variables

To communicate irbsh and Emacs, there are meta variables.

==== Emacs Buffers as File Objects (read only)
When you want to use buffer contents in irbsh, use

`---BUFFER NAME---'

meta variable.
When irbsh finds this meta variable, the contents of buffer at this time is saved into temporary file and you can treat it as a File object.

For example, the contents of the *scratch* buffer is the following.

  ;; This buffer is for notes you don't want to save, and for Lisp evaluation.
  ;; If you want to create a file, visit that file with C-x C-f,
  ;; then enter the text in that file's own buffer.

And the irbsh session,

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

==== Regions as File Objects

In addition to buffers irbsh can treat regions as File objects.

To use this feature,
(1) Specify the region and type M-w / C-w to store it into the kill-ring.
(2) Use `__region__' meta variable in irbsh.

  irbsh(main):019:0> fbb = __region__
  #<File:0x402f62a4>
  irbsh(main):020:0> fbb.gets
  "foo bar baz"
  irbsh(main):021:0> fbb.rewind; fbb.read
  "foo bar baz"

=== Eval EmacsLisp sexps

Irbsh can eval EmacsLisp sexps.

  irbsh[13@18:30](*SHELL*):010:0>  el (setq a 2)
  2
  nil
  irbsh[13@18:30](main):011:0> EmacsLisp.el %((setq a (* 2 a))) 
  4
  nil

It is simple implementation to realize ((<object editor|Editing objects with YAML>)).
If you want to control Emacs in Ruby, use ((<el4r|URL:http://www.rubyist.net/~rubikitch/computer/el4r/>)).
El4r enables you to write Emacs applications in Ruby.

=== Editing objects with YAML
Irbsh enables you to edit objects using YAML.

  irbsh[13@18:30](main):012:0> s = "abcd"
  "abcd"
  irbsh[13@18:38](main):013:0> s.edit
  "editing object..."
  "ABCD"

When you execute
  s.edit
then irbsh pops up a buffer containing the YAML representation of `s'.
After editing the object, type C-c C-c to exit.

== Completion

One of the main features of irbsh is intelligent completion.

* common
  * file name completion
  * directory name of previous string
  * directory name completion of `cd'
  * wildcard expansion
  * home directory expansion
* Shell context
  * command name completion
  * file name completion
  * directory name of previous string
* Ruby context
  * buffer name completion of `---BUFFERNAME---'
  * method / variable name completion

=== Completion Examples

  irbsh(*SHELL*):076:0>  dpkg-bu
  typing TAB
  irbsh(*SHELL*):076:0>  dpkg-buildpackage 

  irbsh(*SHELL*):026:0>  ls =modpro
  typing TAB
  irbsh(*SHELL*):026:0>  ls =modprobe 

  irbsh(*SHELL*):077:0>  cat .zpro
  typing TAB
  irbsh(*SHELL*):077:0>  cat .zprofile
  
  irbsh(*SHELL*):077:0>  cat .zprofile compi
  typing TAB
  irbsh(*SHELL*):077:0>  cat .zprofile compile/

  irbsh(*SHELL*):077:0>  cat .zprofile compile/hog
  typing TAB
  irbsh(*SHELL*):077:0>  cat .zprofile compile/hoge 

  typing puts C-d .zpro
  irbsh(main):022:0> puts '.zpro',
  typing TAB
  irbsh(main):022:0> puts '.zprofile',
  typing C-e
  irbsh(main):022:0> puts '.zprofile',
  typing C-d
  irbsh(main):022:0> puts '.zprofile','',
  typing compi 
  irbsh(main):022:0> puts '.zprofile','compi',
  typing TAB
  irbsh(main):022:0> puts '.zprofile','compile/',

  irbsh(main):022:0> puts '.zprofile','compile/hoge',
  typing Enter 
  irbsh(main):022:0> puts '.zprofile','compile/hoge'

  irbsh(*SHELL*):091:0>  echo compi
  typing TAB
  irbsh(*SHELL*):091:0>  echo compile/
  typing foo SPC
  irbsh(*SHELL*):091:0>  echo compile/foo 
  typing TAB
  irbsh(*SHELL*):091:0>  echo compile/foo compile/
  typing ba TAB
  irbsh(*SHELL*):091:0>  echo compile/foo compile/bar 

  typing puts C-d compi
  irbsh(main):091:0> puts 'compi',
  typing TAB
  irbsh(main):091:0> puts 'compile/',
  typing fo TAB
  irbsh(main):091:0> puts 'compile/foo',
  typing C-e
  irbsh(main):091:0> puts 'compile/foo',
  typing TAB
  irbsh(main):091:0> puts 'compile/foo','compile/',
  typing ba TAB
  irbsh(main):091:0> puts 'compile/foo','compile/bar',
  typing Enter
  irbsh(main):091:0> puts 'compile/foo','compile/bar'

  irbsh(*SHELL*):032:0>  ls
  ~/src/irbsh $ ls
  GPL                  comint-redirect.el   irbsh.el                     irbsh.ja.html
  Makefile          comint-util.el       irbsh.elc             irbsh.ja.rd
  RCS                  irbsh-completion.rb  irbsh.ja.hindex.html
  cmdline-stack.el  irbsh-lib.rb               irbsh.ja.hindex.rd
  [pwd:~/src/irbsh] (status = 0)
  irbsh(*SHELL*):033:0>  ls *.el
  typing TAB
  irbsh(*SHELL*):033:0>  ls cmdline-stack.el irbsh.el comint-redirect.el comint-util.el 


  irbsh(*SHELL*):033:0>  ls {GPL,RCS}
  typing TAB
  irbsh(*SHELL*):033:0>  ls GPL RCS 

  cursor is after `~'
  irbsh[12:47](main):027:0> open '~',
  typing TAB  
  irbsh[12:47](main):027:0> open '/home/rubikitch',


  cursor is after `/'
  irbsh[12:47](main):027:0> open '~/',
  typing TAB
  irbsh[12:47](main):027:0> open '/home/rubikitch/',

  typing scratch = ---*
  irbsh(main):089:0> scratch = ---*
  typing scr
  irbsh(main):089:0> scratch = ---*scr
  typing TAB
  irbsh(main):089:0> scratch = ---*scratch*---
    
== Multi-line buffer
To execute multi-line Ruby expressions, irbsh provides multi-line buffer feature.
To pop up the multi-line buffer, type C-c SPC.
If command line is not empty, irbsh pastes it into the multi-line buffer.

=== Multi-line buffer history
The multi-line buffer provides its own history.
Type M-p/M-n to recall previously input.

=== Key binding of multi-line buffer

: C-c C-c
    Exit the multi-line buffer and eval the contents.
: C-c C-x
    Only eval the contents.
: C-c C-q
    Erase previous output. Same as irbsh.
: C-c C-e
    Erase the multi-line buffer.
: M-p, M-n
    History.
    
== Irbsh Builtin Commands

Irbsh provides some builtin commands, short name and long name.

: pwd, irbsh_pwd
    Display the current directory.
: cd(dir), pushd, irbsh_cd
    Change the current directory.
: popd, irbsh_popd
    Change the current directory to the previous one.
: dirs
    Print the directory stack.
: ls(*argv), irbsh_ls
    Print the file list and return it.
: ll(*argv), irbsh_ll
    Execute `ls -l' and return the file list.
: ni, irbsh_no_inspect
    Print the result with `to_s' (not inspect).
    * a_object.ni
    * ni expression
    * ni { block }
: irbsh_system(cmd)
    Execute in the shell context.
: irbsh_alias(alias, definition)
    Defining ((<Shell Aliases>)).
    
== Eval List
Another main feature is the eval list.
The eval list eases evaluation of pre-registered expressions.
If you want to eval the same expressions many times, you do not have to input the expressions in each case.

The eval list works with SCRIPT BUFFFER.
Script buffer means the ruby-mode buffer currently displaying.
When you EXECUTE the eval list, irbsh does
(1) save the script buffer into temporary script
(2) load the temporary script
(3) eval each expression in the eval list buffer

Type C-c M-e to visit the eval list.
Type C-c C-z to execute the eval list.
These key binding can be used in script, irbsh and eval list buffer.

=== *ruby scratch* buffer
When typing C-c M-e in an irbsh buffer, split the screen into three divisions.
The upper window displays *ruby scratch* buffer.
You can write any Ruby script in the *ruby scratch* buffer.

Here is a sample eval list session.

  ---- *ruby scratch*
  def f(x)
    x ** 2
  end

  ---- *irbsh eval list*
  f(0)
  f(1)
  f(2)
  f(3)
  s=---*ruby scratch*---;
  s.read.length
    
Then type C-c C-z, and irbsh displays

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

Modify the script buffer.

  ---- *ruby scratch*
  def f(x)
    x ** 3
  end

Then type C-c C-z,  

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

You do not have to save buffers!

If you scroll irbsh buffer in the eval list buffer or the script buffer, type M-C-v / M-C-y.

=== Any ruby-mode buffer

While the previous example uses the *ruby scratch* buffer as the script buffer, any ruby-mode buffer can be the script buffer.

=== Error jump with eval list

If any errors are occurred during eval list execution, type
  C-c ` 
to jump to the error occurrence.

Here is an example,
  ---- *ruby scratch*  (with line numbers)
  1: def f(x)
  2:   x ** 
  3: end
  4: 
  5: def g(x)
  6:   f(x)
  7: end

  ---- *irbsh eval list*
  g 1

Type C-c C-z. Then irbsh displays error messages.

  irbsh[29@18:09](main):014:0> 
  SyntaxError: /home/rubikitch/.irbsh_eval_tmp:3: parse error
  /home/rubikitch/.irbsh_eval_tmp:5: nested method definition
  def g(x)
        ^
  /home/rubikitch/.irbsh_eval_tmp:7: parse error
          from /home/rubikitch/src/irbsh/irbsh-lib.rb:418:in `load'
          from /home/rubikitch/src/irbsh/irbsh-lib.rb:418:in `irbsh_load_script_and_eval_eval_list'
          from (irbsh):14

Note that /home/rubikitch/.irbsh_eval_tmp is a temporary script whose content is the script buffer.

Type C-c `, Then irbsh jumps the line 3.
One more, irbsh jumps the line 5.
One more, irbsh jumps the line 7.

C-c ` can accept numeric argument (C-u NUMBER C-c `).

=== Load the script buffer only

C-u C-c C-z loads the script buffer.
It does not eval the eval list.

=== $IRBSH global variable

When irbsh is running, the global variable `$IRBSH' is true.
It is useful to use with eval list.

Typical usage is preparation for eval list.

  if $IRBSH
    # prepare for eval list
  end

== Oneliner

Irbsh oneliner is so called Ruby version of M-! / M-:.
Default key bind is M-".

When you type M-", a prompt like this appears.
  Irbsh command [/home/rubikitch/src/irbsh]:
Then you can input any Ruby expression(with irbsh extension).
When you type C-u M-", the evaluation result is inserted into current buffer.

== .irbshrc

`.irbshrc' is startup script of irbsh.
Normally when irb starts, it loads `.irbrc' as startup file.
When irbsh starts, it loads `.irbshrc' as well as `.irbrc'.


=== Shell Aliases

Irbsh can define shell aliases by `irbsh_alias' method.

  irbsh_alias ALIAS, DEFINITION

Alias and definition are Symbol or String.

For example, you want to define `ls -F' as `lf',

  irbsh_alias :ls 'ls -F'

or

  irbsh_alias 'ls', 'ls -F'

=== Prompt Customize

Irb's prompt is customizable.
Irbsh provides prompt specification about current time as well as irb's prompt specification.

# (view-rubyfile "doc/irb/irb.rd" "In the prompt specification, some special strings are available. ")
In the prompt specification, some special strings are available. 

  %N    command name which is running
  %m    to_s of main object (self)
  %M    inspect of main object (self)
  %l    type of string(", ', /, ]), `]' is inner %w[...]
  %NNi  indent level. NN is degits and means as same as printf("%NNd"). 
        It can be ommited
  %NNn  line number. 
  %%    %
  %D    year/month/day
  %d    month/day
  %T    hour:min:sec
  %t    hour:min 
 
If you want simple prompt, append the following to `~/.irbshrc'.
  Irbsh.prompt = "%N(%m):%03n:%i> "

=== pushdignoredups

Like zsh's pushdignoredups, irbsh does not duplicate directories in the directory stack.

If you want to disable pushdignoredups feature, append the following to `~/.irbshrc'.
  Irbsh.disable_pushdignoredups
If you want to enable it,
  Irbsh.enable_pushdignoredups

=== systemecho

Irbsh normally displays the command line when irbsh executes shell commands.
If you think it is verbose, add the following to `~/.irbshrc'.

  Irbsh.disable_systemecho

You can enable it by  

  Irbsh.enable_systemecho

== License
GPL

=end
