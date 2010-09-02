#!/usr/bin/env ruby
require 'fileutils'
require 'test/unit'
require 'tempfile'
require 'lib/irbsh-sub.rb'


class TestIrbshEl < Test::Unit::TestCase
  def self.def_test(*args, &block)
    meth = "test__" + args.join("__").gsub(/\-/, '_')
    define_method(meth, &block)
  end

#   el_require :gnuserv_compat
#   el_require :gnuserv
#   gnuserv_start
#   sleep 0.4
  add_to_list :load_path, File.expand_path("../data/emacs/site-lisp", Dir.scriptdir)
  el_load "irbsh.el"
  @@irbsh_test_buf = get_buffer("*irbsh*test")
  unless @@irbsh_test_buf
    @@irbsh_test_buf = call_interactively(:irbsh)
    with(:with_current_buffer) { rename_buffer "*irbsh*test" }
  end
  switch_to_buffer @@irbsh_test_buf
  until irbsh_in_first_command_line_p
    sleep 0.1
  end
  delete_region point_min, point_at_bol

  def sleep_until_prompt
    sleep 0.1
  end
  
  def insert_and_back(before, after)
    insert before
    with(:save_excursion) { insert after }
  end

  # Initial state:
  #   current-buffer: @@irbsh_test_buf
  #   one-window-p == true
  #   point == point-max
  def setup
    switch_to_buffer @@irbsh_test_buf
    delete_other_windows
    goto_char point_max
    @tmp = "**tmp**"
  end

  def teardown
    set_buffer @@irbsh_test_buf
    goto_char point_max
    end_of_line
    comint_kill_input
  end

  def tmpbuf(x={}, &block)
    newbuf(x.update(:name=>@tmp), &block)
  end


  def_test("irbsh-in-string-extention-p") do
    tmpbuf(:contents=>" a") {
      assert_nil(irbsh_in_string_extention_p)
    }
    tmpbuf(:contents=>' a#{}') {
      assert_nil(irbsh_in_string_extention_p)
    }
    tmpbuf {
      insert_and_back ' a #{', '}'
      assert(irbsh_in_string_extention_p)
    }
    tmpbuf {
      insert_and_back ' a #', '{}'
      assert_nil(irbsh_in_string_extention_p)
    }
    tmpbuf {
      insert_and_back ' a ', '#{}'
      assert_nil(irbsh_in_string_extention_p)
    }
  end

  def_test("irbsh-command-line-as-shell-p") do
    tmpbuf(:contents=>"irbsh[23@10:37](main):137:0> ") {
      assert_nil(irbsh_command_line_as_shell_p)
    }
    tmpbuf(:contents=>"irbsh[23@10:37](*SHELL*):137:0>  ") {
      assert(irbsh_command_line_as_shell_p)
    }
    tmpbuf(:contents=>"irbsh[23@10:37](main):137:0>  ") {
      assert(irbsh_command_line_as_shell_p)
    }
  end

  def_test("irbsh-in-shell-command-line-p") do
    tmpbuf(:contents=> "irbsh[23@10:37](*SHELL*):137:0>  ") {
      assert_equal(true, irbsh_in_shell_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](*SHELL*):137:0> 1 ") {
      assert_equal(nil, irbsh_in_shell_command_line_p)
    }
    tmpbuf {
      insert_and_back "irbsh[23@10:37](main):137:0> irbsh_system %Q(", ") "
      assert_equal(true, irbsh_in_shell_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](main):137:0> irbsh_system %Q(ls) ") {
      assert_equal(nil, irbsh_in_shell_command_line_p)
    }
    tmpbuf(:contents=>"Irbsh command [/home/rubikitch/src/irbsh]:  "){
      let(:irbsh_in_oneliner, true) {
        assert_equal(true, irbsh_in_shell_command_line_p)
      }
    }

    tmpbuf(:contents=>"Irbsh command [/home/rubikitch/src/irbsh]: "){
      let(:irbsh_in_oneliner, true) {
        assert_equal(nil, irbsh_in_shell_command_line_p)
      }
    }

  end

  def_test("irbsh-in-command-line-p") do
    tmpbuf(:contents=> "> ") {
      assert_equal(nil, irbsh_in_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](main):137:0>  ") {
      assert_equal(true, irbsh_in_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](main):137:1>  ") {
      assert_equal(true, irbsh_in_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](*SHELL*):137:0> ") {
      assert_equal(true, irbsh_in_command_line_p)
    }
    let(:irbsh_in_oneliner, true) {
      assert_equal(true, irbsh_in_command_line_p)
    }
  end

  def_test("irbsh-in-first-command-line-p") do
    tmpbuf(:contents=> "> ") {
      assert_equal(nil,irbsh_in_first_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](main):137:0>  ") {
      assert_equal(true,irbsh_in_first_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](main):137:1> ") {
      assert_equal(nil,irbsh_in_first_command_line_p)
    }
    tmpbuf(:contents=> "irbsh[23@10:37](*SHELL*):137:0> ") {
      assert_equal(true,irbsh_in_first_command_line_p)
    }
    let(:irbsh_in_oneliner, true) {
      assert_equal(true, irbsh_in_first_command_line_p)
    }
  end

  def send_input(str)
    begin
      insert str
      irbsh_send_input
    ensure
      sleep_until_prompt
    end
  end

  def_test("irbsh-command-line-string") do
    assert_equal('', irbsh_command_line_string)

    insert "a"
    assert_equal('a', irbsh_command_line_string)
  end

  def_test("irbsh-search-command-line-string") do
    send_input "1+1"
    assert_equal('1+1', irbsh_search_command_line_string)
  end

  def_test("irbsh-ready-p") do
    assert(irbsh_ready_p(@@irbsh_test_buf))
  end

  def_test("irbsh-find-ready-buffer") do
    assert_equal('*irbsh*test', buffer_name(irbsh_find_ready_buffer))
  end

  def_test("irbsh-buffer") do
    assert_equal('*irbsh*test', buffer_name(irbsh_buffer))  # ready

    begin
      random_buffer = "*irbsh*_#{$$}_"
      switch_to_buffer random_buffer
      funcall(elvar.irbsh_major_mode)
      assert_equal(random_buffer, buffer_name(irbsh_buffer))
    ensure
      kill_buffer random_buffer
    end
  end

  def_test("irbsh-position-is-in-this-line-p", "one-line") do
    tmpbuf(:contents=>"12") {
      assert_equal(true, irbsh_position_is_in_this_line_p(1))
      assert_equal(true, irbsh_position_is_in_this_line_p(2))
    }
  end

  def_test("irbsh-position-is-in-this-line-p", "multi-lines") do
    tmpbuf {
      insert_and_back "1\n34", "5\n7"

      assert_equal(nil,irbsh_position_is_in_this_line_p(1))
      assert_equal(nil,irbsh_position_is_in_this_line_p(2))
      assert_equal(true,irbsh_position_is_in_this_line_p(3))
      assert_equal(true,irbsh_position_is_in_this_line_p(4))
      assert_equal(true,irbsh_position_is_in_this_line_p(5))
      assert_equal(true,irbsh_position_is_in_this_line_p(6))
      assert_equal(nil,irbsh_position_is_in_this_line_p(7))
      assert_equal(nil,irbsh_position_is_in_this_line_p(9999))
    }
  end

  def_test("irbsh-delete-previous-word", "shell") do
    tmpbuf(:contents=>"irbsh[23@10:37](*SHELL*):137:0>  ls /foo/bar/baz") {
      assert(irbsh_delete_previous_word)
      assert_equal("irbsh[23@10:37](*SHELL*):137:0>  ls /foo/bar/", buffer_string)
    }
 
    tmpbuf(:contents=>"irbsh[23@10:37](*SHELL*):137:0>  ls /") {
      irbsh_delete_previous_word
      assert_equal("irbsh[23@10:37](*SHELL*):137:0>  ls ", buffer_string)
    }
  end

  def_test("irbsh-delete-previous-word", "ruby") do
    tmpbuf(:contents=>'irbsh[23@10:37](main):137:1> puts("a")'){
      irbsh_delete_previous_word
      assert_equal(")", char_after.chr)
      assert_equal('irbsh[23@10:37](main):137:1> puts(")', buffer_string)
    }
    tmpbuf(:contents=>'irbsh[23@10:37](main):137:1> puts["a"]'){
      irbsh_delete_previous_word
      assert_equal("]", char_after.chr)
      assert_equal('irbsh[23@10:37](main):137:1> puts["]', buffer_string)
    }
    tmpbuf(:contents=>'irbsh[23@10:37](main):137:1> puts{"a"}'){
      irbsh_delete_previous_word
      assert_equal("}", char_after.chr)
      assert_equal('irbsh[23@10:37](main):137:1> puts{"}', buffer_string)
    }
    tmpbuf(:contents=>'irbsh[23@10:37](main):137:1> puts "a"'){
      irbsh_delete_previous_word
      assert_equal(nil, char_after)
      assert_equal('irbsh[23@10:37](main):137:1> puts "', buffer_string)
    }
    
    
  end

  def_test("irbsh-delete-command-line") do
    insert "foobarbaz"
    irbsh_delete_command_line
    assert_equal("", irbsh_command_line_string)
  end


  def_test("irbsh-toggle-command-line-context") do
    assert_equal(nil,  irbsh_command_line_as_shell_p)
    assert_equal(true, irbsh_toggle_command_line_context)
    assert_equal(true, irbsh_command_line_as_shell_p)
    assert_equal(true, irbsh_toggle_command_line_context)
    assert_equal(nil,  irbsh_command_line_as_shell_p)
  end

  def_test("irbsh-previous-input-delete-previous-word") do
    send_input "puts 123"
    goto_char point_max
    begin
      assert_equal(true, irbsh_previous_input_delete_previous_word)
      assert_equal("puts ", irbsh_command_line_string)
    ensure
      irbsh_delete_command_line
    end
  end  

  def_test("irbsh-delete-line") do
    tmpbuf {
      insert_and_back "1", "\n2\n"
      irbsh_delete_line
      assert_equal("2\n", buffer_string)
    }
  end

  def_test("irbsh-delete-needless-lines") do
    tmpbuf(:contents=>"1\n[pwd:~]\n") {
      irbsh_delete_needless_lines
      assert_equal("1\n", buffer_string)
    }
    tmpbuf(:contents=>"1\nEvalList(a):1:0> nilnil\n") {
      irbsh_delete_needless_lines
      assert_equal("1\n", buffer_string)
    }
    tmpbuf(:contents=>"1\nEvalList(a):1:0> nilnil\n[pwd:~]\n" ) {
      irbsh_delete_needless_lines
      assert_equal("1\n", buffer_string)
    }
  end

  def_test("irbsh-strip-last-comma") do
    let(:irbsh_strip_last_comma_flag, true) {
      tmpbuf(:contents=>"puts \"a\","){
        irbsh_strip_last_comma
        assert_equal("puts \"a\"", buffer_string)
      }
    }
    let(:irbsh_strip_last_comma_flag, nil) {
      tmpbuf(:contents=>"puts \"a\","){
        irbsh_strip_last_comma
        assert_equal("puts \"a\",", buffer_string)
      }
    }
    
  end

  def irbsh_send_input_with_other_buffer(buf)
    switch_to_buffer @@irbsh_test_buf
    with(:save_selected_window) { switch_to_buffer_other_window buf }
    irbsh_send_input

    assert( one_window_p )
    assert( window_live_p(get_buffer_window(@@irbsh_test_buf)) )
    assert_equal( nil, get_buffer(elvar.irbsh_hm_menu_buffer) )
  end

  def_test("irbsh-send-input", "delete-window","1") do
    irbsh_send_input_with_other_buffer elvar.irbsh_hm_menu_buffer
  end
  
  def_test("irbsh-send-input", "delete-window","2") do
    irbsh_send_input_with_other_buffer "*Completions*"
  end

  def_test("irbsh-send-input", "no-exec") do
    bufstr_before = buffer_string

    send_input "   "
    bufstr_after = buffer_string

    assert_equal(bufstr_after, bufstr_before)
  end

  def_test("irbsh-send-input", "strip-last-comma") do 
    begin
      elvar.irbsh_strip_last_comma_flag = nil
      assert_equal '"a",', send_input("\"a\",")
    ensure
      send_input "1\n"
    end
      
    begin
      elvar.irbsh_strip_last_comma_flag = true
      assert_equal '"a"', send_input("\"a\",")
    end
  end

  def goto_pre_prompt_line
    re_search_backward elvar.inferior_ruby_first_prompt_pattern, nil, true
    forward_line -1
  end

  def_test("irbsh-send-input", "delete-needless-lines") do
    send_input "10"

    with(:save_excursion) {
      goto_char point_max
      goto_pre_prompt_line
      assert_equal(true, looking_at( elvar.irbsh_pwd_regexp ) )

      goto_pre_prompt_line
      assert_equal(nil,  looking_at( elvar.irbsh_pwd_regexp ) )
    }
  end

  def_test("irbsh-send-input", "history") do
    history = Tempfile.new "irbshhist"
    elvar.irbsh_history_file = history.path

    goto_char point_max
    send_input "4+4"
    send_input "8+8"

    assert_equal("4+4\n8+8\n", history.read)
  end

  def_test("irbsh-send-input", "cmdline-stack") do
    insert "100"
    cmdline_stack_push
    send_input "200"

    begin
      with(:save_excursion) {
        assert_equal("100", irbsh_search_command_line_string)
      }
    ensure
      irbsh_send_input
    end
  end

  def_test("irbsh-send-input", "redirect") do
    # FIXME! redirect
  end


  def_test("irbsh-chomp") do
    assert_equal("abc", irbsh_chomp("abc\n"))
    assert_equal("abc", irbsh_chomp("abc"))
    assert_equal("", irbsh_chomp("\n"))
    assert_equal("", irbsh_chomp(""))
  end

  def_test("irbsh-replace-meta-variables", "buffer") do
    assert_equal("---non-exist-buffer---", irbsh_replace_meta_variables("---non-exist-buffer---"))
    
    res = irbsh_replace_meta_variables "---*scratch*---"
    m = res.match /^open\( '(.+)' \)/
    assert(m)
    saved_file_name = m[1]
    scratch = bufstr "*scratch*"
    assert( scratch == File.read(saved_file_name) )

    # multiple occurrences
    res = irbsh_replace_meta_variables "---*scratch*--- and ---*irbsh*test---"
    assert_equal(2, res.scan(/open\(/).length)
  end  

  def_test("irbsh-replace-meta-variables", "region") do
    kill_ring_save(point_at_bol,point)
    region = buffer_substring_no_properties(point_at_bol,point)
    res = irbsh_replace_meta_variables "__region__"

    assert_match(/^open\(/, res)

    m = res.match /^open\( '(.+)' \)/
    assert(m)
    saved_file_name = m[1]
    assert( region == File.read(saved_file_name) )
  end

  # function nullification
  def noop_function(func)
    begin
      defadvice(func, :around, :noop, :activate) {}
      yield
    ensure
      ad_deactivate_regexp "noop"
    end
  end

  def_test("irbsh-input-filter0") do
    elvar.irbsh_use_cd_without_quote_flag = nil
    assert_equal("cd a", irbsh_input_filter0("cd a"))
    elvar.irbsh_use_cd_without_quote_flag = true
    assert_equal('irbsh_cd %q[/tmp]', irbsh_input_filter0("cd /tmp"))
    
    assert_equal("1", irbsh_input_filter0("1"))

    noop_function(:irbsh_oneliner) do 
      assert_equal "'output is at #<buffer *irbsh output*>'.ni", irbsh_input_filter0("1 |")
    end
  end

  def_test("irbsh-bg") do
    elvar.irbsh_use_screen = nil
    assert_equal("background process at #<buffer *ls*>", irbsh_bg("ls"))
    assert_equal(true, buffer_live_p(get_buffer("*ls*")))
    sleep 0.09
    kill_buffer "*ls*"
  end

  def_test("irbsh-super") do
    # FIXME!
    # not yet tested
  end


  def prompt_string
    buffer_substring_no_properties(point_at_bol, point)
  end

  def_test("irbsh-toggle-prompt-line") do
    prompt_ruby  = "irbsh[25@16:01](main):166:0> "
    prompt_shell = "irbsh[25@16:01](*SHELL*):166:0> "

    elvar.irbsh_display_context_at_prompt_flag = true
    
    tmpbuf(:contents=>"#{prompt_ruby} "){
      funcall elvar.irbsh_major_mode
      irbsh_toggle_prompt_line
      assert_equal("#{prompt_shell} ", prompt_string)
    }

    tmpbuf(:contents=>"#{prompt_ruby}"){
      funcall elvar.irbsh_major_mode
      irbsh_toggle_prompt_line
      assert_equal(prompt_ruby, prompt_string)
    }

    tmpbuf(:contents=>"#{prompt_shell} "){
      funcall elvar.irbsh_major_mode
      delete_backward_char 1
      irbsh_toggle_prompt_line
      assert_equal(prompt_shell, prompt_string)
    }
  end

  def previous_output
    set_buffer @@irbsh_test_buf
    beginning_of_line
    e = point
    re_search_backward elvar.inferior_ruby_first_prompt_pattern, nil, true
    forward_line 1
    b = point
    output = buffer_substring_no_properties b, e
  end

  def_test("irbsh-output-filter", "eval-list") do
    # FIXME!
    # not yet tested
    newbuf(:name=>"*irbsh eval list*", :contents=>"1;\n2")
    set_buffer newbuf(:name=>"*ruby scratch*", :content=>"1")
    ruby_irbsh_eval_list_load_and_eval nil
    sleep 0.05
  end

  def_test("irbsh-output-filter", "default-directory") do
    pwd = Dir.pwd
    send_input " cd /"
    assert_equal "/", elvar.default_directory
    send_input " cd #{pwd}"
  end

#   def_test("irbsh-output-filter", "irbsh-elisp") do
#     elvar.irbsh_elisp_hoge = 100
#     send_input " el (setq irbsh-elisp-hoge 12345)"
#     sleep 0.1
#     assert_equal 12345, elvar.irbsh_elisp_hoge
#     assert_match /12345/, previous_output

#     # Long string
#     send_input " el (setq irbsh-elisp-hoge (make-string 2000 ?a))"
#     sleep 0.1
#     assert_equal "a"*2000, elvar.irbsh_elisp_hoge
#   end

  def_test("irbsh-output-filter", "self") do
    send_input "1"
    assert_equal "main", elvar.irbsh_prompt_self

    send_input "irb Object"
    assert_equal "Object", elvar.irbsh_prompt_self
    send_input "exit"
    assert_equal "main", elvar.irbsh_prompt_self
  end



  def_test("irbsh-result-to-kill-ring") do
    send_input "100*2"

    irbsh_result_to_kill_ring
    newbuf(:name=>@tmp) {
      yank
      assert_equal("200", buffer_string)
    }
  end


  def completion_eq?(expected, cmdline, &pre_condition)
    # pre_condition block is comment purpose 
    block_given? and assert(yield(cmdline))

    begin
      insert cmdline
      irbsh_dynamic_complete
      assert_equal(expected, irbsh_command_line_string)
    ensure
      end_of_line
      comint_kill_input
    end
  end
  

  def_test("irbsh-dynamic-complete", "irbsh-expand-tilde") do
    home = ENV['HOME']
    if home
      completion_eq?(" ls #{home}",  " ls ~") {|s| s[-1,1] == '~'}
      completion_eq?(" ls #{home}/", " ls ~/"){|s| s[-2,2] == '~/'}
      #completion_eq?("File.exist? '#{home}/", "File.exist? '~/") {|s| s[-2,2] == '~/'}
    end
  end


  def using_temp_dir
    with_temp_dir do |dir|
      begin
        send_input " cd #{dir}"
        yield dir
      ensure
        send_input " cd"
      end
    end
  end    

  def_test("irbsh-dynamic-complete", "irbsh-expand-glob", "irbsh-dynamic-complete-filename") do
    using_temp_dir do |dir|
      %w[a.txt a.bmp a.jpg b.txt].each {|f| open(f, "w"){}}
      last_word_is_glob = lambda{|s| s.split(/ /)[-1]=~/[\]\[\}\{\*\?]/}
      
      glob_expanded = Dir['*.txt'].join(" ")      # "a.txt b.txt" or "b.txt a.txt"
      completion_eq?(" ls #{glob_expanded} ", " ls *.txt") {|x| last_word_is_glob[x]}
      completion_eq?(" ls a.bmp ", " ls ?.bmp") {|x| last_word_is_glob[x]}
      completion_eq?(" ls *.pdf ", " ls *.pdf") {|x| last_word_is_glob[x] && Dir['*.pdf'].empty? }
      completion_eq?(" ls b.txt ", " ls b") {|x| Dir["#{x.split(/ /)[-1]}*"] == ['b.txt']}
    end
  end


  def_test("irbsh-dynamic-complete", "irbsh-dynamic-complete-bufname") do
    completion_eq?("buf = ---*irbsh*test---", "buf = ---*irbsh*tes") {|x| x =~ /---/}
    completion_eq?("buf = ---non-exist-buffer", "buf = ---non-exist-buffer") {|x| x =~ /---/}
  end

  def_test("irbsh-dynamic-complete", "irbsh-dynamic-complete-dirname") do
    using_temp_dir do |dir|
      FileUtils.mkpath "a_directory/a_sub_directory"
      open("a_file", "w"){}
      open("a_directory/another_file", "w"){}

      completion_eq?(" cd a_directory/", " cd a") {|x| a = x.split[0]=='cd'}
      completion_eq?(" cd a_directory/a_sub_directory/", " cd a_directory/a") {|x| a = x.split[0]=='cd'}
    end
  end

  def_test("irbsh-dynamic-complete", "irbsh-dynamic-complete-command") do
    completion_eq?(" lspci ", " lspc") if File.executable?("/usr/bin/lspci")

    using_temp_dir do |dir|
      let(:exec_path, [dir]) do
        command = "a_command"
        open(command, "w"){|f| f.chmod 0777}
        assert(File.executable?(command))
        completion_eq?(" a_command ", " a") # x:command
      end
    end
  end
  
  def_test("irbsh-dynamic-complete", "irbsh-dynamic-complete-directory-part") do
    completion_eq?(" ls /usr/bin/env /usr/bin/", " ls /usr/bin/env ")
    completion_eq?(%['/usr/bin/xx',  '/usr/bin/',], %['/usr/bin/xx',  ])
    completion_eq?(%["/usr/bin/xx",  "/usr/bin/",], %["/usr/bin/xx",  ])
  end
  
  def_test("irbsh-dynamic-complete", "irbsh-dynamic-complete-method") do
    send_input "aaaaaaaaaa=1"
    completion_eq?("aaaaaaaaaa", "aa")  # variable
    completion_eq?("Object.singleton_methods", "Object.singleton_me") # method
  end
  

  def_test("irbsh-make-history-menu", "all") do
    # prepare
    erase_buffer
    send_input "1"
    #

    send_input "1"
    send_input "2"
    send_input "3"

    irbsh_make_history_menu
    assert_equal(<<EOB.chomp, bufstr(elvar.irbsh_hm_menu_buffer))
a: 3
s: 2
d: 1
EOB
  end

  
  def_test("irbsh-make-history-menu", "grep") do
    newbuf(:name=>elvar.irbsh_hm_menu_buffer){
      elvar.buffer_read_only = nil
    }

    # prepare
    erase_buffer
    send_input "1"
    #

    send_input "1"
    send_input "2"
    send_input "3"

    
    irbsh_make_history_menu "2"
    assert_equal(<<EOB.chomp, bufstr(elvar.irbsh_hm_menu_buffer))
a: 2
EOB
  end

  def oneliner(expr)
    irbsh_oneliner(expr)
    bufstr("*irbsh output*")
  end

  def_test("irbsh-oneliner") do
    assert_equal "1", oneliner("1")

    assert_equal %q["a\""], oneliner(%q['a"'])
    assert_equal %q["a\""], oneliner(%q["a\""])

    assert_equal %q["a\""], oneliner(%Q['a\"'])
    assert_equal 'a\"'.dump, oneliner(%q['a\"']) # VERY VERY CONFUSING
  end

  def_test("ruby-irbsh-eval-list-load-and-eval") do 
    newbuf(:name=>"*irbsh eval list*", :contents=>"$ev")
    newbuf(:name=>"*ruby scratch*", :contents=>"$ev = 12345", :display=>:pop)
    ruby_irbsh_eval_list_load_and_eval nil
    sleep 0.05
    assert_match /12345/, previous_output
    
    newbuf(:name=>"*ruby scratch*", :contents=>"$ev = 43210")
    ruby_irbsh_eval_list_load_and_eval true # no eval
    sleep 0.05
    assert_no_match /12345/, previous_output
    send_input "$ev"
    assert_match /43210/, previous_output
  end

#   def_test("irbsh-edit-object") do
#     send_input "a='a'"
#     send_input "a.edit"

#     set_buffer "*irbsh edit object*"
#     erase_buffer
#     insert "--- AAAA\n"
#     irbsh_edit_finish

#     assert_match /AAAA/, previous_output
#   end

end

__END__
require 'aspectr'

$benchlog = $>

class BenchAspect < AspectR::Aspect
  def preAdvice(method, object, exitstatus, *args)
    @starttime = Time.now
  end
  def postAdvice(method, object, exitstatus, *args)
    bench = Time.now - @starttime
    $benchlog.puts "#{method}:#{bench} secs"
  end
end

ma = BenchAspect.new
#ma.wrap(TestIrbshEl, :preAdvice, :postAdvice, /^test/)

