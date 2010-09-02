require 'rubyunit'
require 'irbsh-lib.rb'
require 'irb'
require 'irbsh-util'
require 'stringio'

class TestIrbsh < RUNIT::TestCase

  include Irbsh
  def setup
    self.test_mode = true
  end
    

  def test_s_config_yes_or_no
    Irbsh.config_yes_or_no :foo
    enable_foo
    assert_equal(true, foo?)
    disable_foo
    assert_equal(false, foo?)
  end


  def test_eval_and_cat_multi_line_file
    file = Tempfile.path "1+1"
    io = StringIO.new
    ret = eval_and_cat_multi_line_file(file, binding, io)
    assert_equal(<<EOM, io.string)

#### MULTI-LINE BEGIN ####
1+1
#### MULTI-LINE END ####
EOM
    assert_equal(2,ret)
  end

  def test_irbsh_alias
    irbsh_alias("fooBarBaz", "echo fooBarBaz")
    assert_equal(true, respond_to?("nq_fooBarBaz"))
    assert_equal("echo fooBarBaz ", nq_fooBarBaz())
  end

  def test_irbsh_cd
    pwd = Dir.pwd
    Thread.current[:irb_directory_stack] = []

    assert_equal("/", irbsh_cd("/"){Dir.pwd})
    assert_equal(pwd, Dir.pwd)

    assert_equal("/tmp", irbsh_cd("/tmp"))
    assert_equal("/", irbsh_cd("/"))
    assert_equal([pwd, "/tmp"], Thread.current[:irb_directory_stack])
  end

  def test_irbsh_expand_exec_path
    with_temp_dir do |dir|
      d1 = dir+"d1"
      d2 = dir+"d2"
      d3 = dir+"d3"
      [d1,d2,d3].each{|d| d.mkdir}
      env_path="#{d1}:#{d2}:#{d3}"

      # does not exist
      assert_equal(nil, irbsh_expand_exec_path("foocmd", env_path))

      # exists, but not executable
      foocmd = d2+"foocmd"
      open(foocmd, 'w').close
      assert_equal(nil, irbsh_expand_exec_path("foocmd", env_path))

      # executable
      foocmd.chmod(0755)
      assert_equal(foocmd.to_s, irbsh_expand_exec_path("foocmd", env_path))

      # d3 is not executed
      foocmd_2 = d3+"foocmd"
      open(foocmd_2, "w").close
      foocmd_2.chmod(0755)
      assert_equal(foocmd.to_s, irbsh_expand_exec_path("foocmd", env_path))
    end
      
  end

  def test_irbsh_expand_glob
    io = StringIO.new ""
    irbsh_expand_glob("non_exist_file", io)
    assert_equal("non_exist_file\n", io.string)

    io = StringIO.new ""
    irbsh_expand_glob("~/*", io)
    filelist = Dir[ File.expand_path("~/*") ].join(" ") << "\n"
    assert_equal(filelist, io.string)

  end

  def test_irbsh_load_script_and_eval_eval_list
    
  end

  
  def test_irbsh_ls_ll
    with_temp_dir do
      files = %w[a1 a2 b1 b2 c]
      expand = lambda{|f| File.expand_path f}
      files.each{|fn| open(fn,'w').close}

      # ls a* b* 
      ls = %w[a1 a2 b1 b2].map(&expand)
      assert_equal(ls, irbsh_ls("a*", "b*") )
      assert_equal(ls, irbsh_ll("a*", "b*") )

      # ls *
      ls = files.map(&expand)
      assert_equal(ls, irbsh_ls())
      assert_equal(ls, irbsh_ls("*"))

      # ls non-exist-file
      assert_equal([], irbsh_ls("non-exist-file"))
    end
      
    
  end

  def test_irbsh_popd
    Thread.current[:irb_directory_stack] = []
    pwd = Dir.pwd
    irbsh_cd "/"
    irbsh_cd "/tmp"

    
    assert_equal("/", irbsh_popd)
    assert_equal("/", Dir.pwd)
    assert_equal(pwd, irbsh_popd)
    assert_equal(pwd, Dir.pwd)
    assert_exception(RuntimeError){ irbsh_popd }
  end

  def test_irbsh_pwd
    oldpwd = Dir.pwd
    Dir.chdir "/"
    assert_equal("/", irbsh_pwd)
    if ENV['HOME']
      Dir.chdir ENV['HOME']
      assert_equal("~", irbsh_pwd)

      tmpdir = "~/_irbsh_tmp_____"
      d = Pathname.new(tmpdir).expand_path
      d.mkpath
      Dir.chdir d
      assert_equal(tmpdir, irbsh_pwd)
      Dir.chdir oldpwd
      d.rmdir
    end
    
    
  end


  class IrbshSystemTester
    include Irbsh
    def initialize(str)
      @output = ""
      @str = str
    end
    attr_reader :output, :system_strings

    def run
      irbsh_system @str
    end

    def system(*args)
      super
      @system_strings = args
    end

    def puts(s)
      @output << s << "\n"
    end
  end

  module ::IRB                  # mock IRB
    def self.return_format=(*args)
    end
    def self.this_return_format(*args)
    end
  end

  def test_irbsh_system
    cmd = "ruby -e ''"
    x = IrbshSystemTester.new(cmd)
    x.run
    assert_equal([cmd], x.system_strings)

    x = IrbshSystemTester.new(cmd)
    Irbsh.enable_dryrun
    x.run 
    assert_equal("#{pwd}(dryrun) $ #{cmd}\n", x.output)

    cmd = "a"
    x = IrbshSystemTester.new(cmd)
    def x.nq_a(arg) true end
    assert_equal(true, x.run)
    def x.nq_a() true end
    assert_equal(true, x.run)

    x = IrbshSystemTester.new("a x y")
    def x.nq_a(x,y) x+y end
    assert_equal("xy", x.run)


  end

  def test_make_completion_elisp
    make_completion_elisp("st", lisp="", %w[start star])
    assert_equal(<<EOM, lisp)
(setq string "st")
(setq irbsh-tmp-cands '("__region__" "start" "star" ))
EOM
    # '
  end

  def test_nq_which
    assert_equal("aaaz: external", nq_which("aaaz"))
    
    irbsh_alias "aaaz", "echo aaaz"
    r1="aaaz: aliased to echo aaaz"
    assert_equal(r1, nq_which("aaaz"))

    def nq_foob () end
    r2="foob: nq_foob"
    assert_equal(r2, nq_which("foob"))

    # multiple arguments
    assert_equal("#{r1}\n#{r2}", nq_which("aaaz", "foob"))
    
  end

  def test_str2lstr
    #  ruby string,    elisp string
    [ [ "a", '"a"' ],
      [ 'unquote "double-quoted"', '"unquote \"double-quoted\""'],
      [ '\a', '"\\\\a"'],
    ].each {|rstr,lstr| assert_equal(lstr, str2lstr(rstr))}
  end

end

